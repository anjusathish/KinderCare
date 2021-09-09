//
//  ResetPasswordVC.swift
//  Kinder Care
//
//  Created by CIPL0681 on 12/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import SVPinView

class ResetPasswordVC: BaseViewController {
    
    @IBOutlet weak var viewOTP: SVPinView!
    @IBOutlet weak var textCreatePassword: CTTextField!
    @IBOutlet weak var textConfirmPassword: CTTextField!
    @IBOutlet weak var btnChangePassword: CTButton!
    var otpPin:String?
    
    lazy var viewModel : ResetPasswordViewModel = {
        return ResetPasswordViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurePinView()
        viewModel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func configurePinView() {
        
        viewOTP.pinLength = 4
        viewOTP.shouldSecureText = false
        viewOTP.textColor = UIColor(red:0.95, green:0.61, blue:0.07, alpha:1.0)
        viewOTP.borderLineColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
        viewOTP.activeBorderLineColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
        viewOTP.becomeFirstResponderAtIndex = 0
        viewOTP.activeBorderLineThickness = 1
        viewOTP.fieldBackgroundColor = UIColor.clear
        viewOTP.activeFieldBackgroundColor = UIColor.clear
        viewOTP.fieldCornerRadius = 0
        viewOTP.activeFieldCornerRadius = 0
        viewOTP.style = .underline
        
        viewOTP.font = UIFont.systemFont(ofSize: 15)
        viewOTP.keyboardType = .default
        viewOTP.pinInputAccessoryView = { () -> UIView in
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
            
            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            return doneToolbar
        }()
        
        viewOTP.didFinishCallback = didFinishEnteringPin(pin:)
        viewOTP.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
        }
    }
    
    func didFinishEnteringPin(pin:String) {
        print("The entered pin is \(pin)")
        otpPin = pin
        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    //MARK:-  Button Action
    @IBAction func changepasswordAction(_ sender: UIButton) {
        guard let  otp = otpPin ,!otp.isEmpty else {
                 displayError(withMessage: .invalidOTP)
                return
            }
        guard let  password = self.textCreatePassword.text,!password.isEmpty else {
             displayError(withMessage: .invalidPassword)
            return
        }
        guard let  confirmPassword = self.textConfirmPassword.text, confirmPassword.removeWhiteSpace() == password else {
             displayError(withMessage: .invalidPasswordMismatch)
            return
        }
        viewModel.resetPassword(password: password, confirm_password: confirmPassword, otp: otp)
        }
    
    //MARK:- TextField Delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }
}

extension ResetPasswordVC:resetPasswordDelegate {
    func resetPasswordSuccessfull(message: String) {
        displayServerSuccess(withMessage: message)
        let vc = UIStoryboard.onBoardingStoryboard().instantiateViewController(withIdentifier:"LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
        
    }
}
