//
//  ChildNameViewModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 4/7/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol childNameListDelegate {
    func childNameList(schoolList : [ChildName])
    func dashboardActivity(dashboard:[DashboardActivity])
    func failure(message : String)
    
    }

class childNameViewModel {
    
var delegate:childNameListDelegate!
    
func childNameList(){
    
    OnBoardingServiceHelper.request(router: OnBoardingServiceManager.childName, completion: {
        (result : Result<ChildNameList, CustomError>) in
        DispatchQueue.main.async {
            
            switch result {
            case .success(let data):
                if let _data = data.data {
                    self.delegate.childNameList(schoolList: _data)
                    UserManager.shared.childNameList = data.data
                 
                }
            case .failure(let message): self.delegate?.failure(message: "\(message)")
            }
        }
    })
}
    func dashboardActivity(studentID:String,fromDate:String,toDate:String,type:String){
        
        OnBoardingServiceHelper.request(router: OnBoardingServiceManager.activityDashboard(studentId: studentID, fromDate: fromDate, toDate: toDate, type: type), completion: {
            (result : Result<ParentDashboardActivity, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    if let _data = data.data {
                        self.delegate.dashboardActivity(dashboard: _data)
                     
                    }
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }

    
}
