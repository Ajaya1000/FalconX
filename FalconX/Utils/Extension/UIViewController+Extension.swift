//
//  UIViewController+Extension.swift
//  FalconX
//
//  Created by Ajaya Mati on 07/09/23.
//

import Foundation
import UIKit

enum AlertActionItem {
    case action(title: String, handler: ((UIAlertAction?) -> Void)? = nil)
    case cancelAction(title: String, handler: ((UIAlertAction?) -> Void)? = nil)
    case destructiveAction(title: String, handler: ((UIAlertAction?) -> Void)? = nil)
}

extension UIViewController {
    func presentOnTop(_ viewController: UIViewController, animated: Bool) {
        var topViewController = self
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        
        topViewController.present(viewController, animated: animated)
    }
    
    func showAlertController(with title: String?, message: String? = nil, alerts: [AlertActionItem]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alerts.forEach { item in
            switch item {
            case .action(title: let title, handler: let handler):
                alertController.addAction(.init(title: title, style: .default, handler: handler))
            case .cancelAction(title: let title, handler: let handler):
                alertController.addAction(.init(title: title, style: .cancel, handler: handler))
            case .destructiveAction(title: let title, handler: let handler):
                alertController.addAction(.init(title: title, style: .destructive, handler: handler))
            }
        }
        
        self.presentOnTop(alertController, animated: true)
    }
}
