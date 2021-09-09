//
//  WeeklyMenuViewModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 3/11/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol WeeklyMenuDelegate {
    
    func courseTypeListSuccess(courseType:[CourseType])
    func menuItemsListSuccess(items:[MenuItem], forCourse id : String)
    func failure(message : String)
}

class WeeklyMenuViewModel
{
    var delegate:WeeklyMenuDelegate!
    
    func courseTypeList(){
        
        WeeklyMenuServiceHelper.request(router:  WeeklyMenuServiceManager.courseType, completion: {
            (result : Result<CourseTypeResponce, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    if let _data = data.data {
                        print(_data)
                        self.delegate.courseTypeListSuccess(courseType: _data)
                        
                    }
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    
    func getMenuItems(forCourse courseId : String, forSchool schoolId : String) {
        
        WeeklyMenuServiceHelper.requestFormData(router: .menuItems(courseId: courseId, schoolId: schoolId), completion: {
            (result : Result<MenuItemsResponse, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    self.delegate.menuItemsListSuccess(items: data.data, forCourse: courseId)
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
}
