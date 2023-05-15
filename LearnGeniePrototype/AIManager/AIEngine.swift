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
var courseIcon = ""
var asignTo = ""
var responseMessage = ""

class Engine {
    
    func loadApiKey() -> String {
        let apiKeyKeychain = KeychainManager(service: Bundle.main.bundleIdentifier! + ".apiKey.")
        var userApiKey: String?
        do {
            let apiKeyData = try apiKeyKeychain.load(forKey: "apiKey")
            guard let apiKey = String(data: apiKeyData, encoding: .utf8) else {fatalError("No api key provided")}
            userApiKey = apiKey
        } catch let error as KeychainError {
            if case KeychainError.unhandledError(let status) = error, status == errSecItemNotFound {
                print("API key not found in keychain")
            } else {
                print("Error loading API key: \(error)")
            }
        } catch {
            print("Unexpected error: \(error)")
        }
        return userApiKey ?? "No api key provided"
    }

    
    func getRequestResult(prompt: String, completion: @escaping () -> Void) {
        
        isRequestInProgress = true
        
        var apiKey = loadApiKey()
        let endpoint = "https://api.openai.com/v1/chat/completions"
        
        let postData = try! JSONSerialization.data(withJSONObject: [
            "model": "gpt-3.5-turbo",
            "messages": [["role": "user", "content": "\(prompt)"]],
            "temperature": 0.7
        ] as [String : Any], options: [])
        
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
                completion() // call completion handler when request is complete
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
            appendModules(name: courseName, content: responseMessage)
            
            saveCoursesToUserDefaults()
        case "topic":
            addTopic(content: responseMessage)
            saveCoursesToUserDefaults()
        case "subTopicBody":
            courses[requestedCourseIndex].topics[requestedTopicIndex].subTopics[requestedSubTopicIndex].subTopicBody = responseMessage
            saveCoursesToUserDefaults()
        default:
            fatalError("")
        }
    }
        
        func appendModules(name: String, content: String) {
            let separatedContent = content.components(separatedBy: "\n")
            
            for topic in separatedContent {
                courses[0].topics.append(Course.Topic(subTopics: [], topicName: topic))
            }
        }
        
        func addTopic(content: String) {
            let separatedContent = content.components(separatedBy: "\n")
            
            for topic in separatedContent {
                courses[requestedCourseIndex].topics[requestedTopicIndex].subTopics.append(Course.Topic.SubTopic(subTopicName: topic, subTopicBody: ""))
            }
            let topics = courses[requestedCourseIndex].topics[requestedTopicIndex].subTopics.count
            print(topics)
        }
        
}
