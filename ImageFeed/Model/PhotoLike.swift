//
//  PhotoLike.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 02.07.2023.
//

import Foundation
struct ChangeLike: Codable {
    let photo: PhotoLike
}

struct PhotoLike: Codable {
    let id: String
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case isLiked = "liked_by_user"
    }
}
