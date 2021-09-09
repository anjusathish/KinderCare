//
//  CTSwitch.swift
//  Clear Thinking
//
//  Created by Athiban Ragunathan on 04/07/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CTSwitch: UIControl {
    
    private var buttons : [UIButton] = []
    private var shadowLayer: CAShapeLayer!
    private var seperator : UILabel?
    
    @IBInspectable
    var offColor : UIColor = UIColor(hex: 0xE6E4E6, alpha: 1.0) {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var onColor : UIColor = .ctBlue {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var offTitleColor : UIColor = .black {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var onTitleColor : UIColor = .white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var offTitle : String = "No" {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var onTitle : String = "Yes" {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var isOn : Bool = false {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        buttons.removeAll()
        subviews.forEach({view in
            view.removeFromSuperview()
        })
        
        for title in [onTitle,offTitle] {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(offTitleColor, for: .normal)
            button.backgroundColor = offColor
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            buttons.append(button)
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        }
        
        if isOn {
            buttons.first?.setTitleColor(onTitleColor, for: .normal)
            buttons.first?.backgroundColor = onColor
            buttons.first?.addInnerShadow()
        }
        else {
            buttons.last?.setTitleColor(onTitleColor, for: .normal)
            buttons.last?.backgroundColor = onColor
            buttons.last?.addInnerShadow()
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        seperator = UILabel(frame: CGRect(x: frame.width/2-0.5, y: 8, width: 1, height: frame.height-16))
        seperator?.backgroundColor = .gray
       // addSubview(seperator!)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
            shadowLayer.shadowOpacity = 0
            shadowLayer.shadowRadius = 0
            self.backgroundColor = UIColor.clear
            layer.insertSublayer(shadowLayer, at: 0)
            updateView()
        }
    }
    
    @objc func buttonAction(sender : UIButton) {
        
        seperator?.removeFromSuperview()
        
        buttons.forEach({ button in
            button.setTitleColor(offTitleColor, for: .normal)
            button.backgroundColor = offColor
        })
        
        sender.setTitleColor(onTitleColor, for: .normal)
        sender.backgroundColor = onColor
        
        isOn = sender.titleLabel?.text == onTitle
        
        sendActions(for: .valueChanged)
    }
}

extension UIButton
{
    func addInnerShadow() {
        let innerShadow = CALayer()
        innerShadow.frame = bounds
        // Shadow path (1pt ring around bounds)
        let path = UIBezierPath(rect: innerShadow.bounds.insetBy(dx: -1, dy: -1))
        let cutout = UIBezierPath(rect: innerShadow.bounds).reversing()
        path.append(cutout)
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true
        // Shadow properties
        innerShadow.shadowColor = UIColor.black.cgColor // UIColor(red: 0.71, green: 0.77, blue: 0.81, alpha: 1.0).cgColor
        innerShadow.shadowOffset = CGSize.zero
        innerShadow.shadowOpacity = 1
        innerShadow.shadowRadius = 3
        // Add
        layer.addSublayer(innerShadow)
    }
}
