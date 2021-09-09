//
//  ForgotViewModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 2/5/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol forgotPasswordDelegate {
    func forgotPasswordSuccessfull(message : String)
    func failure(message : String)
}

class ForgotPasswordViewModel {
    
    var delegate : forgotPasswordDelegate?
    
    func forgotPassword(email : String) {
        
        OnBoardingServiceHelper.requestFormData(router: OnBoardingServiceManager.forgotPassword(_email: email), completion: { (result : Result<ForgotResponce, CustomError>) in
            
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let user):
                    self.delegate?.forgotPasswordSuccessfull(message: user.message)
                    
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    
}
