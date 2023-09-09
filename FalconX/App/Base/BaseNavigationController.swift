//
//  BaseNavigationController.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = ColorPreferences.primary
        self.navigationBar.barTintColor = ColorPreferences.secondary
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorPreferences.primary]
    }
}
