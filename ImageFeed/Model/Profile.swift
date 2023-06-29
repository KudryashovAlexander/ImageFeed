//
//  Profile.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 12.06.2023.
//

import Foundation
struct Profile {
    var username: String
    var name: String
    var loginName: String
    var bio: String?
    
    init(username: String, firstName: String, lastName: String?,loginName: String, bio: String?) {
        self.username = username
        self.name = firstName
        if let lastName = lastName {
            self.name += " " + lastName
        }
        self.loginName = "@" + loginName
        self.bio = bio
    }
}
