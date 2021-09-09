//
//  CTTextField.swift
//  Clear Thinking
//
//  Created by Athiban Ragunathan on 02/07/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation
import UIKit

enum ValidationRule : String {
    
    case email = "email"
    case phoneNumber = "phoneNumber"
    case pincode = "pincode"
    
    var validationMessage : String {
        get {
            switch self {
            case .email:
                return "Invalid email"
            case .phoneNumber:
                return "Invalid phone number"
            case .pincode:
                return "Invalid postal code"
            }
        }
    }
}

@IBDesignable
class CTTextField: UITextField, UITextFieldDelegate {
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 20
    
    @IBInspectable var style: Int = 0 {
        didSet {
            design()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 20
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var bgcolor: UIColor = UIColor.ctGray {
        didSet {
            design()
        }
    }
    
    @IBInspectable var rightViewRect: CGSize = CGSize(width: 20, height: 20) {
        didSet {
            updateView()
        }
    }
    
    var rule : ValidationRule? {
        didSet {
            delegate = self
        }
    }
    
    private var shadowLayer: CAShapeLayer!
    private var leftImageView : UIImageView?
    private var rightImageView : UIImageView?
    private var isSecureField : Bool = false
    
    override func awakeFromNib() {
        
        if isSecureTextEntry {
            isSecureField = true
            rightViewMode = UITextField.ViewMode.always
            rightImageView = UIImageView(frame: CGRect(origin: .zero, size: rightViewRect))
            rightImageView?.contentMode = .scaleAspectFit
            rightImageView?.image = UIImage(named: "passwordDisable")
            rightView = rightImageView
            rightView?.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPasswordAction))
            rightView?.addGestureRecognizer(tapGesture)
        }
        
        self.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil { 
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.shadowPath = shadowLayer.path
            layer.cornerRadius = 20
            design()
            leftImageView?.tintColor = UIColor.gray
            rightImageView?.tintColor = UIColor.gray
            tintColor = UIColor.ctBlue
        }
    }
    
    @objc func showPasswordAction() {
        isSecureTextEntry = !isSecureTextEntry
        rightView?.tintColor = isSecureTextEntry ? UIColor.darkGray : UIColor.ctBlue
    }
    
    func design() {
        
        switch style {
        case 0:
            layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            layer.borderWidth = 1
            backgroundColor = bgcolor
            textColor = UIColor.black
        case 1:
            
           if shadowLayer != nil {
                       shadowLayer.fillColor = UIColor.white.cgColor
                                 shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
                                 shadowLayer.shadowOpacity = 0.2
                                 shadowLayer.shadowRadius = 3
                                 shadowLayer.borderWidth = 1
                                 shadowLayer.borderColor = UIColor.ctBorderGray.cgColor
                                 layer.insertSublayer(shadowLayer, at: 0)
                             }
        case 2:
            layer.borderWidth = 0
            textColor = UIColor.init(red: 59/255.0, green: 62/255.0, blue: 65/255.0, alpha: 1.0)
        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let _rule = rule {
            
            switch _rule {
                
            case .email: setError(_rule.validationMessage,show: false)
            case .phoneNumber: setError(_rule.validationMessage,show: false)
            case .pincode: setError(_rule.validationMessage,show: false)
            }
        }
    }
    
    @objc func textFieldDidChange(textField : UITextField) {
        
        if let text = textField.text {
            
            if let _rule = rule {
                
                switch _rule {
                    
                case .email: text.isValidEmail() ? setError() : setError(_rule.validationMessage,show: true)
                case .phoneNumber: text.isValidPhone() ? setError() : setError(_rule.validationMessage,show: true)
                case .pincode: text.isValidPostalCode() ? setError() : setError(_rule.validationMessage,show: true)
                }
            }
            
            if text.isEmpty {
                
                switch style {
                case 0 :
                    layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
                case 1 :

                    if shadowLayer != nil {
                                        shadowLayer.fillColor = UIColor.white.cgColor
                                                  shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
                                                  shadowLayer.shadowOpacity = 0.2
                                                  shadowLayer.shadowRadius = 3
                                                  shadowLayer.borderWidth = 1
                                                  shadowLayer.strokeColor = UIColor.ctBorderGray.cgColor
                                                  layer.insertSublayer(shadowLayer, at: 0)
                                              }
                default : break
                }
                
                leftImageView?.tintColor = UIColor.darkGray
                
                if !isSecureField {
                    rightImageView?.tintColor = UIColor.darkGray
                }
            }
            else {
                
                switch style {
                case 0 :
                    layer.borderColor = UIColor.ctBlue.cgColor
                case 1 :
             if shadowLayer != nil {
                                  shadowLayer.fillColor = UIColor.white.cgColor
                                            shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
                                            shadowLayer.shadowOpacity = 0.2
                                            shadowLayer.shadowRadius = 3
                                            shadowLayer.borderWidth = 1
                shadowLayer.strokeColor = UIColor.ctBlue.cgColor
                                        //    shadowLayer.borderColor = UIColor.ctBlue.cgColor
                                            layer.insertSublayer(shadowLayer, at: 0)
                                        }
                    
               
                default : break
                }
                                leftImageView?.tintColor = UIColor.ctBlue
                
                if !isSecureField {
                    rightImageView?.tintColor = UIColor.ctBlue
                }
            }
        }
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= leftPadding
        return textRect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.textRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        textRect.size.width -= leftPadding
        return textRect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.editingRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        textRect.size.width -= leftPadding
        return textRect
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            leftImageView?.contentMode = .scaleAspectFit
            leftImageView?.image = image
            leftView = leftImageView
        }
        
        if let image = rightImage {
            
            if !isSecureField {
                rightViewMode = UITextField.ViewMode.always
                rightImageView = UIImageView(frame: CGRect(origin: .zero, size: rightViewRect))
                rightImageView?.contentMode = .scaleAspectFit
                rightImageView?.image = image
                rightView = rightImageView
            }
        }
        else {
            rightImageView = nil
            rightView = nil
        }
    }
}

