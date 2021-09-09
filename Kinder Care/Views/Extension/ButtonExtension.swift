//
//  ButtonExtension.swift
//  Customer
//
//  Created by Athiban Ragunathan on 22/11/17.
//  Copyright © 2017 Athiban Ragunathan. All rights reserved.
//

import UIKit

extension UIButton {
    
    func cornerRadiusWithSize(radius : CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func addUnderline() {
        let yourAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: (self.titleLabel?.font.pointSize)!),
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        
        let attributeString = NSMutableAttributedString(string: self.titleLabel?.text ?? "",
                                                        attributes: yourAttributes)
        self.setAttributedTitle(attributeString, for: .normal)
    }
    
    func removeGradientLayer() {
        for item in layer.sublayers ?? []{
            if item.name == "gradientLayer" {
                item.removeFromSuperlayer()
            }
        }
    }
}
