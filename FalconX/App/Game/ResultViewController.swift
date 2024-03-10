//
//  ResultViewController.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import UIKit
import XConstraintKit

protocol ResultViewControllerDelegate: AnyObject {
    func startOver()
}

class ResultViewController: BaseViewController {
    // MARK: - Dependencies
    private let viewModel: GameViewModel
    private unowned let delegate: ResultViewControllerDelegate
    
    // MARK: - Properties
    // Loader Views
    private var loaderContainerView: UIView!
    private var loaderView: FXLoaderView!
    
    // container views
    private let containerStackView = UIStackView()
    private let innerContentStackView = UIStackView()
    private let contentBodyStackView = UIStackView()
    
    // labels and buttons
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let timeTakenLabel = UILabel()
    private let planetFoundLabel = UILabel()
    private let startOverButton = FXButton(type: .custom)
    
    init(viewModel: GameViewModel, delegate: ResultViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented . use init(viewModel: GameViewModel, delegate: ResultViewControllerDelegate)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoaderView()
        submitUserSelections()
    }
}

// MARK: - UI Methods
private extension ResultViewController {
    func setupLoaderView() {
        // remove container stack (not need though)
        containerStackView.removeFromSuperview()
        
        loaderContainerView = UIView(frame: .zero)
        loaderContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loaderContainerView)
        
        let axialConstraints: [XLayoutAxisConstraintable] = [XVerticalConstraint.center,
                                                          XLayoutAxisConstraint.center()]
        
        let dimensionalConstraints: [XLayoutDimensionConstraintable] = [XDimensionConstraint.height(constant: Constraints.loaderDimension),
                                                                     XDimensionConstraint.width(constant: Constraints.loaderDimension)]
        
        axialConstraints.activateConstraints(for: loaderContainerView, with: self.view)
        dimensionalConstraints.activateConstraints(for: loaderContainerView)
        
        loaderView = FXLoaderView(view: loaderContainerView)
        loaderView.play()
    }
    
    func setupResultView() {
        
        //remove loader contrainer view
        loaderContainerView.removeFromSuperview()
        
        // set up contrainer stack
        setup(containerStackView, spacing: Constraints.outerGap)
        
        // add into subview
        self.view.addSubview(containerStackView)
        
        // add constraints
        let containerConstraint: [XLayoutAxisConstraintable] = [XVerticalConstraint.center,
           XLayoutAxisConstraint.left()
            .constant(to: Constraints.outerMargin),
           XLayoutAxisConstraint.right()
            .constant(to: Constraints.outerMargin)]
        
        containerConstraint.activateConstraints(for: containerStackView, with: self.view)
        
        // setup title label
        setup(titleLabel, text: DisplayString.findingFalcon, fontSize: Constraints.titleLabelFontSize)
        
        // setup inner content
        setupInnerContentStack()
        
        // setup startOver Button
        setup(startOverButton, text: DisplayString.startOver, action: #selector(startOverButtonAction))
        
        // add arranged subViews
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(innerContentStackView)
        containerStackView.addArrangedSubview(startOverButton)
    }
    
    func setupInnerContentStack() {
        setup(innerContentStackView, spacing: Constraints.innerGap)
        
        if viewModel.getFoundPlanetName() != nil {
            setup(descriptionLabel, text: DisplayString.successMessage, fontSize: Constraints.descriptionLabelFontSize)
            setupContentBodyStack()
            
            //add arranged subviews
            innerContentStackView.addArrangedSubview(descriptionLabel)
            innerContentStackView.addArrangedSubview(contentBodyStackView)
        } else {
            setup(descriptionLabel, text: DisplayString.failureMessage, fontSize: Constraints.descriptionLabelFontSize)
            
            //add arranged subviews
            innerContentStackView.addArrangedSubview(descriptionLabel)
        }
    }
    
    func setupContentBodyStack() {
        guard let planetName = viewModel.getFoundPlanetName() else {
            contentBodyStackView.isHidden = true
            return
        }
        
        // setup content body
        setup(contentBodyStackView, spacing: Constraints.contentBodyGap)
        
        // set up labels
        setup(planetFoundLabel, text: "\(DisplayString.plantetFound)\(planetName)", fontSize: Constraints.defaultLabelFontSize)
        setup(timeTakenLabel, text: "\(DisplayString.timeTaken)\(viewModel.timeTaken)", fontSize: Constraints.defaultLabelFontSize)

        // add arranged subviews
        contentBodyStackView.addArrangedSubview(planetFoundLabel)
        contentBodyStackView.addArrangedSubview(timeTakenLabel)
    }
    
    func setup(_ stackView: UIStackView, spacing: CGFloat) {
        stackView.axis = .vertical
        
        stackView.distribution = .fill
        stackView.alignment = .center
        
        stackView.spacing = spacing
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setup(_ label: UILabel, text: String, fontSize: CGFloat) {
        label.textAlignment = .center
        label.text = text
        label.font = .systemFont(ofSize: fontSize, weight: .bold)
        label.numberOfLines = 0
        label.textColor = ColorPreferences.primary
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setup(_ button: FXButton, text: String, action selector: Selector) {
        button.setTitle(text, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Private Methods
private extension ResultViewController {
    func submitUserSelections() {
        viewModel.submit { [weak self] error in
            guard let self else { return }
            
            if let error {
                debugPrint(error)
                
                let oneTimeAlertItem: AlertActionItem = .destructiveAction(title: DisplayString.okay, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                
                let alerts: [AlertActionItem] = [oneTimeAlertItem]
                
                self.showAlertController(with: DisplayString.unknownError, message: DisplayString.errorWhileSubmit, alerts: alerts)

                return
            }
            
            self.setupResultView()
        }
    }
}

// MARK: - Actions
private extension ResultViewController {
    @objc func popCurrentViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func startOverButtonAction() {
        delegate.startOver()
    }
}

private struct Constraints {
    static let loaderDimension = CGFloat(64.0)
    
    static let titleLabelFontSize = CGFloat(32.0)
    static let descriptionLabelFontSize = CGFloat(18.0)
    static let defaultLabelFontSize = CGFloat(14.0)
    
    static let outerMargin = CGFloat(16.0)
    static let outerGap = CGFloat(64.0)
    static let innerGap = CGFloat(32.0)
    static let contentBodyGap = CGFloat(16.0)
}
