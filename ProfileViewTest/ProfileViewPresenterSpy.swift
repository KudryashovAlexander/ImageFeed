//
//  ProfileViewPresenterSpy.swift
//  ProfileViewTest
//
//  Created by Александр Кудряшов on 18.07.2023.
//

import UIKit
import ImageFeed

final class ProfileViewPresenterSpy: ImageFeed.ProfileViewPresenterProtocol {
    var view: ImageFeed.ProfileViewViewControllerProtocol?
    
    var viewDidLoadCalled: Bool = false
    
    var isAlertShow: Bool = false

    func showAlert(viewController: UIViewController) {
        isAlertShow = true
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    
}
