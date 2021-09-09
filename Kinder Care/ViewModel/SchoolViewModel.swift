//
//  SchoolViewModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 2/7/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol schoolListDelegate {
    func schoolList(schoolList : [SchoolListData])
    func dashboardCount(dashboard:DashboardCount?)
    func failure(message : String)
    func getAdminDashboardData(at adminDashboardData: [AdminDashboardData])
    func getTeacherDashboardData(at teacherDashboardData: [TeacherDashboardData])
    func permission(data:PermissionsData)
    func childNameList(schoolList : [ChildName])
    
}

class schoolListViewModel {
    var delegate:schoolListDelegate!
    
    func permissionData(){
        
        OnBoardingServiceHelper.request(router: OnBoardingServiceManager.permission, completion: {
            (result : Result<PermissionsLogin, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    if let _data = data.data {
                        UserManager.shared.currentUser?.permissions = _data
                        self.delegate.permission(data: _data)
                    }
                    
                    //  UserManager.shared.currentUser?.permissions = data.data
                    //                    if let _data = data.data {
                    //                        self.delegate.schoolList(schoolList: _data)
                    //                        UserManager.shared.schoolList = data.data
                //                    }
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    
    func schoolList(){
        
        OnBoardingServiceHelper.request(router: OnBoardingServiceManager.schoolList, completion: {
            (result : Result<SchoolList, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    if let _data = data.data {
                        self.delegate.schoolList(schoolList: _data)
                        UserManager.shared.schoolList = data.data
                    }
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    
    func dashboardCount(institute_id:String,school_id : Int){
        OnBoardingServiceHelper.requestFormData(router: OnBoardingServiceManager.dashboardCount(instituteID: institute_id, school_id: school_id), completion:
            {
                (result : Result<DashboardCountResponse, CustomError>) in
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let data):
                        print(data)
                        if let _data = data.data {
                            print(_data)
                            self.delegate.dashboardCount(dashboard: _data.first)
                            
                        }
                    case .failure(let message): self.delegate?.failure(message: "\(message)")
                    }
                }
        })
        
    }
    
    //MARK:- AdminDashboard API
    func adminDashboard(){
        
        OnBoardingServiceHelper.request(router: OnBoardingServiceManager.adminDashboard, completion: {
            (result : Result<AdminDashboardResponse, CustomError>) in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data):
                    
                    if let _data = data.data {
                        
                        self.delegate.getAdminDashboardData(at: _data)
                    }
                    
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                    
                }
            }
        })
    }
    
    //MARK:- TeacherDashboardAPI
    func getTeacherDashboard(){
        
        OnBoardingServiceHelper.request(router: OnBoardingServiceManager.adminDashboard, completion: {
            (result : Result<TeacherDashboardResponse, CustomError>) in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data):
                    
                    if let _data = data.data {
                        
                        self.delegate.getTeacherDashboardData(at: _data)
                    }
                    
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                    
                }
            }
        })
    }
    
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
}
