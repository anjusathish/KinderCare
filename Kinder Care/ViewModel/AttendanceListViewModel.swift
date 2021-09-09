//
//  AttendanceListViewModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 2/7/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

enum AttendanceType : Int {
    case absent = 4
    case present = 3
    case signin = 1
    case signout = 2
}

protocol AttendanceListDelegate {
    func getAttendanceListSuccess(attendanceList : [Attendance],forUserType: Int)
    func getClassNameListSuccess(classList:[ClassModel])
    func getSectionNameListSuccess(sectionList:[Section])
    func updateAttendanceListSuccess()
    func gettingAttendanceListFailure(message : String)
    func failure(message : String)
}

class AttendanceListViewModel
{
    var delegate:AttendanceListDelegate!
    
    func addAttendanceList(school_id:Int,log_type: Int, selectedUsers: [Int],date: String,time: String,user_type: Int, classId: Int?, sectionId: Int?){
        
        AttendanceServiceHelper.requestFormData(router: AttendanceServiceManager.addAttendance(school_id: school_id, selectedUsers: selectedUsers, log_type: log_type, date: date,time:time, user_type: user_type, classId: classId, sectionId: sectionId), completion: {
            
            (result : Result<AttendanceResponse, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success:
                    self.delegate.updateAttendanceListSuccess()
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    
    func attendanceList(date:String,user_type:Int,school_id:Int){
        
        AttendanceServiceHelper.requestFormData(router: AttendanceServiceManager.attendanceList(date: date, user_type: user_type, school_id: school_id), completion: {
            (result : Result<AttendanceResponse, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    if let _data = data.data {
                        self.delegate.getAttendanceListSuccess(attendanceList: _data, forUserType: user_type)
                    }
                case .failure(let error):
                    self.delegate?.gettingAttendanceListFailure(message:"\(error)" )
                }
            }
        })
    }
    
    func classNameList( schoolId:String){
        
        AttendanceServiceHelper.request(router: AttendanceServiceManager.classNameList(_schoolId: schoolId), completion: {
            (result : Result<ClassResponse, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    if let _data = data.data {
                        self.delegate.getClassNameListSuccess(classList: _data)
                    }
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
        
    }
    
    func sectionList(school_id:Int,class_id:Int){
        
        AttendanceServiceHelper.requestFormData(router: AttendanceServiceManager.sectionNameList(school_id: school_id, class_id: class_id), completion: {
            (result : Result<SectionResponse, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    if let _data = data.data {
                        self.delegate.getSectionNameListSuccess(sectionList: _data)
                    }
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    
    func studentAttendanceList(school_id:Int,date:String,section_id:Int,class_id:Int) {
        
        AttendanceServiceHelper.requestFormData(router: AttendanceServiceManager.studentAttendanceList(school_id: school_id, date: date, section_id: section_id, class_id: class_id), completion: {
            
            (result : Result<AttendanceResponse, CustomError>) in
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let data):
                    
                    if let _data = data.data {
                        
                        self.delegate.getAttendanceListSuccess(attendanceList: _data, forUserType: 0)
                    }
                case .failure(let message): self.delegate?.gettingAttendanceListFailure(message: "\(message)")
                    
                }
            }
        })
    }
}
