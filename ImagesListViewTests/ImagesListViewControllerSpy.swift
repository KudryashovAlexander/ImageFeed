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
    
    func viewDidLoad() {
        presenter?.viewDidLoad()
    }
    
    func reloadTableView() {
        
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        
    }
    
    
}
