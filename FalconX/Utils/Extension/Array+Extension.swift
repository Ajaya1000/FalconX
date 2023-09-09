//
//  Array+Extension.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import UIKit

extension Array where Element == FXLayoutDimensionConstraint {
    /// Activates Dimensional Constraints
    /// - Parameter childView: child view for which constraints are to be added
    func activateConstraints(for childView: UIView) {
        getConstraints(for: childView).activate()
    }
    
    func getConstraints(for childView: UIView) -> [NSLayoutConstraint] {
        return map { constraints in
            constraints.nsLayoutConstraint(for: childView)
        }
    }
}

extension Array where Element == FXLayoutAxisConstraint {
    /// Activates Axis Constraints
    /// - Parameter childView: child view for which constraints are to be added
    /// - Parameter superView: super view with respect to which constraints are to be added
    func activateConstraints(for childView: UIView, with superView: UIView) {
        getConstraints(for: childView, with: superView).activate()
    }
    
    func getConstraints(for childView: UIView, with superView: UIView) -> [NSLayoutConstraint] {
        return map { constraints in
            constraints.nsLayoutConstraint(for: childView, with: superView)
        }
    }
    
    func activateConstraints(for childView: UIView, with layoutGuide: UILayoutGuide) {
        getConstraints(for: childView, with: layoutGuide).activate()
    }
    
    func getConstraints(for childView: UIView, with layoutGuide: UILayoutGuide) -> [NSLayoutConstraint] {
        return map { constraints in
            constraints.nsLayoutConstraint(for: childView, with: layoutGuide)
        }
    }
}

extension Array where Element == NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(self)
    }
    
    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
}

extension Array where Element: Equatable {
    mutating func remove(_ element: Element) {
        if let index = self.firstIndex(of: element) {
            self.remove(at: index)
        }
    }
}
