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

extension UIViewController {
    public func pushViewController<T: UIViewController>(_ viewControllerType: T.Type, storyboardName: String, identifier: String, animated: Bool = true) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! T
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
}


extension UIView {
    public func addTapGesture(action: @escaping () -> Void) {
        let tapgesture = TapGestureActionBlock(target: self, action: #selector(self.handleTap(_:)))
        tapgesture.action = action
        tapgesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapgesture)
        self.isUserInteractionEnabled = true
    }
    
    @objc public func handleTap(_ sender: TapGestureActionBlock) {
        sender.action!()
    }

}
