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
                                         buttonTitle: "OK",
                                         buttonTitle2: nil)
    
    
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
    
    func showAlertTwoButton(model: AlertModel, viewController: UIViewController, actionOne: @escaping () -> Void, actionTwo: @escaping () -> Void) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Bye bye!"
        let action1 = UIAlertAction(title: model.buttonTitle, style: .default) { _ in
            actionOne()
        }
        alert.addAction(action1)
        action1.accessibilityIdentifier = "Yes"
        
        if let tittle2 = model.buttonTitle2 {
            let action2  = UIAlertAction(title: tittle2, style: .default) { _ in
                actionTwo()
            }
            action2.accessibilityIdentifier = "No"
            alert.addAction(action2)
        }
        viewController.present(alert, animated: true, completion: nil)

    }
}
