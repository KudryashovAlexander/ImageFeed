//
//  ImagesListViewPresenterSpy.swift
//  ImagesListViewTests
//
//  Created by Александр Кудряшов on 18.07.2023.
//

import UIKit
import ImageFeed

final class ImagesListViewPresenterSpy: ImageFeed.ImagesListViewPresenterProtocol {
    
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    var isAlertShow: Bool = false

    
    func showAlert(vc: UIViewController) {
        isAlertShow = true
    }
    
    func arrayCount() -> Int {
        10
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
        let oldCount = 10
        let newCount = 20
        if oldCount < newCount {
            view?.updateTableViewAnimated(oldCount: 10, newCount: 20)
        }
    }
    
    func changeLike(photoIndex: Int, vc: UIViewController) -> Bool {
        true
    }
    
    func imageLargeURL(index: Int) -> String? {
        nil
    }
    
    func imageThumbURL(index: Int) -> String? {
        nil
    }
    
    func datePhoto(index: Int) -> String {
        ""
    }
    
    func isLikePhoto(index: Int) -> Bool {
        true
    }
    
    func photoSize(index: Int) -> CGSize {
        CGSize()
    }
    
    
}
