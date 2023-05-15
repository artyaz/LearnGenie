//
//  TopicViewController.swift
//  LearnGeniePrototype
//
//  Created by Артем Чмиленко on 25.04.2023.
//

import UIKit

class TopicViewController: UITableViewController{
    
    let engine = Engine()
    
    var loadingCell: UITableViewCell?
    
    var courseIndex = 0
    
    var topics = [Course.Topic]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Topic", for: indexPath)
        cell.textLabel?.text = topics[indexPath.row].topicName
        let selectedCourse = courses[courseIndex].topics[indexPath.row]

        if selectedCourse.subTopics.isEmpty {
            let downloadImage = UIImage(systemName: "arrow.down.circle")
            cell.accessoryView = UIImageView(image: downloadImage)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCourse = courses[courseIndex].topics[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "stvc") as? SubTopicTableViewController
        
        if !isRequestInProgress && selectedCourse.subTopics.isEmpty {
            let cell = tableView.cellForRow(at: indexPath)
            loadingCell = cell
            let loadingIndicator = UIActivityIndicatorView(style: .medium)
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.startAnimating()
            cell?.accessoryView = loadingIndicator
            loadingIndicator.startAnimating()
        }

        if isRequestInProgress && selectedCourse.subTopics.isEmpty {
            showAlert(alertTitle: "Course is still generating", alertText: "Please, wait until finish")
            return
        }

        var includedTopics = ""

        for topic in courses[courseIndex].topics {
            includedTopics += "\(topic.topicName)\n"
        }

        includedTopics.replacingOccurrences(of: courses[courseIndex].topics[indexPath.row].topicName, with: "")

        if selectedCourse.subTopics.isEmpty {
            asignTo = "topic"
            requestedCourseIndex = courseIndex
            requestedTopicIndex = indexPath.row
            Engine().getRequestResult(prompt: Prompts().subTopicPrompt
                .replacingOccurrences(of: "{courseName}", with: courses[courseIndex].name)
                .replacingOccurrences(of: "{topicName}", with: courses[courseIndex].topics[indexPath.row].topicName)
                .replacingOccurrences(of: "{includedTopics}", with: includedTopics)) {
                    DispatchQueue.main.async {
                        self.stopCellAnimation()
                    }
                }
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }

        vc?.subTopics = selectedCourse.subTopics
        vc?.courseIndex = courseIndex
        vc?.topicIndex = indexPath.row
        vc?.title = selectedCourse.topicName

        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func stopCellAnimation() {
        if let loadingIndicator = loadingCell?.accessoryView as? UIActivityIndicatorView {
            loadingIndicator.stopAnimating()
            loadingCell?.accessoryView = nil
        }
    }

    
    func showAlert(alertTitle: String, alertText: String){
        let ac = UIAlertController(title: alertTitle, message: alertText, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .cancel))
        present(ac, animated: true)
    }

}
