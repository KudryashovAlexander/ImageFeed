//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 21.06.2023.
//

import UIKit

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    let urlSession = URLSession.shared
    private (set) var avatarURL: String?
    
    private var avatarImage = UIImageView()
    private var currentTask: URLSessionTask?
    private var oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private enum NetWorkError: Error {
        case codeError
    }

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {

        var request = URLRequest.makeHTTPRequest(
            path: "/users/" + username,
            httpMethod: "GET")
        guard let token = oAuth2TokenStorage.token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        currentTask?.cancel()
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult,Error>) in
            guard let self else { return }

                switch result {
                    
                case .success(let userResult):
                    let userImage = userResult.profileImage.medium
//                    print(userImage)
                    self.avatarURL = userImage
                    completion(.success(userImage))
                    
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.DidChangeNotification,
                            object: self,
                            userInfo: ["URL": userImage])
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            
        }
        currentTask = task
        currentTask?.resume()
    }
}
