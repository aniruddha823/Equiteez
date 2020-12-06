//
//  ToastSwift.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 1/10/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import UIKit

/* Enum to indicate what position the toast should be displayed on the screen */
enum ToastPosition {
    case center
    case top
    case bottom
}

extension UIView {
    
    /* Main function that creates the toast view & its disappearing animation (the toast duration & position parameters are optional). */
    func makeToast(message: String, duration: Double = 3, position: ToastPosition = .center) {
        
        let toastView = UITextView();  addSubview(toastView)
        
        setupToastView(toastView: toastView, message: message)
        positionToastView(toastView: toastView, position: position)
        
        UIView.animate(withDuration: duration, delay: 1, options: .transitionCrossDissolve, animations: {
            toastView.alpha = 0
        }, completion: { (isCompleted) in
            toastView.removeFromSuperview()
        })
    }

    /* Sets up the properties of the toast view. */
    private func setupToastView(toastView: UITextView, message: String) {
        
        toastView.translatesAutoresizingMaskIntoConstraints = false;
        toastView.isScrollEnabled = false
        toastView.clipsToBounds = true
        toastView.layer.cornerRadius = 10
        toastView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        toastView.textAlignment = .center
        toastView.font = UIFont(name: "Avenir Next", size: 12.0)
        toastView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        toastView.text = message
        toastView.sizeToFit()
    }

    /* Sets the position of the toast view within its superview using layout constraints (default position is in the center). */
    private func positionToastView(toastView: UITextView, position: ToastPosition) {
        
        toastView.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true // Sets a max toast width of 200
        toastView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true // All x-positions are the same
        
        switch position {
        case .center:
            toastView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        case .top:
            toastView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        case .bottom:
            toastView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 20 - toastView.frame.height).isActive = true
        }
    }
}
