//
//  GameViewController.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import UIKit

class GameViewController: BaseViewController {
    // MARK: - Dependencies
    private var viewModel: GameViewModel
    
    // MARK: - Properties
    private var pageViewController = FXPageViewController()
    private var containerView = UIStackView()
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var buttonStackView = UIStackView()
    private var leftButton = FXButton(type: .custom)
    private var rightButton = FXButton(type: .custom)
    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, use init(viewModel: GameViewModel)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: - UI Methods
private extension GameViewController {
    func setup() {
        // setup container
        setupContainerView()
        
        // add container as subview of view controller's view
        self.view.addSubview(containerView)
        
        // add constraints
        let constraints: [FXLayoutAxisConstraint] = [FXVerticalConstraint.top(constant: Constraints.topMargin),
                                                     FXHorizontalConstraint.left(constant: Constraints.leftMargin),
                                                      FXHorizontalConstraint.right()]
        
        constraints.activateConstraints(for: containerView, with: self.view)
        
        // set up title label
        setup(titleLabel, text: DisplayString.findingFalcon, fontSize: Constraints.titleLabelFontSize)
        
        // set up description label
        setup(descriptionLabel, text: DisplayString.selectPlanetDesc, fontSize: Constraints.descriptionLabelFontSize)
        
        // setup page view controller
        setupPageViewController()
        
        setupButtonStack()
        
        // Add arranged views
        containerView.addArrangedSubview(titleLabel)
        containerView.addArrangedSubview(descriptionLabel)
        containerView.addArrangedSubview(pageViewController.view)
        containerView.addArrangedSubview(buttonStackView)
        
        // add child view controller
        self.addChild(pageViewController)
        pageViewController.didMove(toParent: self)
    }
    
    func setupContainerView() {
        containerView.axis = .vertical

        containerView.spacing = Constraints.gap
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupButtonStack() {
        buttonStackView.axis = .horizontal
        
        setup(leftButton, text: DisplayString.back, action: #selector(didTapLeft))
        setup(rightButton, text: DisplayString.next, action: #selector(didTapRight))
        
        buttonStackView.addArrangedSubview(leftButton)
        buttonStackView.addArrangedSubview(rightButton)
    }
    
    func setupPageViewController() {
        // Intialize pageview controller
        pageViewController.dataSource = self
        
        // Hide the default page control
        pageViewController.view.subviews.forEach { view in
            if view is UIPageControl {
                view.isHidden = true
            }
        }

        pageViewController.view.backgroundColor = .clear
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [FXLayoutDimensionConstraint] = [FXDimensionConstraint.height(constant: Constraints.contentHeight)]
        
        constraints.activateConstraints(for: pageViewController.view)
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

// MARK: - Button Action Methods
private extension GameViewController {
    @objc func didTapLeft() {
        guard viewModel.hasPrev() else { return }
        
        viewModel.moveToPrev()
        pageViewController.setCurrentIndex(viewModel.selectedIndex)
    }
    
    @objc func didTapRight() {
        guard viewModel.hasNext() else { return }
        
        viewModel.moveToNext()
        pageViewController.setCurrentIndex(viewModel.selectedIndex)
    }
}

// MARK: - UIPageViewControllerDataSource
extension GameViewController: FXPageViewControllerDataSource {
    func view(forItemAtIndex index: Int) -> UIView? {
        guard index >= 0 && index < viewModel.totalDestinationCount else { return nil }
        
        return GameView(viewModel: self.viewModel)
    }
}

// MARK: - Constraints
private struct Constraints {
    static let titleLabelFontSize = CGFloat(32.0)
    static let descriptionLabelFontSize = CGFloat(18.0)
    static let topMargin = CGFloat(32.0)
    static let leftMargin = CGFloat(16.0)
    static let gap = CGFloat(32.0)
    static let contentHeight = CGFloat(400)
}
