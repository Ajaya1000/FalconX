//
//  GameLoaderViewController.swift
//  FalconX
//
//  Created by Ajaya Mati on 07/09/23.
//

import UIKit
import XConstraintKit

class GameLoaderViewController: BaseViewController {
    private var loaderContainerView: UIView!
    private var loaderView: FXLoaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

private extension GameLoaderViewController {
    func setup() {
        loaderContainerView = UIView(frame: .zero)
        loaderContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loaderContainerView)
        
        loaderContainerView.activate(with: self.view) { xc in
            xc.centerX
            xc.centerY
            xc.height.constant(to: Constraints.dimension)
            xc.width.constant(to: Constraints.dimension)
        }
        
        loaderView = FXLoaderView(view: loaderContainerView)
        loaderView.play()
    }
}


private struct Constraints {
    static let dimension = CGFloat(64.0)
}
