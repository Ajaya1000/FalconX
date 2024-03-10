//
//  ViewController.swift
//  FalconX
//
//  Created by Ajaya Mati on 05/09/23.
//

import UIKit
import XConstraintKit

protocol HomeDelegate: AnyObject {
    func startGame()
}

class HomeViewController: BaseViewController {
    
    // MARK: - Dependencies
    weak var delegate: HomeDelegate?
    
    // MARK: - Properties
    private var containerStack = UIStackView()
    private var titleLabel = UILabel()
    private var continueButton = FXButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup()
    }
}

// MARK: - UI Methods
private extension HomeViewController {
    func setup() {
        addContainerStackView()
        addTitleLabel()
        addContinueButton()
    }
    
    func addContainerStackView() {
        containerStack.axis = .vertical
        containerStack.distribution = .fill
        containerStack.alignment = .center
        containerStack.spacing = Constraints.spacing
        
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(containerStack)
        
        let constraints: [XLayoutAxisConstraint] = [.left.constant(to: Constraints.margin),
                                                    .right.constant(to: -Constraints.margin),
                                                    .centerY]
        constraints.activateConstraints(for: containerStack, with: self.view)
    }
    
    func addTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 32.0, weight: .bold)
        titleLabel.textColor = ColorPreferences.primary
        titleLabel.text = DisplayString.gameIntro
        titleLabel.textAlignment = .center
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // add into subview
        self.containerStack.addArrangedSubview(titleLabel)
    }
    
    func addContinueButton() {
        continueButton.setTitle(DisplayString.getStarted, for: .normal)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        
        // add into subview
        self.containerStack.addArrangedSubview(continueButton)
    }
}

// MARK: - Action Methods
private extension HomeViewController {
    @objc func didTapContinueButton() {
        delegate?.startGame()
    }
}

private struct Constraints {
    static let margin = CGFloat(16)
    static let spacing = CGFloat(32)
}
