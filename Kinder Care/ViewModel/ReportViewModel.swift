//
//  ReportViewModel.swift
//  Kinder Care
//
//  Created by CIPL0590 on 2/20/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol ReportDelegate {
    func attendanceReportSuccessfull(attendance : ReportAttendanceResponse)
    func salaryFilterSuccessfull(salaryFilter:ReportAttendanceResponse)
    func classNameSuccessful(classList:[ClassModel])
    func sectionSuccessful(list : [Section])
    func studentReportSuccessful(data:ExportResponse)
    func salaryExportSuccessful(data:ExportResponse)
    func staffExportSuccessful(data:ExportResponse)
    func failure(message : String)
}

class ReportViewModel
{
    var delegate:ReportDelegate!
    
    func reportAttendance(usertype_id:Int,fromdate:String,todate:String,school_id:Int,className:Int,section:Int){
        
        ReportServiceHelper.requestFormData(router:  ReportServiceManager.workingDaysCount(usertype_id: usertype_id, fromdate: fromdate, todate: todate, school_id: school_id, class_id: className,section:section), completion: {
            (result : Result<ReportAttendanceResponse, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    
                    
                    self.delegate.attendanceReportSuccessfull(attendance: data)
                    
                    
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    
    func salaryFilter(usertype_id:Int,fromdate:String,todate:String,school_id:Int){
        
        ReportServiceHelper.requestFormData(router:  ReportServiceManager.salaryFilter(usertype_id: usertype_id, fromdate: fromdate, todate: todate, school_id: school_id), completion: {
            (result : Result<ReportAttendanceResponse, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    
                    
                    self.delegate.salaryFilterSuccessfull(salaryFilter: data)
                    
                case .failure(let message):
                    self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    
    func classNameList(schoolId:String){
        
        AttendanceServiceHelper.request(router: AttendanceServiceManager.classNameList(_schoolId: schoolId), completion: {
            (result : Result<ClassResponse, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    if let _data = data.data {
                        self.delegate.classNameSuccessful(classList: _data)
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
                        print(_data)
                        self.delegate.sectionSuccessful(list: _data)
                    }
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    
    func studentExport(usertype_id:Int,fromdate:String,todate:String,school_id:Int,classId:Int,section:Int){
        
        ReportServiceHelper.requestFormData(router:  ReportServiceManager.studentExport(usertype_id: usertype_id, fromdate: fromdate, todate: todate, school_id: school_id, class_id: classId, section: section), completion: {
            (result : Result<ExportResponse, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    
                    
                    self.delegate.studentReportSuccessful(data: data)
                    
                    
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
        
        
    }
    func salaryExport(user_type:Int,fromdate:String,todate:String,school_id:Int){
        
        ReportServiceHelper.requestFormData(router:  ReportServiceManager.salaryExport(usertype: user_type, fromdate: fromdate, todate: todate, school_id: school_id), completion: {
            (result : Result<ExportResponse, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    
                    
                    self.delegate.salaryExportSuccessful(data: data)
                    
                    
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
        
        
        
    }
    func staffExport(usertypeId:Int,fromdate:String,todate:String,school_id:Int){
        
        ReportServiceHelper.requestFormData(router:  ReportServiceManager.staffExport(usertype_id: usertypeId, fromdate: fromdate, todate: todate, school_id: school_id), completion: {
               (result : Result<ExportResponse, CustomError>) in
               DispatchQueue.main.async {
                   
                   switch result {
                   case .success(let data):
                       
                       
                    self.delegate.staffExportSuccessful(data: data)
                       
                       
                   case .failure(let message): self.delegate?.failure(message: "\(message)")
                   }
               }
           })
        
    }
    
    
    
    
}
