//
//  FXDimensionConstraint.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import UIKit

/// Size of the UIView
enum FXDimensionConstraint: FXLayoutDimensionConstraint {
    /// width of the UIView
    case width(constant: CGFloat = 0.0)
    /// height of the UIView
    case height(constant: CGFloat = 0.0)
    
    func nsLayoutConstraint(for childView: UIView) -> NSLayoutConstraint {
        // to store the final constraint
        let constraint: NSLayoutConstraint
        
        // initialize constraint
        switch self {
        case .width(let constant):
            // Initializing width anchor
            // and assigning it to constraint
            constraint = childView.widthAnchor.constraint(equalToConstant: constant)
        case .height(let constant):
            // Initializing height anchor
            // and assigning it to constraint
            constraint = childView.heightAnchor.constraint(equalToConstant: constant)
        }
        
        // return the constraint
        return constraint
    }
}
