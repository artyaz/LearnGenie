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
    var icon: String
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

func completedLessonsCount(courseIndex: Int) -> Int {
    var count = 0
    for topic in courses[courseIndex].topics{
        for lesson in topic.subTopics {
            if !lesson.subTopicBody.isEmpty{
                count += 1
            }
        }
    }
    return count
}
