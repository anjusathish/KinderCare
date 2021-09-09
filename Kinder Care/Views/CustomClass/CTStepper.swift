//
//  CTStepper.swift
//  STSQueue
//
//  Created by COLAN_137 on 16/10/19.
//  Copyright © 2019 ServiceTrackingSystems Inc. All rights reserved.
//

import UIKit

protocol StepperValueChanged {
    func valueToSend(_ sender: Int,speed:  String)
}

class CTStepper: UIControl {
    
    enum StepperState {
        case Stable, ShouldIncrease, ShouldDecrease
    }
    
    /// Current value of the stepper. Defaults to 0.
    @IBInspectable public var value: Double = 0 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))
            
            label.text = formattedValue
            
            if oldValue != value {
                sendActions(for: .valueChanged)
            }
        }
    }
    
     @IBInspectable var minimumValue: Double = 0 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))
        }
    }
    
    @IBInspectable var maximumValue: Double = 100 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))
        }
    }
    
     @IBInspectable public var stepValue: Double = 1 {
        didSet {
            setupNumberFormatter()
        }
    }
    @IBInspectable public var showIntegerIfDoubleIsInteger: Bool = true {
        didSet {
            setupNumberFormatter()
        }
    }
    
    @IBInspectable public var autorepeat: Bool = true
    
    /// Text color of the middle label. Defaults to white.
    @IBInspectable public var labelTextColor: UIColor = UIColor.white {
        didSet {
            label.textColor = labelTextColor
        }
    }
    
    /// Text color of the middle label. Defaults to lighter blue.
    @IBInspectable public var labelBackgroundColor: UIColor = UIColor(red:241/255, green:241/255, blue:241/255, alpha:1) {
        didSet {//rgb(32,187,171)

            label.backgroundColor = labelBackgroundColor
        }
    }
    
    /// Font of the middle label. Defaults to AvenirNext-Bold, 25.0 points in size.
    public var labelFont = UIFont(name: "AvenirNext-Bold", size: 20.0)! {
        didSet {
            label.font = labelFont
        }
    }
    /// Corner radius of the middle label. Defaults to 0.
    @IBInspectable public var labelCornerRadius: CGFloat = 25 {
        didSet {
            label.layer.cornerRadius = labelCornerRadius
            
        }
    }
    
    /// Corner radius of the stepper's layer. Defaults to 4.0.
    @IBInspectable public var cornerRadius: CGFloat = 25 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    
    /// Border width of the stepper and middle label's layer. Defaults to 0.0.
    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
            label.layer.borderWidth = borderWidth
        }
    }
    
    /// Color of the border of the stepper and middle label's layer. Defaults to clear color.
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            label.layer.borderColor = borderColor.cgColor
        }
    }
    
    /// Percentage of the middle label's width. Must be between 0 and 1. Defaults to 0.5. Be sure that it is wide enough to show the value.
    @IBInspectable public var labelWidthWeight: CGFloat = 0.5 {
        didSet {
            labelWidthWeight = min(1, max(0, labelWidthWeight))
            setNeedsLayout()
        }
    }
    
    // Text on the left button. Be sure that it fits in the button. Defaults to "−".
    @IBInspectable public var leftButtonText: String = "−" {
        didSet {
            leftButton.setTitle(leftButtonText, for: .normal)
        }
    }
    
    /// Text on the right button. Be sure that it fits in the button. Defaults to "+".
    @IBInspectable public var rightButtonText: String = "+" {
        didSet {
            rightButton.setTitle(rightButtonText, for: .normal)
        }
    }
    
    /// Text color of the buttons. Defaults to white.
    @IBInspectable public var buttonsTextColor: UIColor = UIColor.white {
        didSet {
            for button in [leftButton, rightButton] {
                button.setTitleColor(buttonsTextColor, for: .normal)
            }
        }
    }
    
    /// Background color of the buttons. Defaults to dark blue.
    @IBInspectable public var buttonsBackgroundColor: UIColor = UIColor(red:32/255, green:187/255, blue:171/255, alpha:1) {
        didSet {
            for button in [leftButton, rightButton] {
                button.backgroundColor = buttonsBackgroundColor
            }
            backgroundColor = buttonsBackgroundColor
        }
    }
    
    /// Font of the buttons. Defaults to AvenirNext-Bold, 20.0 points in size.
     public var buttonsFont = UIFont(name: "AvenirNext-Bold", size: 20.0)! {
        didSet {
            for button in [leftButton, rightButton] {
                button.titleLabel?.font = buttonsFont
            }
        }
    }
    
    /// Formatter for displaying the current value
    let formatter = NumberFormatter()
    var delegate: StepperValueChanged?

    public var items : [String] = [] {
        didSet {
            label.text = formattedValue
        }
    }
    
    var formattedValue: String? {
        let isInteger = Decimal(value).exponent >= 0
        
        // If we have items, we will display them as steps
        if isInteger && stepValue == 1.0 && items.count > 0 {
            return items[Int(value)]
        }
        else {
            return formatter.string(from: NSNumber(value: value))
        }
    }
    
    func setupNumberFormatter() {
        let decValue = Decimal(stepValue)
        let digits = decValue.significantFractionalDecimalDigits
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = showIntegerIfDoubleIsInteger ? 0 : digits
        formatter.maximumFractionDigits = digits
    }

    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.backgroundColor = self.labelBackgroundColor
        label.font = self.labelFont
        label.layer.cornerRadius = self.labelCornerRadius
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setTitle(self.leftButtonText, for: .normal)
        button.setTitleColor(self.buttonsTextColor, for: .normal)
        button.backgroundColor = self.buttonsBackgroundColor
        button.titleLabel?.font = self.buttonsFont

        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true

        
        button.addTarget(self, action: #selector(CTStepper.leftButtonTouchDown), for: .touchUpInside)
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle(self.rightButtonText, for: .normal)
        button.setTitleColor(self.buttonsTextColor, for: .normal)
        button.backgroundColor = self.buttonsBackgroundColor
        button.titleLabel?.font = self.buttonsFont
        button.addTarget(self, action: #selector(CTStepper.rightButtonTouchDown), for: .touchUpInside)
        return button
    }()
    
    
    var stepperState = StepperState.Stable {
        didSet {
            if stepperState != .Stable {
                updateValue()
               
            }
        }
    }
   
    public override func layoutSubviews() {
        let buttonWidth = bounds.size.width * ((1 - labelWidthWeight) / 2)
        let labelWidth = bounds.size.width * labelWidthWeight
        
        leftButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: bounds.size.height)
        label.frame = CGRect(x: buttonWidth, y: 0, width: labelWidth, height: bounds.size.height)
        rightButton.frame = CGRect(x: labelWidth + buttonWidth, y: 0, width: buttonWidth, height: bounds.size.height)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    fileprivate func setup() {
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(label)
        
        backgroundColor = buttonsBackgroundColor
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        setupNumberFormatter()
        
    }
    
    
    func updateValue() {
        if stepperState == .ShouldIncrease {
            value += stepValue
        } else if stepperState == .ShouldDecrease {
            value -= stepValue
        }
        delegate?.valueToSend(self.tag, speed: formattedValue!)
    }
    
    @objc func rightButtonTouchDown(button: UIButton) {
       // leftButton.isEnabled = false
       // label.isUserInteractionEnabled = false
        
        if value == maximumValue {
        } else {
            stepperState = .ShouldIncrease
        }
       // updateValue()
       
    }
    
    @objc func leftButtonTouchDown(button: UIButton) {
        //rightButton.isEnabled = false
        //label.isUserInteractionEnabled = false
    
        if value == minimumValue {
        } else {
            stepperState = .ShouldDecrease
        }
        //updateValue()
    }

}

extension Decimal {
    var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
}
