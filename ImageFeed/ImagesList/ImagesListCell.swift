import UIKit

final class ImagesListCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gradientImageView: UIImageView!
    
    static let reuseIdentifier = "ImagesListCell"
    
    //MARK: - Methods
    func createCornerRadiusGradient() {
        gradientImageView.clipsToBounds = true
        gradientImageView.layer.cornerRadius = 16
        gradientImageView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
    }
    
}
