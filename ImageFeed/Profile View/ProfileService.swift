//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 12.06.2023.
//

import UIKit

final class ProfileService {
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private(set) var profile: Profile?
    
    private enum NetWorkError: Error {
        case codeError
    }
    
    private var currentTask: URLSessionTask?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        var request = URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET"
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        currentTask?.cancel()
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult,Error>) in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let profileResult):
                    let profile = Profile(username: profileResult.userName,
                                          firstName: profileResult.firstName,
                                          lastName: profileResult.lastName,
                                          loginName: profileResult.userName,
                                          bio: profileResult.bio)
                    completion (.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                    
                }
            }
        }
        
        currentTask = task
        currentTask?.resume()
    }
}
