//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 15.07.2023.
//

import UIKit

//MARK: - Protocol
protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func showAlert(vc: UIViewController)
    func arrayCount() -> Int
    func viewDidLoad()
    func fetchPhotosNextPage()
    func changeLike(photoIndex: Int, vc: UIViewController) -> Bool
    func imageLargeURL(index: Int) -> String?
    func imageThumbURL(index: Int) -> String?
    func datePhoto(index: Int) -> String
    func isLikePhoto(index: Int) -> Bool
    func photoSize(index: Int) -> CGSize 
}

//MARK: - Class ImagesListViewPresenter
class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol?
    private var alertPresenter = AlertPresener()
    private let imageListService = ImagesListService()
    private var imageListServiceObserver: NSObjectProtocol?
    private var photos = [Photo]()
    
    func viewDidLoad() {
        imageListService.fetchPhotosNextPage()
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updatePhotos()
            }
    }
    
    func showAlert(vc: UIViewController) {
        alertPresenter.showAlert(viewController: vc) {
            self.view?.reloadTableView()
        }
    }
    
    func arrayCount() -> Int {
        return photos.count
    }
    
    func fetchPhotosNextPage() {
        imageListService.fetchPhotosNextPage()
    }
    
    func updatePhotos() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount:oldCount, newCount:newCount)
        }
    }
    
    func changeLike(photoIndex: Int, vc: UIViewController) -> Bool {
        
        let photo = photos[photoIndex]
        var isChange: Bool = photo.isLiked
        
        imageListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] (result:Result<Bool, Error>) in
            guard let self = self else { return }
            
            switch result {
            case (.success(let isLiked)):
                self.photos = self.imageListService.photos
                isChange = isLiked

            case (.failure(_)):
                print("Ошибка в изменении лайка")
                self.alertPresenter.showAlert(viewController: vc) {
                    self.view?.tableView.reloadData()
                }
            }
        }
        return isChange
    }
    
    func imageLargeURL(index: Int) -> String? {
        if photos.count != 0 {
            return photos[index].largeImageURL
        } else {
            return nil
        }
    }
    
    func imageThumbURL(index: Int) -> String? {
        if photos.count != 0 {
            return photos[index].thumbImageURL
        } else {
            return nil
        }
    }
    
    func datePhoto(index: Int) -> String {
        return photos[index].createdAt?.stringFromDate() ?? ""
    }
    
    func isLikePhoto(index: Int) -> Bool {
        return photos[index].isLiked
    }
    
    func photoSize(index: Int) -> CGSize {
        return photos[index].size
    }
    
    
}
