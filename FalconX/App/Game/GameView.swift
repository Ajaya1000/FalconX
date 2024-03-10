//
//  GameViewController.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import UIKit
import XConstraintKit

protocol GameViewDelegate: AnyObject {
    func didUpdateData()
    func showAlert(with title: String)
}

class GameView: UIView {
    // MARK: - Dependencies
    private let viewModel: GameViewModel
    private unowned let delegate: GameViewDelegate
    
    // MARK: - Properties
    private let containerView = UIStackView()
    private let planetInfoLabel = UILabel()
    private let vehicleInfoLabel = UILabel()
    private let planetTextField = UITextField()
    private let vehicleTextField = UITextField()
    private let pickerView = UIPickerView()
    
    private var selectedTextField: TextFieldType = .none
    
    init(viewModel: GameViewModel, delegate: GameViewDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        
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
        
        // setup planet
        setup(planetTextField)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.planetTextField.becomeFirstResponder()
        }
        
        fill(type: .planet)
        
        // setup vehicle
        setup(vehicleTextField)
        fill(type: .vehicle)
        
        setupPickerView()
        
        // Add arragned subviews to the stack
        containerView.addArrangedSubview(planetInfoLabel)
        containerView.addArrangedSubview(planetTextField)
        containerView.addArrangedSubview(vehicleInfoLabel)
        containerView.addArrangedSubview(vehicleTextField)
        
        // Add Container Stack View
        self.addSubview(containerView)
        
        let constraints: [XLayoutAxisConstraint] = [.right.constant(to: Constraints.outerMargin),
                                                    .left.constant(to: Constraints.outerMargin),
                                                    .top,
                                                    .bottom]
        
        // Activate required constraints
        constraints.activateConstraints(for: containerView, with: self)
    }
    
    func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.axis = .vertical
        containerView.distribution = .fillEqually
        containerView.alignment = .fill
    }
    
    func setup(_ label: UILabel, text: String) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorPreferences.primary
        label.textAlignment = .center
        label.text = text
    }
    
    func setup(_ textField: UITextField) {
        textField.textColor = .white
        textField.textAlignment = .center
        textField.layer.borderWidth = Constraints.borderWidth
        textField.layer.borderColor = UIColor.white.cgColor
    
        textField.inputView = pickerView
        
        textField.delegate = self
    }
    
    func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    private func fill(type: TextFieldType) {
        switch type {
        case .planet:
            planetTextField.text = viewModel.getCurrentPlanet()?.name
        case .vehicle:
            vehicleTextField.text = viewModel.getCurrentVehicle()?.name
        default:
            break
        }
    }
    
    private func didSelectItem(at index: Int) {
        switch selectedTextField {
        case .planet:
            viewModel.didSelectPlanet(at: index)
        case .vehicle:
            viewModel.didSelectVehicle(at: index)
        default:
            break
        }
        
        fill(type: selectedTextField)
        
        // call delegate to update it's view
        delegate.didUpdateData()
    }
}

// MARK: - UITextFieldDelegate
extension GameView: UITextFieldDelegate {
    private enum TextFieldType {
        case planet
        case vehicle
        case none
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case planetTextField:
            self.selectedTextField = .planet
        case vehicleTextField:
            if viewModel.getCurrentPlanet() == nil {
                delegate.showAlert(with: DisplayString.selectPlanetWarning)
                return false
            }
            
            self.selectedTextField = .vehicle
        default:
            self.selectedTextField = .none
        }
        
        pickerView.reloadAllComponents()
        
        return true
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension GameView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        viewModel.numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch selectedTextField {
        case .planet:
            return viewModel.availablePlanets.count
        case .vehicle:
            return viewModel.availableVehicles.count
        case .none:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch selectedTextField {
        case .planet:
            return viewModel.availablePlanets[safe: row]?.name
        case .vehicle:
            return viewModel.availableVehicles[safe: row]?.name
        case .none:
            return .empty
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelectItem(at: row)
    }
}

// MARK: - Constraints
private struct Constraints {
    static let outerMargin = CGFloat(16.0)
    static let borderWidth = CGFloat(1.0)
}
