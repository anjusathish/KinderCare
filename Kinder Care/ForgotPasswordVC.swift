//
//  ForgotPasswordVC.swift
//  Kinder Care
//
//  Created by CIPL0681 on 07/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseViewController {
    
    @IBOutlet weak var textEmail: CTTextField!
    @IBOutlet weak var btnSubmit: CTButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    lazy var viewModel : ForgotPasswordViewModel = {
        return ForgotPasswordViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Submit Button Action
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        guard let email = textEmail.text, email.isValidEmail() else {
            displayError(withMessage: .invalidEmail)
            return
        }
        viewModel.forgotPassword(email: email)
        
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ForgotPasswordVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension ForgotPasswordVC:forgotPasswordDelegate {
    
    func forgotPasswordSuccessfull(message: String) {
        
        displayServerSuccess(withMessage: message)
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
        }
    
    
}
