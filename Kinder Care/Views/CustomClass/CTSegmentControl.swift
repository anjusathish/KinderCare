//
//  CTSegmentControl.swift
//  Clear Thinking
//
//  Created by Athiban Ragunathan on 04/07/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CTSegmentControl: UIControl {
    
    private var shadowLayer: CAShapeLayer!
    private var buttons : [UIButton] = []
    private var selector : UIView!
    
    var selectedSegmentIndex = 0
    var selectedSegmentTitle = ""
    
    @IBInspectable
    var segmentStyle : Int = 0 {
        didSet {
            setSegmentButtons()
        }
    }
    
    @IBInspectable
    var segmentTitles : String = "" {
        didSet {
            setSegmentButtons()
        }
    }
    
    @IBInspectable
    var segmentTitleColor : UIColor = UIColor.ctGrgeen {
        didSet {
            setSegmentButtons()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height/2).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
            shadowLayer.shadowOpacity = 0.0
            shadowLayer.shadowRadius = 5
            self.backgroundColor = UIColor.clear
            layer.insertSublayer(shadowLayer, at: 0)
            setSegmentButtons()
        }
    }
    
    func setSegmentButtons() {
        
        buttons.removeAll()
        subviews.forEach({view in
            view.removeFromSuperview()
        })
        
        let titles = segmentTitles.components(separatedBy: ",")
        
        if let firstTitle = titles.first {
            selectedSegmentTitle = firstTitle
        }
        
        for (index, title) in titles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            
            setTitleColor(button: button)
            
            button.titleLabel?.numberOfLines = 2
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.textAlignment = .center
            button.tag = index
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            buttons.append(button)
            
        }
        
        let selectorWidth = frame.width / CGFloat(titles.count)
        selector = UIView(frame: CGRect(x: 5, y: 5, width: selectorWidth-10, height: frame.height-10))
        
        switch segmentStyle {
        case 0:
            buttons.first?.setTitleColor(UIColor.white, for: .normal)
            selector.layer.borderWidth = 5
            selector.layer.borderColor = UIColor.clear.cgColor
            selector.layer.cornerRadius = selector.frame.size.height/2
            selector.backgroundColor = segmentTitleColor
            
        case 1:
            selector.frame.size.height = 2
            selector.frame.origin.y = frame.height-2
            buttons.first?.setTitleColor(UIColor.ctBlue, for: .normal)
            selector.layer.borderWidth = 5
            selector.layer.borderColor = UIColor.clear.cgColor
            selector.layer.cornerRadius = selector.frame.size.height/2
            selector.backgroundColor = segmentTitleColor
            
        default: break
        }
        
        addSubview(selector)
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    }
    
    func setTitleColor(button : UIButton) {
        switch segmentStyle {
        case 0: button.setTitleColor(segmentTitleColor, for: .normal)
        case 1: button.setTitleColor(.gray, for: .normal)
        default: break
        }
    }
    
    @objc func buttonAction(sender : UIButton) {
        
        
        buttons.forEach({setTitleColor(button: $0)})
        sender.setTitleColor(UIColor.white, for: .normal)
        
        switch segmentStyle {
        case 0:sender.setTitleColor(UIColor.white, for: .normal)
        case 1:sender.setTitleColor(UIColor.ctBlue, for: .normal)
        default: break
        }
        
        selectedSegmentIndex = sender.tag
        selectedSegmentTitle = sender.titleLabel!.text!
        
        let selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(sender.tag)
        UIView.animate(withDuration: 0.3, animations: {
            self.selector.frame.origin.x = selectorStartPosition + 5
        })
        
        sendActions(for: .valueChanged)
    }
}
