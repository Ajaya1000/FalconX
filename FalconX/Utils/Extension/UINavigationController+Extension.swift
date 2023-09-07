//
//  UINavigationController+Extension.swift
//  FalconX
//
//  Created by Ajaya Mati on 07/09/23.
//

import UIKit

extension UINavigationController {
    private func prepareFade() {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
    }
    
    func replaceTop(with controller: UIViewController, animated: Bool = true, fade: Bool = true) {
        guard let current = self.topViewController else {
            return
        }
        
        var controllers = self.viewControllers
        controllers.remove(current)
        controllers.append(controller)
        
        if fade {
            prepareFade()
            self.setViewControllers(controllers, animated: false)
        }
        else {
            self.setViewControllers(controllers, animated: animated)
        }
    }

}
