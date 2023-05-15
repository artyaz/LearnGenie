//
//  CollectionCellController.swift
//  Verical collection test
//
//  Created by Артем Чмиленко on 01.05.2023.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet var titleText: UILabel!
    @IBOutlet var completedTests: UILabel!
    @IBOutlet var completedTopics: UILabel!
    @IBOutlet var iconView: UIView!
    @IBOutlet var itemIcon: UIImageView!
    
    var iconName: String? {
        didSet {
            if let icon = iconName {
                let image = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate)
                itemIcon.image = image
                itemIcon.tintColor = .white
            }
        }
    }
    
    func addLoadingIndicator(){
        
    }

    
    override func awakeFromNib() {
            super.awakeFromNib()
        
        self.iconView.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 20
        self.layer.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0).cgColor
        //self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 4
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.masksToBounds = false
        }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                if self.isSelected {
                    self.layer.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5).cgColor
                } else {
                    self.layer.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0).cgColor
                }
            }
        }
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                if self.isHighlighted {
                    self.layer.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5).cgColor
                } else {
                    self.layer.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0).cgColor
                }
            }
        }
    }

    
}

