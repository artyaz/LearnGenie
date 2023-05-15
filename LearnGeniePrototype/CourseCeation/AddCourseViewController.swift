//
//  AddCourseViewController.swift
//  LearnGeniePrototype
//
//  Created by Артем Чмиленко on 02.05.2023.
//

import UIKit

protocol AddCourseDelegate: AnyObject {
    func requestCourse(name: String, description: String, iconName: String, expirience: String)
    }

class AddCourseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    weak var delegate: AddCourseDelegate?
    
    let engine = Engine()
    
    let prompts = Prompts()

    @IBOutlet var iconPicker: IconPicker!
    @IBOutlet var addCourseButton: UIButton!
    @IBOutlet var levelPicker: UIPickerView!
    @IBOutlet var textFieldCourseName: UITextFieldController!
    @IBOutlet var textFieldCourseDescription: UITextFieldController!
    
    let levelNames = ["Absolute zero", "Beginner", "Novice", "Elementary", "Basic", "Fundamental", "Introductory", "Foundational", "Novice Plus", "Intermediate", "Experienced", "Advanced", "Expert", "Mastery", "Elite"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconPicker.delegate = iconPicker
        
        textFieldCourseName.delegate = self
        textFieldCourseDescription.delegate = self
        
        levelPicker.delegate = self
        levelPicker.dataSource = self
        
        textFieldCourseName.setTextFieldProperties(placeholder: "Hello", leftPadding: 10, topPadding: 10)
        textFieldCourseDescription.setTextFieldProperties(placeholder: "Course description", leftPadding: 10, topPadding: 10)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textFieldCourseName.resignFirstResponder()
            textFieldCourseDescription.resignFirstResponder()
            return true
        }
    
    @IBAction func addCourse(_ sender: Any) {
        
        guard let inputCourseName = textFieldCourseName.text, !inputCourseName.isEmpty else { return }
        guard let inputCourseDescription = textFieldCourseDescription.text, !inputCourseDescription.isEmpty else { return }
        let prompt = prompts.topicsPrompt.replacingOccurrences(of: "{courseName}", with: inputCourseName)
        
        var inputSelectedIcon: String?
        if let cell = iconPicker.selectedCell as? IconPickerCell {
            if let cellIconName = cell.iconName {
                inputSelectedIcon = cellIconName
            }
        }
        
        let inputExpirience = levelNames[levelPicker.selectedRow(inComponent: 0)]

        delegate?.requestCourse(name: inputCourseName, description: inputCourseDescription, iconName: inputSelectedIcon ?? "atom", expirience: inputExpirience)
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Since we only have one array of data for the picker view
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levelNames.count // The number of rows in the picker view should match the number of items in the array
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return levelNames[row] // Returns the string for each row based on the corresponding item in the levelNames array
    }

}
