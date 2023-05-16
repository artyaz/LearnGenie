//
//  EnterApiKeyView.swift
//  LearnGeniePrototype
//
//  Created by Артем Чмиленко on 15.05.2023.
//

import UIKit

class EnterApiKeyView: UIViewController {

    @IBOutlet var textFieldApiKey: UITextFieldController!
    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldApiKey.setTextFieldProperties(placeholder: "Enter OpenAI API key", leftPadding: 10, topPadding: 10)
    }
    

    @IBAction func saveApiKey(_ sender: Any) {
        guard let apiKey = textFieldApiKey.text else {
            return
        }
        let apiKeyKeychain = KeychainManager(service: Bundle.main.bundleIdentifier! + ".apiKey.")

        do {
            let apiKeyData = apiKey.data(using: .utf8)!
            try apiKeyKeychain.save(apiKeyData, forKey: "apiKey")
            print("API key saved successfully")
        } catch {
            print("Error saving API key: \(error)")
        }
        
        dismiss(animated: true)
    }

}
