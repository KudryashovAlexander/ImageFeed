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

    
    func showAlert(vc: UIViewController) {
        
    }
    
    func arrayCount() -> Int {
        10
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
        
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
