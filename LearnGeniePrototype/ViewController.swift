//
//  ViewController.swift
//  LearnGeniePrototype
//
//  Created by Артем Чмиленко on 24.04.2023.
//

import UIKit

class ViewController: UITableViewController, EngineDelegate {
    
    let engine = Engine()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(askForCourse))
        
        navigationController?.isToolbarHidden = false
        
        engine.delegate = self
        
        courses = retrieveCoursesFromUserDefaults() ?? [Course]()
    }
    
    
    func didAddCourse() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    
    @objc func reload () {
        tableView.reloadData()
    }
    
    @objc func askForCourse () {
        
        let prompts = Prompts()
        let ac = UIAlertController(title: "New course", message: "Anything you want from your new course. We love details!", preferredStyle: .alert)
        ac.addTextField()
        present(ac, animated: true)

        ac.addAction(UIAlertAction(title: "Cancel", style: .default))

        // Add a check to see if a course name was entered
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            [weak ac] _ in
            guard let newCourse = ac?.textFields?[0].text, !newCourse.isEmpty else { return }
            let prompt = prompts.topicsPrompt.replacingOccurrences(of: "{courseName}", with: newCourse)
            print(prompt)
            courseName = newCourse
            self.engine.getRequestResult(prompt: prompt)
            asignTo = "course"
        }))
        

       
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = courses[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "tvc") as? TopicViewController
        let selectedCourse = courses[indexPath.row]
        
        vc?.topics = selectedCourse.topics
        vc?.courseIndex = indexPath.row
        vc?.title = selectedCourse.name
        
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Remove the course from the array
                courses.remove(at: indexPath.row)
                
                // Remove the course from userdefaults
                saveCoursesToUserDefaults()
                
                // Delete the row from the table view
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    
    func showAlert(alertTitle: String, alertText: String){
        let ac = UIAlertController(title: alertTitle, message: alertText, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .cancel))
    }

}

