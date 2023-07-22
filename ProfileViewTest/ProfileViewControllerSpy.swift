//
//  ProfileViewControllerSpy.swift
//  ProfileViewTest
//
//  Created by Александр Кудряшов on 22.07.2023.
//

import UIKit
import ImageFeed

class ProfileViewControllerSpy: ProfileViewViewControllerProtocol {
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    
    var isUpdateAvatar: Bool = false
    var isUpdateProfile: Bool = false
    
    func viewDidLoad() {
        presenter?.viewDidLoad()
    }
    
    func updateAvatar(url: URL) {
        isUpdateAvatar = true
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile?) {
        isUpdateProfile = true
    }
    
    
}
