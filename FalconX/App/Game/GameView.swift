//
//  GameViewController.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import UIKit

class GameView: UIView {
    // MARK: - Dependencies
    private var viewModel: GameViewModel
    
    // MARK: - Properties
    private var containerView = UIStackView()
    private var planetInfoLabel = UILabel()
    private var vehicleInfoLabel = UILabel()
    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented use init(viewModel: GameViewModel)")
    }
}

// MARK: - UI Methods
private extension GameView {
    func setup() {
        setupContainerView()
        
        setup(planetInfoLabel, text: "\(DisplayString.selectPlanet) \(viewModel.selectedIndex + 1)")
        
        setup(vehicleInfoLabel, text: "\(DisplayString.selectVehicle) \(viewModel.selectedIndex + 1)")
        
        // Add arragned subviews to the stack
        containerView.addArrangedSubview(planetInfoLabel)
        containerView.addArrangedSubview(vehicleInfoLabel)
        
        // Add Container Stack View
        self.addSubview(containerView)
        
        let constraints: [FXLayoutAxisConstraint] = [FXHorizontalConstraint.right(constant: Constraints.outerMargin),
                                                     FXHorizontalConstraint.left(constant: Constraints.outerMargin),
                                                     FXVerticalConstraint.top(),
                                                     FXVerticalConstraint.bottom()]
        
        // Activate required constraints
        constraints.activateConstraints(for: containerView, with: self)
    }
    
    func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.axis = .vertical
    }
    
    func setup( _ label: UILabel, text: String) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorPreferences.primary
        label.text = text
    }
}

private struct Constraints {
    static let outerMargin = CGFloat(16.0)
}
