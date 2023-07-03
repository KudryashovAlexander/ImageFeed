//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 29.06.2023.
//

import UIKit

final class ImagesListService {
    
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    private (set) var photos: [Photo] = []
    private var taskPhotoNext: URLSessionTask? = nil
    private var taskChangeLike: URLSessionTask? = nil
    private var lastLoadedPage: Int?
        
    func fetchPhotosNextPage() {
        if taskPhotoNext != nil {
            return
        }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        var request = URLRequest.makeHTTPRequest(
            path: "/photos?page=\(nextPage)",
            httpMethod: "GET"
        )
        print (nextPage)
        guard let token = OAuth2TokenStorage().token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult],Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let photoResultArray):
                for photoResult in photoResultArray {
                    let photo = Photo(id: photoResult.id,
                                      size: CGSize(width: photoResult.width, height: photoResult.height),
                                      createdAtString: photoResult.createdAt,
                                      welcomeDescription: photoResult.welcomeDescription,
                                      thumbImageURL: photoResult.urls.thumbImageURL,
                                      largeImageURL: photoResult.urls.largeImageURL,
                                      isLiked: photoResult.isLiked)
                    print(photo.id)
                    self.photos.append(photo)
                }
                NotificationCenter.default
                    .post(
                        name: ImagesListService.DidChangeNotification,
                        object: self)
                self.lastLoadedPage = nextPage
                
            case .failure(let error):
                print("Ошибка в загрузке картинок: \(error)")
                
            }
        }
        self.taskPhotoNext = task
        self.taskPhotoNext?.resume()
        self.taskPhotoNext = nil //Насколько это правильная запись?
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        
        if taskChangeLike != nil { return }
        
        let httpMethod = isLike ? "DELETE" : "POST"
        var request = URLRequest.makeHTTPRequest(
                path: "/photos/\(photoId)/like",
                httpMethod: httpMethod
        )
        
        guard let token = OAuth2TokenStorage().token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(
            for: request) { [weak self] (result: Result<ChangeLike,Error>) in
                guard let self = self else { return }
                
                switch result {
                case .success(let photoResult):
                    var index = 0
                    for photo in self.photos {
                        if photo.id == photoResult.photo.id {
                            self.photos[index].isLiked = photoResult.photo.isLiked
                            completion (.success(photoResult.photo.isLiked))
                            break
                        }
                        index += 1
                    }
                
                case .failure(let error):
                    
                    print("Ошибка в изменении лайка картинки: \(error)")
                    completion(.failure(error))
                }
            }
        self.taskChangeLike = task
        self.taskChangeLike?.resume()
        self.taskChangeLike = nil //Насколько это правильная запись?
    }
}
