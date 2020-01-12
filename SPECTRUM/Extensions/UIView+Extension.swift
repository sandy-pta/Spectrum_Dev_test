//
//  UIView+Extension.swift
//  Fandex
//
//  Created by Sandeep Malhotra on 01/09/18.
//  Copyright © 2018 Sandeep Malhotra. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func applyBorder(withBorderColor borderColor: UIColor?, withBorderWidth borderWidth: CGFloat?) {
        if let color = borderColor, let border = borderWidth {
            self.layer.borderColor = color.cgColor
            self.layer.borderWidth = border
            self.layer.masksToBounds = true
        }
    }
    func makeRoundedCorners(withCornerRadius cornerRadius: CGFloat?) {
        if let radius = cornerRadius {
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = true
        }
    }
    
    func makeRoundedCorners(withCornerRadius cornerRadius: CGFloat?, withColor borderColor: UIColor?) {
        if let radius = cornerRadius, let color = borderColor {
            self.layer.borderColor = color.cgColor
            self.layer.borderWidth = 1.0
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = true
        }
    }
}
