//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 12.06.2023.
//

import UIKit

final class ProfileService {
    
    private enum NetWorkError: Error {
        case codeError
    }
    
    private var currentTask: URLSessionTask?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        let url = DefaultProfileURL
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        currentTask?.cancel()
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(NetWorkError.codeError))
                return
            }
            
            guard let data = data else { return }
            do {
                let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                let profile = Profile(username: profileResult.userName,
                                      firstName: profileResult.firstName,
                                      lastName: profileResult.lastName,
                                      loginName: profileResult.userName,
                                      bio: profileResult.bio)
                completion(.success(profile))
            } catch {
                completion(.failure(error))
            }
        }
        currentTask = task
        currentTask?.resume()
    }
    
}
