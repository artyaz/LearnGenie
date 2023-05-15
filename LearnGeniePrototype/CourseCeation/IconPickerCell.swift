//
//  IconPickerCell.swift
//  LearnGeniePrototype
//
//  Created by Артем Чмиленко on 03.05.2023.
//

import UIKit

class IconPickerCell: UICollectionViewCell {
    

    @IBOutlet var imageIcon: UIImageView!
    
    var iconName: String? {
        didSet {
            if let icon = iconName {
                let image = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate)
                imageIcon.image = image
                imageIcon.tintColor = .white
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        isUserInteractionEnabled = true
        
        configureAppearance()
        }
        
        func configureAppearance() {
            // Set the cell's background color to gray
            self.backgroundColor = UIColor.systemGray5
            
            // Set the corner radius of the cell's layer to half the cell's height
            self.layer.cornerRadius = 8
            
            // Clip subviews to the bounds of the cell's layer to ensure that the corner radius is applied correctly
            self.layer.masksToBounds = true
        }
                
}
