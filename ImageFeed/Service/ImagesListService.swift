//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 29.06.2023.
//

import Foundation

final class ImagesListService {
    
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    private (set) var photos: [Photo] = []
    private var task: URLSessionTask? = nil
    private var lastLoadedPage: Int?
        
    func fetchPhotosNextPage() {
        if task != nil {
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
        
        //добавить нотификацию
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
                print(error)
            }
        }
        self.task = task
        self.task?.resume()
        self.task = nil //Насколько это правильная запись?
        
    }
}
