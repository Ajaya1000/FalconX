//
//  GameViewController.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import UIKit
import XConstraintKit

protocol GameViewControllerDelegate: AnyObject {
    func submitSelections()
}

class GameViewController: FXScrollViewController {
    // MARK: - Dependencies
    private let viewModel: GameViewModel
    private unowned let delegate: GameViewControllerDelegate
    
    // MARK: - Properties
    private let pageViewController = FXPageViewController()
    private let containerView = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let buttonStackView = UIStackView()
    private let leftButton = FXButton(type: .custom)
    private let rightButton = FXButton(type: .custom)
    
    private var shouldShowConset: Bool = true
    
    init(viewModel: GameViewModel, delegate: GameViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        
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
        self.backgroundView.addSubview(containerView)

        // add constraints
        let contentLayoutconstraints: [XLayoutAxisConstraint] = []
        
        containerView.activate(with: self.backgroundView.contentLayoutGuide) { xc in
            xc.top.constant(to: Constraints.topMargin)
            xc.bottom
            xc.leading.constant(to: Constraints.horizontalMargin)
            xc.trailing.constant(to: -Constraints.horizontalMargin)
        }
        
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
        
        syncButtonActionState()
        
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
        
        pageViewController.view.activate { xc in
            xc.height.constant(to: Constraints.contentHeight)
        }
    }
    
    func syncButtonActionState() {
        leftButton.isEnabled = viewModel.canMovePrev()
        rightButton.isEnabled = viewModel.canMoveNext()
        
        if viewModel.isLast() {
            rightButton.setTitle(DisplayString.submit, for: .normal)
        } else {
            rightButton.setTitle(DisplayString.next, for: .normal)
        }
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

private extension GameViewController {
    func askConset(_ completion: @escaping (Bool) -> Void) {
        guard shouldShowConset else {
            completion(true)
            return
        }
        
        let dontAskAgainAlertItem: AlertActionItem = .destructiveAction(title: DisplayString.dontAskAgain, handler: { [weak self] _ in
            guard let self = self else { return }
            self.shouldShowConset = false
            completion(true)
        })
        
        let oneTimeAlertItem: AlertActionItem = .destructiveAction(title: DisplayString.okay, handler: { _ in
            completion(true)
        })
        
        let cancelAlertItem: AlertActionItem = .action(title: DisplayString.cancel, handler: { _ in
            completion(false)
        })
        
        let alerts: [AlertActionItem] = [dontAskAgainAlertItem, oneTimeAlertItem, cancelAlertItem]
        
        self.showAlertController(with: DisplayString.wantToGoBack, message: DisplayString.currentSelectionWarning, alerts: alerts)
    }
}

// MARK: - Button Action Methods
private extension GameViewController {
    @objc func didTapLeft() {
        guard viewModel.canMovePrev() else { return }
        
        let completion = { [weak self] status in
                guard let self,
                      status else { return }
                
                self.viewModel.moveToPrev()
                self.pageViewController.setCurrentIndex(self.viewModel.selectedIndex)
                self.syncButtonActionState()
        }
        
        guard viewModel.currentSelectionValidity() else {
            completion(true)
            return
        }
        
        askConset(completion)
    }
    
    @objc func didTapRight() {
        guard viewModel.canMoveNext() else { return }
        
        if viewModel.isLast() {
            self.delegate.submitSelections()
            return
        }
        
        viewModel.moveToNext()
        pageViewController.setCurrentIndex(viewModel.selectedIndex)
        syncButtonActionState()
    }
}

// MARK: - UIPageViewControllerDataSource
extension GameViewController: FXPageViewControllerDataSource {
    func view(forItemAtIndex index: Int) -> UIView? {
        guard index >= 0 && index < viewModel.totalDestinationCount else { return nil }
        
        return GameView(viewModel: self.viewModel, delegate: self)
    }
}

extension GameViewController: GameViewDelegate {
    func didUpdateData() {
        syncButtonActionState()
    }
    
    func showAlert(with title: String) {
        showAlertController(with: title, alerts: [.action(title: DisplayString.cancel)])
    }
}

// MARK: - Constraints
private struct Constraints {
    static let titleLabelFontSize = CGFloat(32.0)
    static let descriptionLabelFontSize = CGFloat(18.0)
    static let topMargin = CGFloat(64.0)
    static let horizontalMargin = CGFloat(16.0)
    static let gap = CGFloat(64.0)
    static let contentHeight = CGFloat(200)
}
