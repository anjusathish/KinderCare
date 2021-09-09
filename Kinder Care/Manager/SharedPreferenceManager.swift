//
//  SharedPreferenceManager.swift
//  Kinder Care
//
//  Created by CIPL0668 on 11/03/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit

protocol  classNameDelegate {
    func failure(message: String)
}
class SharedPreferenceManager: NSObject {
    
    var classNameListArray = [ClassModel]()
    var sectionArray = [Section]()
    
    var delegate:classNameDelegate?
    
    class var shared: SharedPreferenceManager {
        struct Singleton {
            static let instance = SharedPreferenceManager()
        }
        return Singleton.instance
    }
    
    private override init () {
        super.init()
    }
    
    
    func getClassNameList( schoolId:String){
    
    AttendanceServiceHelper.request(router: AttendanceServiceManager.classNameList(_schoolId: schoolId), completion: {
        (result : Result<ClassResponse, CustomError>) in
        DispatchQueue.main.async {
            
            switch result {
            case .success(let data):
                if let _data = data.data {
                    self.classNameListArray = _data
                    if let classId = _data.first?.id {
                        self.getSectionNameList(class_id: classId, schoolId: schoolId )
                    }
                }
            case .failure(let message):
                self.delegate?.failure(message: "\(message)")
            }
        }
    })
    }
    
    func getSectionNameList(class_id:Int,schoolId:String){
           
        AttendanceServiceHelper.requestFormData(router: AttendanceServiceManager.sectionNameListSharedPreferrence(class_id: class_id, schoolId: schoolId), completion: {
               (result : Result<SectionResponse, CustomError>) in
               DispatchQueue.main.async {
                   
                   switch result {
                   case .success(let data):
                       if let _data = data.data {
                        self.sectionArray = _data
                        print(_data)
                       }
                   case .failure(let message): self.delegate?.failure(message: "\(message)")
                   }
               }
           })
       }
}
