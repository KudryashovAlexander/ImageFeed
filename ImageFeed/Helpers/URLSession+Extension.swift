//
//  URLSession+Extension.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 03.06.2023.
//

import Foundation
enum NetWorkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(for request: URLRequest, completion: @escaping (Result <Data, Error>) -> Void) -> URLSessionDataTask {
        let fulfilCompletion: (Result <Data,Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200..<300 ~= statusCode {
                    fulfilCompletion(.success(data))
                } else {
                    fulfilCompletion(.failure(NetWorkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfilCompletion(.failure(NetWorkError.urlRequestError(error)))
            } else {
                fulfilCompletion(.failure(NetWorkError.urlSessionError))
            }
        }
        task.resume()
        return task
}
}

extension URLSession {
    func objectTask<T:Decodable>(
        for request: URLRequest,
            completion: @escaping (Result <T,Error>) -> Void
        ) -> URLSessionTask {
            let task = dataTask(with: request, completionHandler: {data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    if let response = response as? HTTPURLResponse,
                       response.statusCode < 200 || response.statusCode >= 300 {
                        completion(.failure(NetWorkError.httpStatusCode(response.statusCode)))
                        return
                    }
                    
                    guard let data = data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(error))
                    }
                }
            })
            return task
        }
    }

