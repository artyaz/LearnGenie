//
//  AIEngine.swift
//  LearnGeniePrototype
//
//  Created by Артем Чмиленко on 28.04.2023.
//

import Foundation

var requestedSubTopicIndex = 0
var requestedTopicIndex = 0
var requestedCourseIndex = 0
var isRequestInProgress = false
var courseName = ""
var asignTo = ""
var responseMessage = ""

protocol EngineDelegate: AnyObject {
    func didAddCourse()
}

class Engine {
    weak var delegate: EngineDelegate?
    func getRequestResult(prompt: String) {
        
        
        
        isRequestInProgress = true
        
        let apiKey = "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"
        let endpoint = "https://api.openai.com/v1/chat/completions"
        
        let postData = try! JSONSerialization.data(withJSONObject: [
            "model": "gpt-3.5-turbo",
            "messages": [["role": "user", "content": "\(prompt)"]],
            "temperature": 0.7
        ], options: [])
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                isRequestInProgress = false
                self.getContent(json: json)
            }
        }
        
        task.resume()
    }
    
    func getContent(json: Any) {
        print(json)
        if let jsonDict = json as? [String: Any],
           let choices = jsonDict["choices"] as? [[String: Any]],
           let message = choices[0]["message"] as? [String: Any],
           let content = message["content"] as? String {
            responseMessage = content
            asignValue()
        }
    }
    
    func asignValue() {
        switch asignTo {
        case "course":
            addCourse(name: courseName, content: responseMessage)
            
            saveCoursesToUserDefaults()
        case "topic":
            addTopic(content: responseMessage)
            saveCoursesToUserDefaults()
        case "subTopicBody":
            courses[requestedCourseIndex].topics[requestedTopicIndex].subTopics[requestedSubTopicIndex].subTopicBody = responseMessage
            delegate?.didAddCourse()
            saveCoursesToUserDefaults()
        default:
            fatalError("")
        }
    }
        
        func addCourse(name: String, content: String) {
            let separatedContent = content.components(separatedBy: "\n")
            
            courses.append(Course(name: name, description: "" ,topics: []))
            for topic in separatedContent {
                courses[courses.endIndex - 1].topics.append(Course.Topic(subTopics: [], topicName: topic))
            }
            delegate?.didAddCourse()
        }
        
        func addTopic(content: String) {
            let separatedContent = content.components(separatedBy: "\n")
            
            for topic in separatedContent {
                courses[requestedCourseIndex].topics[requestedTopicIndex].subTopics.append(Course.Topic.SubTopic(subTopicName: topic, subTopicBody: ""))
            }
            let topics = courses[requestedCourseIndex].topics[requestedTopicIndex].subTopics.count
            print(topics)
            delegate?.didAddCourse()
        }
        
}
