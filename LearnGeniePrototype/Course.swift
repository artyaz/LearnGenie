//
//  Course.swift
//  LearnGeniePrototype
//
//  Created by Артем Чмиленко on 24.04.2023.
//

import Foundation

var courses = [Course]()

struct Course: Codable {
    var name: String
    var description: String
    var topics: [Topic]

    struct Topic: Codable {
        struct SubTopic: Codable {
            var subTopicName: String
            var subTopicBody: String
        }
        var subTopics: [SubTopic]
        var topicName: String
    }
}
    
    func saveCoursesToUserDefaults() {
        let defaults = UserDefaults.standard
        let coursesData = try? JSONEncoder().encode(courses)
        defaults.set(coursesData, forKey: "courses")
    }

    func retrieveCoursesFromUserDefaults() -> [Course]? {
        let defaults = UserDefaults.standard
        guard let coursesData = defaults.data(forKey: "courses"),
              let courses = try? JSONDecoder().decode([Course].self, from: coursesData)
        else {
            return nil
        }
        return courses
    }
