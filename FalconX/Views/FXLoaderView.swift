//
//  FXLoaderView.swift
//  FalconX
//
//  Created by Ajaya Mati on 07/09/23.
//


import UIKit
import Lottie

protocol FXLoaderViewActionable: AnyObject {
    func didFinishAnimation()
}

enum FXLoaderAnimationType {
    case loader
    
    var animation: LottieAnimation? {
        switch self {
        case .loader:
            return LottieAnimation.named("loader")
        }
    }
}

class FXLoaderView {
    // MARK: - Public Varibales
    var removeOnCompletion = false
    weak var delegate: FXLoaderViewActionable?
    
    // MARK: - Private Variables
    private var animationType: FXLoaderAnimationType
    private var superView: UIView
    private var animationView: LottieAnimationView?
    
    // MARK: - Life Cycle Method
    init(view: UIView, animationType: FXLoaderAnimationType = .loader) {
        self.animationType = animationType
        self.superView = view
        
        setup()
    }
    
    // MARK: - Public Methods
    func play() {
        DispatchQueue.main.async {
            self.animationView?.play() { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.didFinishAnimation()
            }
        }
    }
    
    func removeAnimationFromSuperView() {
        DispatchQueue.main.async {
            self.animationView?.removeFromSuperview()
            self.animationView = nil
        }
    }
    
    // MARK: - Private Methods
    private func setup() {
        DispatchQueue.main.async {
            let animation = self.animationType.animation
            let animationView = LottieAnimationView(animation: animation)
            
            animationView.frame = self.superView.bounds
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .autoReverse
            self.animationView = animationView
            
            self.superView.addSubview(animationView)
        }
    }
    
    private func didFinishAnimation() {
        delegate?.didFinishAnimation()
        
        if removeOnCompletion {
            removeAnimationFromSuperView()
        }
    }
}

