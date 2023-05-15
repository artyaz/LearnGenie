import UIKit
class IconPicker: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var icons = ["adjustments", "album", "app-window", "atom", "brand-github", "cash", "checkup-list", "device-gamepad", "gender-bigender", "git-branch", "math-function", "movie", "puzzle", "speakerphone", "typography", "Vector", "writing", "yoga", "scale", "mood-smile"]
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
        
        allowsSelection = true
    }
    
    var selectedCell: UICollectionViewCell? {
        didSet {
            selectedCell?.layer.borderWidth = 1
            selectedCell?.layer.borderColor = UIColor.white.cgColor

            // Animate the cell's transform to make it bigger with a bounce effect
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5, options: [], animations: {
                self.selectedCell?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            })
            
            // Generate light impact feedback when cell is selected
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.prepare()
                    generator.impactOccurred()
        }
        willSet {
            // Animate the cell's transform to reset it to its original size
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5, options: [], animations: {
                self.selectedCell?.transform = CGAffineTransform.identity
            })
            selectedCell?.layer.borderWidth = 0
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "IconCell", for: indexPath) as! IconPickerCell
        cell.iconName = icons[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            selectedCell = cell
        }
    }

    
}
