//
//  Extensions.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 24/10/23.
//

import Foundation
import UIKit

open class TapGestureActionBlock : UITapGestureRecognizer {
    var action : (() -> Void)? = nil
}

extension UIView {
    public func addTapGesture(action: @escaping () -> Void) {
        self.endEditing(true)
        let tapgesture = TapGestureActionBlock(target: self, action: #selector(self.handleTap(_:)))
        tapgesture.action = action
        tapgesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapgesture)
        self.isUserInteractionEnabled = true
    }
    
    @objc public func handleTap(_ sender: TapGestureActionBlock) {
        sender.action!()
    }
    
    func dismissKeyboard(){
        self.endEditing(true)
    }

    func animate() {
        UIView.animate(withDuration: 0.35) {
            self.layoutIfNeeded()
        }
    }
    
    func setupEmptyView(text : String, isShow : Bool) {
        if !isShow {
            if let label = self.subviews.first(where: { $0.tag == 909 }) {
                label.removeFromSuperview()
            }
        } else {
            let label = UILabel()
            label.text = text
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = UIColor.label
            label.tag = 909
            self.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
    }
    
    func showEmptyWarning() {
        // Add border width, will need for Empty warning animation
        self.layer.borderWidth = 1
        
        let borderColorKeyPath = "borderColor"

        // Create a CABasicAnimation for the border color
        let borderColorAnimation = CABasicAnimation(keyPath: borderColorKeyPath)
        borderColorAnimation.fromValue = UIColor.red.cgColor
        borderColorAnimation.toValue = self.layer.borderColor
        borderColorAnimation.duration = 0.25
        borderColorAnimation.autoreverses = true
        borderColorAnimation.repeatCount = 3 // Blink thrice
        borderColorAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        // Use CATransaction to perform actions after the animation
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            // Animation has completed; remove border width
            self.layer.borderWidth = 0
            self.becomeFirstResponder()
        }

        // Apply the animation to the view's layer
        self.layer.add(borderColorAnimation, forKey: "borderColorAnimation")
        
        // Commit the transaction
        CATransaction.commit()
    }
    
    // Add a Done button on top of Keyboard to dismiss the keyboard
    func addDismissButton(view : UITextView) -> UIView{
        let doneButton = UIButton(type: .custom)
        doneButton.setTitle("Done", for: .normal)
        doneButton.tintColor = .link
        
        doneButton.addTapGesture {
            view.resignFirstResponder()
        }

        let accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        accessoryView.backgroundColor = .systemGray6
        
        accessoryView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        doneButton.centerYAnchor.constraint(equalTo: accessoryView.centerYAnchor).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: accessoryView.trailingAnchor, constant: -20).isActive = true
        
        return accessoryView

    }

}

extension UILabel {
    
    // Get Lable full height
    func getHeight() -> CGFloat{
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: .greatestFiniteMagnitude))
        label.numberOfLines = self.numberOfLines
        label.text = self.text
        label.font = self.font
        label.sizeToFit()
        return label.frame.height
    }
}
