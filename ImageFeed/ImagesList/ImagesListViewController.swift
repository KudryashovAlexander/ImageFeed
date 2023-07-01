import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let imageListService = ImagesListService()
    private var photos = [Photo]()
    private var imageListServiceObserver: NSObjectProtocol?

    
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
    
    private func createBottonImage(with indexPath: IndexPath) -> UIImage {
        let imageName = indexPath.row % 2 == 0 ?  "LikeActive" : "LikeNoActive"
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
                
        if let url = URL(string: photos[indexPath.row].thumbImageURL),
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
        imageListCell.dateLabel.text = photos[indexPath.row].createdAt?.stringFromDate() ?? ""
        imageListCell.likeButton.setImage(createBottonImage(with: indexPath), for: .normal)
        
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
        
        // ...
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
 


