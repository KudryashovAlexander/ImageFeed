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
