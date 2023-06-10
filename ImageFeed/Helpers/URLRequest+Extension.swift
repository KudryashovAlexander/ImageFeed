//
//  URLRequest+Extension.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 03.06.2023.
//

import Foundation
fileprivate let DefaultsBaseURL = URL(string: "https://api.unsplash.com")!

extension URLRequest {
    static func makeHTTPRequest(
        path:String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
    static func makeHTTPRequest(
        path:String,
        baseURL: URL = DefaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        return request
    }
}
