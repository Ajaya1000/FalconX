//
//  FXScrollViewController.swift
//  FalconX
//
//  Created by Ajaya Mati on 08/09/23.
//

import UIKit
import XConstraintKit

class FXScrollViewController: BaseViewController {

    var backgroundView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShowOrHide))
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillShowOrHide))
        
        initializeHideKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }

}

// MARK: UI Methoods
private extension FXScrollViewController {
    func setup() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(backgroundView)
        
        let constraints: [XLayoutAxisConstraintable] = [XLayoutAxisConstraint.left(),
                                                    XLayoutAxisConstraint.right(),
                                                     XVerticalConstraint.top(),
                                                    XVerticalConstraint.bottom()]
        
        constraints.activateConstraints(for: self.view, with: backgroundView.frameLayoutGuide)
        
        backgroundView.contentLayoutGuide.widthAnchor.constraint(equalTo: backgroundView.frameLayoutGuide.widthAnchor).isActive = true
    }
}

// MARK: Keyboard Dismissal Handling on Tap
private extension FXScrollViewController {
    
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

// MARK: Textfield Visibility Handling with Scroll

private extension FXScrollViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShowOrHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey],
              let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey],
              let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] else { return }
        
        let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
        let keyboardOverlap = backgroundView.frame.maxY - endRect.origin.y
        backgroundView.contentInset.bottom = keyboardOverlap
        backgroundView.verticalScrollIndicatorInsets.bottom = keyboardOverlap
        
        let duration = (durationValue as AnyObject).doubleValue / 2.0
        let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
