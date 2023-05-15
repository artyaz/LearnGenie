//
//  SubTopicTableViewController.swift
//  LearnGeniePrototype
//
//  Created by Артем Чмиленко on 28.04.2023.
//

import UIKit

class SubTopicTableViewController: UITableViewController {
    
    var loadingCell: UITableViewCell?
    
    var courseIndex = 0
    var topicIndex = 0
    
    var subTopics = [Course.Topic.SubTopic]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subTopics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubTopicCell", for: indexPath)
        cell.textLabel?.text = subTopics[indexPath.row].subTopicName
        
        let selectedCourse = courses[courseIndex].topics[topicIndex].subTopics[indexPath.row]
        
        if selectedCourse.subTopicBody.isEmpty{
            let downloadImage = UIImage(systemName: "arrow.down.circle")
            cell.accessoryView = UIImageView(image: downloadImage)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "tbvc") as? TopicBodyViewController
        let selectedCourse = courses[courseIndex].topics[topicIndex].subTopics[indexPath.row]
        
        if !isRequestInProgress && selectedCourse.subTopicBody.isEmpty {
            let cell = tableView.cellForRow(at: indexPath)
            loadingCell = cell
            let loadingIndicator = UIActivityIndicatorView(style: .medium)
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.startAnimating()
            cell?.accessoryView = loadingIndicator
            loadingIndicator.startAnimating()
        }
        
        if isRequestInProgress && selectedCourse.subTopicBody.isEmpty {
            showAlert(alertTitle: "Course being generated", alertText: "Wait until finish")
            return
        }
        
        if selectedCourse.subTopicBody.isEmpty {
            asignTo = "subTopicBody"
            
            requestedCourseIndex = courseIndex
            requestedTopicIndex = topicIndex
            requestedSubTopicIndex = indexPath.row
            
            var nextTopic: String?
            if courses[courseIndex].topics.count > topicIndex + 1{
                nextTopic = courses[courseIndex].topics[topicIndex + 1].topicName
            }
            
            let topicName = courses[courseIndex].topics[topicIndex].topicName
            let subTopicName = courses[courseIndex].topics[topicIndex].subTopics[indexPath.row].subTopicName
            
            Engine().getRequestResult(prompt: Prompts().bodyPrompt
                .replacingOccurrences(of: "{courseName}", with: courses[courseIndex].name)
                .replacingOccurrences(of: "{topicName}", with: topicName)
                .replacingOccurrences(of: "{subTopicName}", with: subTopicName)
                .replacingOccurrences(of: "{nextTopic}", with: nextTopic ?? "Conclusion")){
                    DispatchQueue.main.async {
                        self.stopCellAnimation()
                    }
                }
            tableView.deselectRow(at: indexPath, animated: true)
            return
            
        }
        
        vc?.body = selectedCourse.subTopicBody
        vc?.title = selectedCourse.subTopicName
        
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
