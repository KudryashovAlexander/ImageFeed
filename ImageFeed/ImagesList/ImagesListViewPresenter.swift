//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 15.07.2023.
//

import UIKit

//MARK: - Protocol
protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    func showAlert(vc: UIViewController)
    
}

//MARK: - Class ImagesListViewPresenter
class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol?
    private var alertPresenter = AlertPresener()
    var photos = [Photo]()
    
    func showAlert(vc: UIViewController) {
        alertPresenter.showAlert(viewController: vc) {
            self.view?.tableView.reloadData()
        }
    }
}
