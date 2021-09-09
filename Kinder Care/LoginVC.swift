//
//  LoginVC.swift
//  Kinder Care
//
//  Created by CIPL0681 on 06/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class LoginVC: BaseViewController {
    
    @IBOutlet weak var textEmail: CTTextField!
    @IBOutlet weak var textPassword: CTTextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnLogin: CTButton!
    
    lazy var viewModel: LoginViewModel   =  {
        return LoginViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        //Admin
        //textEmail.text = "kcadmin@yopmail.com"
       // textPassword.text = "admin"
      
//    textEmail.text = "kcsuadmin@yopmail.com"
//    textPassword.text = "ffkssi"
      
      textEmail.text = "kca@yopmail.com"
     textPassword.text = "Test@1234"
           
        
        // Super Admin
       //  textEmail.text = "kcsadmin@yopmail.com"
      //   textPassword.text = "sadmin"
      
      
        // textEmail.text  = "vickyins@yopmail.com"
         //textPassword.text = "12345"
        //textEmail.text = "kcsuperadmin2@yopmail.com"
       // textEmail.text = "kcadmin@yopmail.com"
       // textPassword.text = "admin"
         
        // Teacher-
       //  textEmail.text = "nirmal@yopmail.com"
      // textPassword.text = "kcteacher"
        
        // textEmail.text = "ponztesting@gmail.com"
        //   textPassword.text = "123456"
        
        //Parent
        //    textEmail.text = "kcmparent@yopmail.com"
      //   textPassword.text = "kcmp"
        //     textEmail.text = "testcolan@gmail.com"
         //  textPassword.text = "12345"
        
        
    }
    
    
    //MARK:- login Button Action
    
    @IBAction func forgotBtnAction(_ sender: UIButton) {
    }
    
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        
        guard let email = textEmail.text, email.isValidEmail() else {
            displayError(withMessage: .invalidEmail)
            return
        }
        guard let password = textPassword.text, password.removeWhiteSpace().count > 3  else {
            displayError(withMessage: .invalidPassword)
            return
        }
        
        viewModel.loginUser(email: email, password: password, remember_me: 1)
        
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
extension LoginVC : loginDelegate{
    
    func loginSuccessfull(message: String) {
        
        displayServerSuccess(withMessage: message)
        
        let vc = UIStoryboard.onBoardingStoryboard().instantiateViewController(withIdentifier: "RootViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
    }
}
