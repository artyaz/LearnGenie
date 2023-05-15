//
//  UITextFieldController.swift
//  LearnGeniePrototype
//
//  Created by Артем Чмиленко on 15.05.2023.
//

import UIKit

class UITextFieldController: UITextField {

    func setTextFieldProperties(placeholder: String, leftPadding: CGFloat, topPadding: CGFloat) {
        
        self.layer.cornerRadius = 10
        self.borderStyle = .none
        self.layer.borderWidth = 0.4
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0).cgColor
        
        let placeholderText = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        self.attributedPlaceholder = placeholderText
        
        // Set text alignment to left and content vertical alignment to top
        self.textAlignment = .left
        self.contentVerticalAlignment = .fill
        
        // Create a padding view for the left side of the text field
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: self.frame.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
    }
    

}
