//
//  FXLayoutConstraint.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import UIKit

/// Horizontal and Vertical Constraint
protocol FXLayoutAxisConstraint {
    /// Creates ``NSLayoutConstraint`` for the constraint using
    ///   ``constraint`` method
    /// - Parameters:
    ///   - childView: view for which the constraint is to be added
    ///   - superView: view with respect to which the constraint is to be added
    /// - Returns: return the ``NSLayoutConstraint`` for the constraint
    func nsLayoutConstraint(for childView: UIView, with superView: UIView) -> NSLayoutConstraint
    
    func nsLayoutConstraint(for childView: UIView, with layoutGuide: UILayoutGuide) -> NSLayoutConstraint
}

/// Width and Height Constraint
protocol FXLayoutDimensionConstraint {
    /// Creates ``NSLayoutConstraint`` for the constraint using
    ///   ``constraint`` method
    /// - Returns: return the  ``NSLayoutConstraint`` for the constraint
    func nsLayoutConstraint(for childView: UIView) -> NSLayoutConstraint
}
