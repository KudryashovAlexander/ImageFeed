//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 03.06.2023.
//
import UIKit

struct OAuthTokenResponseBody: Decodable {
    var accessToken: String
    var tokenType: String
    var scope: String
    var createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
