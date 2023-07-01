//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 29.06.2023.
//

import Foundation
/*
lastLoadedPage - хранить номер последней скачанной страницы
fetchPhotosNextPage() - функция для получения очередной страницы
Скачивать больше одной страницы за раз не будем; если идёт закачка — будем отправлять новый запрос только после её завершения.


 - Можно ли обновлять массив photos из фонового потока или это должен быть main?
 Обязательно из main.
 Читать и изменять значение массива нужно всегда из одной и той же последовательной очереди, из одного и того же потока. Так как читать массив photos мы будем из main — в методе, реализующем UITableViewDataSource, то и обновление массива должно быть в потоке main.
 
 */

final class ImagesListService {
    
    static let shared = ImagesListService()
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
            path: "/photos",
            httpMethod: "GET"
        )
        print (nextPage)
        guard let token = OAuth2TokenStorage().token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("\(nextPage)", forHTTPHeaderField: "page")
        request.setValue("10", forHTTPHeaderField: "per_page")
        request.setValue("latest", forHTTPHeaderField: "order_by")
        
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
