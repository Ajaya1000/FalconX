//
//  FXButton.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import UIKit
import QuartzCore

class FXButton: UIButton {
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setHighlightedState()
        
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setDefaultState()
        
        super.touchesEnded(touches, with: event)
    }
}

// MARK: - Private Methods
private extension FXButton {
    func setup() {
        self.configuration = .borderless()
        self.backgroundColor = .black
        
        self.setTitleColor(ColorPreferences.primary, for: .normal)
        self.setTitleColor(ColorPreferences.primary, for: .highlighted)
        self.setTitleColor(ColorPreferences.gray, for: .disabled)
        
        
        self.layer.shadowColor = ColorPreferences.primary.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 0.5
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = ColorPreferences.primary.withAlphaComponent(0.5).cgColor
        
        setDefaultState()
    }
    
    func setDefaultState() {
        self.configuration?.contentInsets = .init(top: Constraints.defaultMargin,
                                                  leading: Constraints.defaultMargin,
                                                  bottom: Constraints.defaultMargin,
                                                  trailing: Constraints.defaultMargin)
        self.layer.shadowOffset = CGSize(width: Constraints.defaultShadowOffset,
                                         height: Constraints.defaultShadowOffset)
    }
    
    func setHighlightedState() {
        self.configuration?.contentInsets = .init(top: Constraints.defaultMargin + Constraints.difference,
                                                  leading: Constraints.defaultMargin + Constraints.difference,
                                                  bottom: Constraints.defaultMargin - Constraints.difference,
                                                  trailing: Constraints.defaultMargin - Constraints.difference)
        
        self.layer.shadowOffset = CGSize(width: Constraints.defaultShadowOffset - Constraints.difference,
                                         height: Constraints.defaultShadowOffset - Constraints.difference)
        
    }
}


private struct Constraints {
    static let defaultMargin = CGFloat(12.0)
    static let defaultShadowOffset = CGFloat(6.0)
    static let difference = CGFloat(2.0)
}
