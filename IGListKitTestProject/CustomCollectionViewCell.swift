import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var label: UILabel!
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
}
