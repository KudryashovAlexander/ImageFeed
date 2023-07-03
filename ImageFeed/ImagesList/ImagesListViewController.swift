import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let imageListService = ImagesListService()
    private var photos = [Photo]()
    private var imageListServiceObserver: NSObjectProtocol?
    private var alertPresenter = AlertPresener()

    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imageListService.fetchPhotosNextPage()
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }
    
    
    private func createBottonImage(isLiked: Bool) -> UIImage {
        let imageName = isLiked ? "LikeActive" : "LikeNoActive"
        return UIImage(named: imageName) ?? UIImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath
            else { return }
            
//TODO: - Метод неправильный - Нужно как то вытащить картинку из cell
            let image = UIImage(named: photos[indexPath.row].thumbImageURL)
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

//MARK: - Extension ImagesListViewController UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        
        let photo = photos[indexPath.row]
        if let url = URL(string: photo.thumbImageURL),
        let cellImageView = imageListCell.cellImage {
            
            cellImageView.kf.indicatorType = .activity
            let processor = RoundCornerImageProcessor(cornerRadius: 16)
            cellImageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "ImagePlaceholder.jpg"),
                    options: [.processor(processor)]) { _ in
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
        }
        
        imageListCell.createCornerRadiusGradient()
        imageListCell.dateLabel.text = photo.createdAt?.stringFromDate() ?? ""
        imageListCell.likeButton.setImage(createBottonImage(isLiked: photo.isLiked), for: .normal)
        
        return imageListCell
    }
    
}

//MARK: - Extension ImagesListViewController UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    
    //Переход через нажатие на картинку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    //высота ячейки таблицы
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let image = UIImage(named: photos[indexPath.row].largeImageURL) else {
//            return 0
//        }
//        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
//        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
//        let imageWidth = image.size.width
//        let scale = imageViewWidth / imageWidth
//        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
//        return cellHeight
//    }
    
}
//MARK: - Extension sprint 12

extension ImagesListViewController {
    //вызывается прямо перед тем, как ячейка таблицы будет показана на экране.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imageListService.fetchPhotosNextPage()

        }
    }
    
    func updateTableViewAnimated(){
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            self.tableView.performBatchUpdates {
                var indexPaths: [IndexPath] = []
                for i in oldCount..<newCount {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
        
    }
}

protocol ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
               let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] (result:Result<Bool, Error>) in
            guard let self = self else { return }
            switch result {
            case (.success(let isLike)):
                self.photos = self.imageListService.photos
                cell.likeButton.setImage(self.createBottonImage(isLiked: isLike), for: .normal)
                UIBlockingProgressHUD.dismiss()
            case (.failure(_)):
                print("Ошибка в изменении лайка")
                UIBlockingProgressHUD.dismiss()
                self.alertPresenter.showAlert(viewController: self) {
                    self.tableView.reloadData()
                }
            }
        }

        //...
    }
    
}
 


