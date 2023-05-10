import UIKit
final class ImagesListCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var gradientImageView: UIImageView!
    
    static let reuseIdentifier = "ImagesListCell"
    
    func gradient() {
        let color1 = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0).cgColor
        let color2 = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.2).cgColor
        let gradientLayer = CAGradientLayer()
        gradientImageView.clipsToBounds = true
        gradientImageView.layer.cornerRadius = 16
        gradientImageView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        gradientLayer.frame = gradientImageView.bounds
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientImageView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
}
