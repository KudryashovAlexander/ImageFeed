import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gradientImageView: UIImageView!

    weak var delegate: ImagesListCellDelegate?

    static let reuseIdentifier = "ImagesListCell"
    
    //MARK: - Methods
    func createCornerRadiusGradient() {
        gradientImageView.clipsToBounds = true
        gradientImageView.layer.cornerRadius = 16
        gradientImageView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
    }
    
    func setIsLiked(isLiked: Bool) -> UIImage {
        let imageName = isLiked ? "LikeActive" : "LikeNoActive"
        return UIImage(named: imageName) ?? UIImage()
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
}
