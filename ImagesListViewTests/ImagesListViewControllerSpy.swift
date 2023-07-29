//
//  ImagesListViewControllerSpy.swift
//  ImagesListViewTests
//
//  Created by Александр Кудряшов on 20.07.2023.
//

import Foundation
import ImageFeed

class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListViewPresenterProtocol?
    
    var isChangeCount: Bool = false
    var isReloadTableView: Bool = false
    
    func viewDidLoad() {
        presenter?.viewDidLoad()
    }
    
    func reloadTableView() {
        isReloadTableView = true
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        if newCount > oldCount {
            isChangeCount = true
        }
    }
    
    
}
