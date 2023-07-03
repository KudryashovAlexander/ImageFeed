//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Александр Кудряшов on 03.07.2023.
//

import UIKit
protocol AlertFactoryProtocol {
    func showAlert(model: AlertModel, viewController: UIViewController, completion: @escaping () -> Void)
}

class AlertPresener: AlertFactoryProtocol {
    
    static var defaultAlert = AlertModel(title: "Что-то пошло не так(",
                                          message: "Не удалось войти в систему",
                                          buttonTitle: "OK")
    
    func showAlert(model: AlertModel = defaultAlert, viewController: UIViewController, completion: @escaping () -> Void) {
        
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonTitle, style: .default) { _ in
            completion()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
