import UIKit
import Kingfisher

//MARK: - Protocol
public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    func viewDidLoad()
    func reloadTableView()
    func updateTableViewAnimated(oldCount:Int, newCount:Int)
}


//MARK: - Class ImagesListViewController
final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: ImagesListViewPresenterProtocol?
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath
            else { return }
            
            if let imageURL = presenter?.imageLargeURL(index: indexPath.row) {
                viewController.imageURL = imageURL
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

//MARK: - Extension UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.arrayCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        
        if let imageURL = presenter?.imageThumbURL(index: indexPath.row),
           let url = URL(string: imageURL),
           let cellImageView = imageListCell.cellImage
        {
            cellImageView.kf.indicatorType = .activity
            cellImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "ImagePlaceholder.jpg")) { _ in
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
        }
        
        imageListCell.createCornerRadiusGradient()
        imageListCell.dateLabel.text = presenter?.datePhoto(index: indexPath.row)
        if let isLikePhoto = presenter?.isLikePhoto(index: indexPath.row) {
            imageListCell.likeButton.setImage(imageListCell.setIsLiked(isLiked: isLikePhoto), for: .normal)
        }
        return imageListCell
    }
}

//MARK: - Extension UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let photoSize = presenter?.photoSize(index: indexPath.row) else { return 30.0 }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photoSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photoSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

//MARK: - Extension sprint 12

extension ImagesListViewController {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter?.arrayCount() {
            presenter?.fetchPhotosNextPage()
        }
    }
    
    func updateTableViewAnimated(oldCount:Int, newCount:Int){

            self.tableView.performBatchUpdates {
                var indexPaths: [IndexPath] = []
                for i in oldCount..<newCount {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        UIBlockingProgressHUD.show()
        
        if let isLiked = presenter?.changeLike(photoIndex: indexPath.row, vc: self) {
            cell.likeButton.setImage(cell.setIsLiked(isLiked: !isLiked), for: .normal)
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
}
 


