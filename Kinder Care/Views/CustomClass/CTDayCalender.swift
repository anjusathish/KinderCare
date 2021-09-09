//
//  CTDayCalender.swift
//  Kinder Care
//
//  Created by Athiban Ragunathan on 07/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CTDayCalender: UIControl {
    
    @IBInspectable var cornerRadius : CGFloat = 0.0 {
        didSet {
            clipsToBounds = true
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var leftArrowImage : UIImage?{
        didSet {
            renderButtons()
        }
    }
    
    @IBInspectable var rightArrowImage : UIImage?{
        didSet {
            renderButtons()
        }
    }
    
    @IBInspectable var calenderImage : UIImage?{
        didSet {
            renderButtons()
        }
    }
    
    var date : Date = Date(){
        didSet {
            setDate()
        }
    }
    
    var monthStartDate : Date {
        get {
            return getStartOfMonth()
        }
    }
    
    var monthEndDate : Date {
          get {
            return getEndOfMonth()
          }
      }
    
    var minmumDate : Date?{
        didSet {
            setLeftButtonSate()
        }
    }
    
    var maximumDate : Date?{
        didSet {
            setRightButtonSate()
        }
    }
    
    var calenderType : Calendar.Component = .day
    
    private var leftArrowButton = UIButton(type: .custom)
    private var rightArrowButton = UIButton(type: .custom)
    private var currentDateButton = UIButton(type: .custom)
    
    override func awakeFromNib() {
        
        leftArrowButton.addTarget(self, action: #selector(leftButtonAction(sender:)), for: .touchUpInside)
        rightArrowButton.addTarget(self, action: #selector(rightButtonAction(sender:)), for: .touchUpInside)
        
        renderButtons()
    }
    
    private func renderButtons() {
        
        for item in self.subviews {
            item.removeFromSuperview()
        }
        
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .equalSpacing
        
        currentDateButton.isUserInteractionEnabled = false
        
        setLeftImage()
        setRightImage()
        setCalednerImage()
        setDate()
        
        stackview.addArrangedSubview(leftArrowButton)
        stackview.addArrangedSubview(currentDateButton)
        stackview.addArrangedSubview(rightArrowButton)
        
        self.addSubview(stackview)
        
        stackview.translatesAutoresizingMaskIntoConstraints = false
        leftArrowButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        rightArrowButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        stackview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        stackview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    }
    
    private func setLeftImage() {
        
        if let image = leftArrowImage {
            leftArrowButton.setImage(image, for: .normal)
        }
    }
    
    private func setRightImage() {
        
        if let image = rightArrowImage {
            rightArrowButton.setImage(image, for: .normal)
        }
    }
    
    private func setCalednerImage() {
        
        if let image = calenderImage {
            currentDateButton.setImage(image, for: .normal)
        }
    }
    
    private func setDate() {
        
        let dateFormatter = DateFormatter()
        
        switch calenderType {
        case .day: dateFormatter.dateFormat = "dd MMMM yyy"
        case .month: dateFormatter.dateFormat = "MMMM yyy"
        default: dateFormatter.dateFormat = "dd MMMM yyy"
        }
        
        currentDateButton.setTitle("   \(dateFormatter.string(from: date))", for: .normal)
    }
    
    private func getStartOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self.date)))!
    }
    
    private func getEndOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.getStartOfMonth())!
    }
    
    private func setLeftButtonSate() {
        
        if let _minDate = minmumDate, date <= _minDate {
            leftArrowButton.isEnabled = false
        }
        else {
            leftArrowButton.isEnabled = true
        }
    }
    
    private func setRightButtonSate() {
        
        if let _maxDate = maximumDate, date >= _maxDate {
            rightArrowButton.isEnabled = false
        }
        else {
            rightArrowButton.isEnabled = true
        }
    }
    
    //MARK:- Actions
    
    @objc private func leftButtonAction(sender : UIButton) {
        
        if let _date = Calendar.current.date(byAdding: calenderType, value: -1, to: date) {
            date = _date
            setDate()
            setLeftButtonSate()
            setRightButtonSate()
        }
        else {
            return
        }
        
        sendActions(for: .valueChanged)
    }
    
    @objc private func rightButtonAction(sender : UIButton) {
        
        if let _date = Calendar.current.date(byAdding: calenderType, value: 1, to: date) {
            date = _date
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
            setDate()
            setRightButtonSate()
            setLeftButtonSate()
        }
        else {
            return
        }
        
        sendActions(for: .valueChanged)
    }
}
