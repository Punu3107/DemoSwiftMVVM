import UIKit
import Combine

class DogsImageTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