private var rightViews = NSMapTable<UITextField, UIView>(keyOptions: NSPointerFunctions.Options.weakMemory, valueOptions: NSPointerFunctions.Options.strongMemory)
private var errorViews = NSMapTable<UITextField, UIView>(keyOptions: NSPointerFunctions.Options.weakMemory, valueOptions: NSPointerFunctions.Options.strongMemory)

extension UITextField {
    // Add/remove error message
    func setError(_ string: String? = nil, show: Bool = true) {
        if let rightView = rightView, rightView.tag != 999 {
            rightViews.setObject(rightView, forKey: self)
        }
        
        // Remove message
        guard string != nil else {
            if let rightView = rightViews.object(forKey: self) {
                self.rightView = rightView
                rightViews.removeObject(forKey: self)
            } else {
                self.rightView = nil
            }
            
            if let errorView = errorViews.object(forKey: self) {
                errorView.isHidden = true
                errorViews.removeObject(forKey: self)
            }
            
            return
        }
        
        // Create container
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .black
        container.tag = 888
        
        // Create triangle
        let triagle = TriangleTop()
        triagle.backgroundColor = .clear
        triagle.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(triagle)
        
        // Create red line
        let line = UIView()
        line.backgroundColor = .red
        line.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(line)
        
        // Create message
        let label = UILabel()
        label.text = string
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = .black
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        // Set constraints for triangle
        triagle.heightAnchor.constraint(equalToConstant: 10).isActive = true
        triagle.widthAnchor.constraint(equalToConstant: 15).isActive = true
        triagle.topAnchor.constraint(equalTo: container.topAnchor, constant: -10).isActive = true
        triagle.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15).isActive = true
        
        // Set constraints for line
        line.heightAnchor.constraint(equalToConstant: 3).isActive = true
        line.topAnchor.constraint(equalTo: triagle.bottomAnchor, constant: 0).isActive = true
        line.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
        line.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true
        
        // Set constraints for label
        label.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 2).isActive = true
        label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2).isActive = true
        label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
        
        if !show {
            container.isHidden = true
        }
        // superview!.superview!.addSubview(container)
        UIApplication.shared.keyWindow!.addSubview(container)
        
        // Set constraints for container
        container.widthAnchor.constraint(lessThanOrEqualTo: superview!.widthAnchor, multiplier: 1).isActive = true
        container.trailingAnchor.constraint(equalTo: superview!.trailingAnchor, constant: -5).isActive = true
        container.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        // Hide other error messages
        let enumerator = errorViews.objectEnumerator()
        while let view = enumerator!.nextObject() as! UIView? {
            view.isHidden = true
        }
        
        // Add right button to textField
        let errorButton = UIButton(type: .custom)
        errorButton.tag = 999
        errorButton.setImage(UIImage(named: "errorIcon"), for: .normal)
        errorButton.frame = CGRect(x: 0, y: 0, width: frame.size.height, height: frame.size.height)
        errorButton.addTarget(self, action: #selector(errorAction), for: .touchUpInside)
        rightView = errorButton
        rightViewMode = .always
        
        // Save view with error message
        errorViews.setObject(container, forKey: self)
    }
    
    // Show error message
    @IBAction
    func errorAction(_ sender: Any) {
        let errorButton = sender as! UIButton
        let textField = errorButton.superview as! UITextField
        
        let errorView = errorViews.object(forKey: textField)
        if let errorView = errorView {
            errorView.isHidden.toggle()
        }
        
        let enumerator = errorViews.objectEnumerator()
        while let view = enumerator!.nextObject() as! UIView? {
            if view != errorView {
                view.isHidden = true
            }
        }
        
        // Don't hide keyboard after click by icon
        //UIViewController.isCatchTappedAround = false
    }
}

class TriangleTop: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.beginPath()
        context.move(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.minX / 2.0), y: rect.maxY))
        context.closePath()
        
        context.setFillColor(UIColor.red.cgColor)
        context.fillPath()
    }
}

