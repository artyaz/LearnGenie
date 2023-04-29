//
//  TopicBodyViewController.swift
//  LearnGeniePrototype
//
//  Created by Артем Чмиленко on 25.04.2023.
//

import UIKit

class TopicBodyViewController: UIViewController {

    
    @IBOutlet var bodyText: UITextView!
    
    var body: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let body = body {
                    bodyText.text = body
                }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        bodyText.isEditable = false

    }

}
