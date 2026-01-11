//
//  UIView+Extensions.swift
//  DoctorRegistrationApp
//
//  Created for iOS Assignment
//

import UIKit

extension UIView {
    
    /// Adds corner radius to the view
    /// - Parameter radius: Corner radius value
    func addCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    /// Adds border to the view
    /// - Parameters:
    ///   - color: Border color
    ///   - width: Border width
    func addBorder(color: UIColor, width: CGFloat = 1.0) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    /// Adds shadow to the view
    /// - Parameters:
    ///   - color: Shadow color
    ///   - opacity: Shadow opacity
    ///   - offset: Shadow offset
    ///   - radius: Shadow radius
    func addShadow(color: UIColor = .black, opacity: Float = 0.1, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 4) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
    
    /// Rounds specific corners
    /// - Parameters:
    ///   - corners: Corners to round
    ///   - radius: Corner radius
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UITextField {
    
    /// Styles the text field with rounded corners and padding
    func styleAsRoundedField() {
        addCornerRadius(8)
        addBorder(color: UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0), width: 1)
        
        // Add left padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
        
        // Set placeholder color
        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: UIColor.lightGray]
            )
        }
    }
}

extension UIButton {
    
    /// Styles the button with rounded corners and fill color
    /// - Parameters:
    ///   - backgroundColor: Background color
    ///   - titleColor: Title color
    func styleAsFilledButton(backgroundColor: UIColor, titleColor: UIColor = .white) {
        self.backgroundColor = backgroundColor
        setTitleColor(titleColor, for: .normal)
        addCornerRadius(8)
    }
    
    /// Styles the button with bordered style
    /// - Parameters:
    ///   - borderColor: Border color
    ///   - titleColor: Title color
    func styleAsBorderedButton(borderColor: UIColor, titleColor: UIColor) {
        backgroundColor = .clear
        setTitleColor(titleColor, for: .normal)
        addCornerRadius(8)
        addBorder(color: borderColor, width: 1.5)
    }
    
    /// Styles as circular button
    func styleAsCircularButton() {
        addCornerRadius(bounds.width / 2)
    }
}
