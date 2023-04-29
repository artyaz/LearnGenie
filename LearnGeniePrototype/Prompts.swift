//
//  Prompts.swift
//  LearnGeniePrototype
//
//  Created by Артем Чмиленко on 26.04.2023.
//

import Foundation
class Prompts {
    let topicsPrompt = """
    As an artificial intelligence tasked with generating topics about {courseName}, your goal is to provide accurate and professional course topics that are relevant to the subject matter of the {courseName}.     Your response should consist of numbered points only and address the following:
        1.    The easy to understand teaching style and approach to the course material.
        2.    The types of topics that would be appropriate and relevant to the course.
        3.    The significance and practical applications of these topics in the field.
        4.    The potential impact of including or excluding these topics in the course.
        5.    Based on the complexity of the course, create a sufficient number of topics that will be exactly enough to understand the topic even for a student without any knowledge
    Please ensure that your suggestions are well-researched and tailored specifically to the course in question. Answer should consist of numbered points(like 1. 2. 3. 4. 5.) only and nothing else. Dont use 1.1, 1.2, also dont make space between text lines. One topic shoud contain 2-4 words maximum.
    based on the complexity of the course(if you thing its hard and need a lot of work or it easy and can be learned by few topics), generate up to 20 topіcs
    """
    let subTopicPrompt = """
    You need to generate few sub-topics(based on the complexity of topic, it may be more than few if needed) for the topic {topicName} of course {courseName}
    here's topics that already included to course, so please dont reapeat them!:
    {includedTopics}
    """
    let bodyPrompt = """
    You need to generate learning material for sub-topic {subTopicName} of topic {topicName} of course {courseName}. Use easy-to-understand terminology, and keep cause and effect connection.
    here's what student is already learn or to be learining:
    "{includedMaterial}"
    so write only material for the current sub-topic({subTopicName} which are related only to {topicName})
    """
}



