//
//  MainViewController.swift
//  LearnGeniePrototype
//
//  Created by Артем Чмиленко on 01.05.2023.
//

import UIKit

class MainViewController: UICollectionViewController, AddCourseDelegate, UIContextMenuInteractionDelegate{
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    let addButton = UIButton(type: .custom)
    let buttonSize: CGFloat = 50.0
    
    let engine = Engine()
    
    let promptList = Prompts()
    
    var selectedIndexPath: IndexPath?
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        floatButtonProperties()
        
        let apiKeyKeychain = KeychainManager(service: Bundle.main.bundleIdentifier! + ".apiKey.")

        do {
            let apiKeyData = try apiKeyKeychain.load(forKey: "apiKey")
            let apiKey = String(data: apiKeyData, encoding: .utf8)
            print("API key is: \(apiKey ?? "not found")")
        } catch let error as KeychainError {
            if case KeychainError.unhandledError(let status) = error, status == errSecItemNotFound {
                askUserForAPIKey()
            } else {
                print("Error loading API key: \(error)")
            }
        } catch {
            print("Unexpected error: \(error)")
        }


        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = .dark
        }
        
        let settingsImage = UIImage(systemName: "gear")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let settingsButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(openSettings))
        navigationItem.rightBarButtonItem = settingsButton
        
        title = "LearnGenie"
        
        courses = retrieveCoursesFromUserDefaults() ?? [Course]()
    }
    
    func floatButtonProperties() {
        addButton.frame = CGRect(x: view.frame.width - buttonSize - 20, y: view.frame.height - buttonSize - 40, width: buttonSize, height: buttonSize)
        addButton.backgroundColor = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1.0)
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.darkGray.cgColor
        addButton.layer.cornerRadius = buttonSize / 2
        addButton.setTitle("+", for: .normal)
        addButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: 2, right: 0)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
        addButton.addTarget(self, action: #selector(openAddCourseView), for: .touchUpInside)
        

        // Add the button to the view
        view.addSubview(addButton)
    }
    
    @objc func openSettings() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "settings") else { return }
        present(vc, animated: true)
    }
    
    func askUserForAPIKey() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "enterApiKeyView") as? EnterApiKeyView else {return}
        present(vc, animated: true)
    }
    
    
    @objc func reload () {
        collectionView.reloadData()
    }
    
    @objc func openAddCourseView() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "addCourse") as? AddCourseViewController else { return }
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func requestCourse(name: String, description: String, iconName: String, expirience: String) {
        let prompt = promptList.topicsPrompt.replacingOccurrences(of: "{courseName}", with: name)
        
        courseName = name
        courseIcon = iconName
        asignTo = "course"
        
        courses.insert(Course(name: name, icon: iconName, description: description, topics: []), at: 0)
        
        let indexPath = IndexPath(item: 0, section: 0)
        
        collectionView.performBatchUpdates({collectionView.insertItems(at: [indexPath])}, completion: { (finished) in
            let insertedCell = self.collectionView.cellForItem(at: indexPath) as! CollectionCell
            insertedCell.completedTopics.text = "Creating modules, please wait!"
            insertedCell.completedTests.text = ""
        })
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
    
        self.engine.getRequestResult(prompt: prompt) {
            DispatchQueue.main.async {
                cell.completedTopics.text = "Completed topics: 0"
                cell.completedTests.text = "Completed tests: 0"
                self.collectionView.reloadData()
            }
        }
    }
    
    func insertCollectionCell() {
        
    }
    
    @objc func askForCourse () {
        for crs in courses{
            print(crs.name)
        }
        let prompts = Prompts()
        let ac = UIAlertController(title: "New course", message: "Anything you want from your new course. We love details!", preferredStyle: .alert)
        ac.addTextField()
        present(ac, animated: true)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            [weak ac] _ in
            guard let newCourse = ac?.textFields?[0].text, !newCourse.isEmpty else { return }
            let prompt = prompts.topicsPrompt.replacingOccurrences(of: "{courseName}", with: newCourse)
            print(prompt)
            courseName = newCourse
            self.engine.getRequestResult(prompt: prompt) {
                print("hello")
            }
            asignTo = "course"
        }))
    }
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionCell
        cell.titleText.text = courses[indexPath.item].name
        cell.iconName = courses[indexPath.item].icon
        cell.completedTopics.text = "Completed lessons: \(completedLessonsCount(courseIndex: indexPath.item))"
        cell.completedTests.text = "Comleted tests: 0"
            
        // Add long press gesture recognizer to cell
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        cell.addGestureRecognizer(longPress)
        
        // Add context menu interaction to cell
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            // Create a UIContextMenuConfiguration with your menu items
            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
                let pin = UIAction(title: "Pin", image: UIImage(systemName: "pin")) { action in
                    // Handle edit action
                }
                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                    courses.remove(at: indexPath.item)
                    self.collectionView.reloadData()
                    saveCoursesToUserDefaults()
                }
                return UIMenu(title: "", children: [pin, delete])
            }

            return configuration
        }
        
        // ...


    @objc func didLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            // Get the cell that was long pressed
            guard let cell = gestureRecognizer.view as? UICollectionViewCell else {
                return
            }
            
            // Get the index path of the cell
            guard let indexPath = collectionView.indexPath(for: cell) else {
                return
            }
            
            // Do something with the index path, such as storing it in a property to use later
            self.selectedIndexPath = indexPath
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "tvc") as? TopicViewController
        let selectedCourse = courses[indexPath.row]
        
        vc?.topics = selectedCourse.topics
        vc?.courseIndex = indexPath.row
        vc?.title = selectedCourse.name
        
        navigationController?.pushViewController(vc!, animated: true)
    }
        
    }
