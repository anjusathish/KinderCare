//
//  DesignableView.swift
//  MedEvent
//
//  Created by Athiban Ragunathan on 23/06/18.
//  Copyright © 2018 Athiban Ragunathan. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
class DesignableView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    
    @IBInspectable var isCircle: Bool = false {
        didSet {
            if isCircle == true {
                layer.cornerRadius = frame.height/2
            }
        }
    }
    
    @IBInspectable var isAddShadow: Bool = false {
        didSet {
            if isAddShadow == true {
               // self.addShadow()
            }
        }
    }
}
