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
        
        let axialConstraints: [XLayoutAxisConstraint] = [.centerX, .centerY]
        let dimensionalConstraints: [XLayoutDimensionConstraint] = [.height.constant(to: Constraints.dimension),
                                                                    .width.constant(to: Constraints.dimension)]
        
        axialConstraints.activateConstraints(for: loaderContainerView, with: self.view)
        dimensionalConstraints.activateConstraints(for: loaderContainerView)
        
        loaderView = FXLoaderView(view: loaderContainerView)
        loaderView.play()
    }
}


private struct Constraints {
    static let dimension = CGFloat(64.0)
}
