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
//
//var selfProfileRequest: URLRequest {
//    URLRequest.makeHTTPRequest(path: "/me")
//}
//
//func profileImageURLRequest(username: String) -> URLRequest {
//    URLRequest.makeHTTPRequest(path: "/users/\(username)")
//}
//
//func photosRequest(page: Int, perPage: Int) -> URLRequest {
//    URLRequest.makeHTTPRequest(path: "/photos?"
//                               + "page=\(page)"
//                               + "&&per_page=\(perPage)"
//    )
//}
//func likeRequest(photoId: String) -> URLRequest {
//    URLRequest.makeHTTPRequest(
//        path: "/photos/\(photoId)/like",
//        httpMethod: "POST"
//    )
//}
//func unlikeRequest(photoId: String) -> URLRequest {
//    URLRequest.makeHTTPRequest(
//        path: "/photos/\(photoId)/like",
//        httpMethod: "DELETE"
//    )
//}
//func authTokenRequest(code: String) -> URLRequest {
//    URLRequest.makeHTTPRequest(
//        path: "/oauth/token"
//        + "?client_id=\(AccessKey)"
//        + "&&client_secret=\(SecretKey)"
//        + "&&redirect_uri=\(RedirectURI)"
//        + "&&code=\(code)"
//        + "&&grant_type=authorization_code",
//        httpMethod: "POST",
//        baseURL: URL(string: "https://unsplash.com")!
//    )
//}
