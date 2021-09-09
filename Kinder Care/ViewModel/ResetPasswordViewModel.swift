//
//  ResetPasswordViewModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 2/5/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol resetPasswordDelegate {
    func resetPasswordSuccessfull(message : String)
    func failure(message : String)
}

class ResetPasswordViewModel {
    
    var delegate : resetPasswordDelegate?
    
    func resetPassword(password : String,confirm_password:String,otp:String) {
        
        OnBoardingServiceHelper.requestFormData(router: OnBoardingServiceManager.resetPassword(_password: password, _confirm_password: confirm_password, _otp: otp), completion: { (result : Result<ResetPasswordResponce, CustomError>) in
            
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let user):
                    self.delegate?.resetPasswordSuccessfull(message: user.message)
                    
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    
}
