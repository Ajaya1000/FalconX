//
//  FXUtil.swift
//  FalconX
//
//  Created by Ajaya Mati on 07/09/23.
//

import Foundation
import UIKit

struct FXUtil {
    static func showErrorMessage(with title: String?, message: String? = nil, alerts: [AlertActionItem]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alerts.forEach { item in
            switch item {
            case .action(title: let title, handler: let handler):
                alertController.addAction(.init(title: title, style: .default, handler: handler))
            case .cancelAction(title: let title, handler: let handler):
                alertController.addAction(.init(title: title, style: .cancel, handler: handler))
            }
        }
        
        alertController.show()
    }
}
