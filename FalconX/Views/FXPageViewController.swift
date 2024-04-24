//
//  FXPageViewController.swift
//  FalconX
//
//  Created by Ajaya Mati on 07/09/23.
//

import UIKit
import XConstraintKit

protocol FXPageViewControllerDataSource: AnyObject {
    func view(forItemAtIndex index: Int) -> UIView?
}

class FXPageViewController: UIViewController {
    // MARK: - Public Properties
    weak var dataSource: FXPageViewControllerDataSource?
    
    // MARK: - Private Properties
    private var currentIndex = 0
    private var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentView()
    }
}

// MARK: - Private Methods
private extension FXPageViewController {
    func setupContentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(contentView)
        
        let constraints: [XLayoutAxisConstraint] = []
        
        contentView.activate(with: self.view) { xc in
            xc.leading
            xc.trailing
            xc.top
            xc.bottom
        }
        
        
        guard let initialView = dataSource?.view(forItemAtIndex: currentIndex) else { return }
        
        initialView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(initialView)
        
        constraints.activateConstraints(for: initialView, with: contentView)
    }
}

// MARK: - Public Methods
extension FXPageViewController {
    func setCurrentIndex(_ newIndex: Int, animated: Bool = true) {
        guard let newView = dataSource?.view(forItemAtIndex: newIndex) else { return }
        
        newView.translatesAutoresizingMaskIntoConstraints = false

        let direction: NavigationDirection = newIndex > currentIndex ? .forward : .reverse
        
        @XLayoutConstraintBuilder
        func contraintMaker(xc: XLayoutConstraintMaker) -> [XLayoutConstraint] {
            xc.leading
            xc.trailing
            xc.top
            xc.bottom
        }
        
        if animated {
            UIView.transition(with: contentView, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                newView.translatesAutoresizingMaskIntoConstraints = false
                self.contentView.subviews.forEach { $0.removeFromSuperview() }
                self.contentView.addSubview(newView)
                
                newView.activate(with: self.contentView, constraints: contraintMaker)
            }, completion: nil)
        } else {
            newView.translatesAutoresizingMaskIntoConstraints = false
            contentView.subviews.forEach { $0.removeFromSuperview() }
            contentView.addSubview(newView)
            newView.activate(with: self.contentView, constraints: contraintMaker)
        }
        
        currentIndex = newIndex
    }
}

extension FXPageViewController {
    enum NavigationDirection {
        case forward
        case reverse
    }
}
