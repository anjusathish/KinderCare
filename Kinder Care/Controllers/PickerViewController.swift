//
//  PickerViewController.swift
//  Auto Salaah
//
//  Created by CIPL0590 on 09/08/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {
    
    
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var timeToolbar: UIToolbar!
    
    let window = UIApplication.shared.keyWindow
    
    var dismissBlock: ((Date) -> Void)?
    
    var mode : UIDatePicker.Mode?
    var currentDate : Date?
    var calender : Calendar?
    var minimumDate:Date?
    
    override func viewDidLoad()
        
    {
        super.viewDidLoad()
        
        if let _mode = mode
        {
            timePicker.datePickerMode = _mode
        }
        
        if let _date = currentDate
        {
            timePicker.setDate(_date, animated: false)
        }
        
        if let _calender = calender {
            timePicker.calendar = _calender
        }
        
        if let _minimumDate = minimumDate{
            timePicker.minimumDate = _minimumDate
        }
        
        self.contentSizeInPopup = CGSize(width: window!.frame.width, height: 300)
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            if let dismiss = self.dismissBlock {
                dismiss(self.timePicker.date)
            }
        })
    }
}
