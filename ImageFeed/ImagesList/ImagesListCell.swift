import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gradientImageView: UIImageView!

    var delegate: ImagesListCellDelegate?

    static let reuseIdentifier = "ImagesListCell"
    
    //MARK: - Methods
    func createCornerRadiusGradient() {
        gradientImageView.clipsToBounds = true
        gradientImageView.layer.cornerRadius = 16
        gradientImageView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
//         Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        cellImage.kf.cancelDownloadTask()
    }
    
}
