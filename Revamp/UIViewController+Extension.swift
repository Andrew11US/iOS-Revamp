//
//  UIViewController+Extension.swift
//  Revamp
//
//  Created by Andrew on 4/25/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    // MARK: - Alert Controller wrapper
    internal func showAlertWithTitle(_ title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertVC.addAction(action)
        
        DispatchQueue.main.async { () -> Void in
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Adds animations to UIIVewController class
    internal func animate(view: UIView, constraint: NSLayoutConstraint, to: Int) {
        constraint.constant = CGFloat(to)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            if to == 0 {
                view.superview?.subviews[0].isUserInteractionEnabled = true
            } else {
                view.superview?.subviews[0].isUserInteractionEnabled = false
            }
        }
    }
    
}
