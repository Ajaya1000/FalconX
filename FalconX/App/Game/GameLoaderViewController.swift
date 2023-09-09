//
//  GameLoaderViewController.swift
//  FalconX
//
//  Created by Ajaya Mati on 07/09/23.
//

import UIKit

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
        
        let axialConstraints: [FXLayoutAxisConstraint] = [FXVerticalConstraint.center,
                                                          FXHorizontalConstraint.center]
        let dimensionalConstraints: [FXLayoutDimensionConstraint] = [FXDimensionConstraint.height(constant: Constraints.dimension),
                                                                     FXDimensionConstraint.width(constant: Constraints.dimension)]
        
        axialConstraints.activateConstraints(for: loaderContainerView, with: self.view)
        dimensionalConstraints.activateConstraints(for: loaderContainerView)
        
        loaderView = FXLoaderView(view: loaderContainerView)
        loaderView.play()
    }
}


private struct Constraints {
    static let dimension = CGFloat(64.0)
}
