//
//  DailyActivityViewModel.swift
//  Kinder Care
//
//  Created by CIPL0419 on 09/03/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol DailyActivityDelegate {
    
    func getListDailyActivity(at dailyActivityList: [DailyActivity])
    func viewDailyActivitySuccessfull(dailyActivityDetails : DailyActivityDetail)
    func editPhotEditActivityResponse(at editActivityResponse: EditPhotoActivityEmptyResponse)
    func addDailyActivityPhotoResponse(at editActivityResponse: AddDailyAtivityPhotoResponse)
    func failure(message : String)
    func classRoomCategoryList(at CategoryList: [CategoryListDatum])
    func classRoomMilestoneList(at CategoryList: [CategoryListDatum])
    func bathRoomList(at bathRoomList: [CategoryListDatum])
    func activityUpdateSuccess(activity:EditPhotoActivityEmptyResponse)
}

class DailyActivityViewModel{
    
    var delegate: DailyActivityDelegate?
    
    //MARK:- Get ListDaily Activity API
    
    func getDailyActivityList(class_id : String?,section_id:String?,pages:String?,fromDate:String?,toDate:String?){
        
        DailyActivitySerivceHelper.request(router: DailyActivityServiceManager.listDailyActivity(class_id, sectionId: section_id, fromDate: fromDate, toDate: toDate, page: pages)) {
            
            (result : Result<ListDailyActivityResponse,CustomError>) in
            
            DispatchQueue.main.async {
                switch result{
                case .success(let data):
                    if let _data = data.data?.data{
                        self.delegate?.getListDailyActivity(at: _data)
                    }
                    
                case .failure(let message):
                    
                    self.delegate?.failure(message: "\(message)")
                }
            }
        }
    }
    func viewDailyActivity(activity_id : Int){
        
        DailyActivitySerivceHelper.request(router: DailyActivityServiceManager.viewDailyActivity(activity_id: activity_id)) {
            
            (result : Result<ViewDailyActivityResponse,CustomError>) in
            
            DispatchQueue.main.async {
                switch result{
                case .success(let data):
                    
                    self.delegate?.viewDailyActivitySuccessfull(dailyActivityDetails: data.data
                    )
                case .failure(let message):
                    
                    self.delegate?.failure(message: "\(message)")
                }
            }
        }
    }
    
    //MARK:- Update PhotoDailyActivity
    func updatePhotoDailyActivity(state: String,type: String, classID: Int,sectionID: Int,description: String,studentID: [Int],attachmet:[URL],activity_id: Int){
        
        DailyActivitySerivceHelper.requestFormData(router: DailyActivityServiceManager.updateDailyPhotoActivity(state: state, type: type, classID: classID, sectionID: sectionID, Description: description, studentID: studentID, attachmet: attachmet, activity_id: activity_id)) {
            
            
            (result : Result<EditPhotoActivityEmptyResponse,CustomError>) in
            
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let data): self.delegate?.editPhotEditActivityResponse(at: data)
                    
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                    
                }
            }
        }
    }
    
    //MARK:- ClassRoomCategoryList
    
    func getClassRoomCategoryList(){
        
        DailyActivitySerivceHelper.request(router: DailyActivityServiceManager.clssRoomCategoryList) {
            
            (result : Result<ClassRoomCategoryListResponse,CustomError>) in
            
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let data):
                    
                    if let classRoomCategoryListData = data.data{
                        
                        self.delegate?.classRoomCategoryList(at: classRoomCategoryListData)
                        
                    }
                case .failure(let message):
                    
                    self.delegate?.failure(message: "\(message)")
                    
                }
            }
        }
    }
    
    
    //MARK:- ClassroomMilestoneList
    
    func getClassroomMilestoneList(){
        
        DailyActivitySerivceHelper.request(router: DailyActivityServiceManager.classroomMilestoneList) {
            
            (result : Result<ClassRoomCategoryListResponse,CustomError>) in
            
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let data):
                    
                    if let classRoomCategoryListData = data.data{
                        
                        self.delegate?.classRoomMilestoneList(at: classRoomCategoryListData)
                        
                    }
                case .failure(let message):
                    
                    self.delegate?.failure(message: "\(message)")
                    
                }
            }
        }
    }
    
    //MARK:- BathRoomList
    func getActivityBathRoomList(){
        
        DailyActivitySerivceHelper.request(router: DailyActivityServiceManager.bathRoomTypeList) {
            
            (result : Result<ClassRoomCategoryListResponse,CustomError>) in
            
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let data):
                    
                    if let bathRoomListData = data.data{
                        
                        self.delegate?.bathRoomList(at: bathRoomListData)
                        
                    }
                case .failure(let message):
                    
                    self.delegate?.failure(message: "\(message)")
                    
                }
            }
        }
    }
    
    func addDailyActivity(type: String, classID: Int,sectionID: Int,description: String,studentID: [Int],attachmet:[URL],date:String){
        
        DailyActivitySerivceHelper.requestFormData(router: DailyActivityServiceManager.addDailyActivityPhotoVideo(type: type, classID: classID, sectionID: sectionID, Description: description, studentID: studentID, attachmet: attachmet, date: date)) {
            (result : Result<AddDailyAtivityPhotoResponse,CustomError>) in
            DispatchQueue.main.async {
                
                switch result{
                case .success(let data):
                    self.delegate?.addDailyActivityPhotoResponse(at: data)
                case .failure(let message):
                    self.delegate?.failure(message: "\(message)")
                    
                }
            }
        }
    }
    
    //MARK:- AddNapActivity
    func addNapActivity(at request: AddNapActivityRequest){
        
        DailyActivitySerivceHelper.requestFormData(router: DailyActivityServiceManager.addNapActivity(request)) {
            
            (result : Result<AddDailyAtivityPhotoResponse,CustomError>) in
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let data):
                    self.delegate?.addDailyActivityPhotoResponse(at: data)
                    
                case .failure(let message):
                    self.delegate?.failure(message: "\(message)")
                    
                }
            }
        }
    }
    
    //MARK:- AddMediniceActivity
    func addMediniceActivity(at request: AddMedicineActivityRequest){
        
        DailyActivitySerivceHelper.requestFormData(router: DailyActivityServiceManager.addMedicineActivity(request)) {
            
            (result : Result<AddDailyAtivityPhotoResponse,CustomError>) in
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let data):
                    self.delegate?.addDailyActivityPhotoResponse(at: data)
                    
                case .failure(let message):
                    self.delegate?.failure(message: "\(message)")
                    
                }
            }
        }
    }
    
    //MARK:- Add ClassRoomActivity API
    func addClassRoomActivity(at request: AddClassRoomActivityRequest){
        
        DailyActivitySerivceHelper.requestFormData(router: DailyActivityServiceManager.addClassRoomActivity(request)) {
            
            (result : Result<AddDailyAtivityPhotoResponse,CustomError>) in
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let data):
                    self.delegate?.addDailyActivityPhotoResponse(at: data)
                    
                case .failure(let message):
                    self.delegate?.failure(message: "\(message)")
                    
                }
            }
        }
    }
    
    
    //MARK:- AddBathRoomActiviy API
    func addBathRoomActiviy(at request: AddBathRoomActivityRequest){
        
        DailyActivitySerivceHelper.requestFormData(router: DailyActivityServiceManager.addBathRoomActivity(request)) {
            
            (result : Result<AddDailyAtivityPhotoResponse,CustomError>) in
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let data):
                    self.delegate?.addDailyActivityPhotoResponse(at: data)
                    
                case .failure(let message):
                    self.delegate?.failure(message: "\(message)")
                    
                }
            }
        }
    }
    
    //MARK:- AddMealActivity API
    func addMealActivity(at request: AddMealActivityRequest){
        
        DailyActivitySerivceHelper.requestFormData(router: DailyActivityServiceManager.addMealActivity(request)) {
            
            (result : Result<AddDailyAtivityPhotoResponse,CustomError>) in
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let data):
                    self.delegate?.addDailyActivityPhotoResponse(at: data)
                    
                case .failure(let message):
                    self.delegate?.failure(message: "\(message)")
                    
                }
            }
        }
    }
    
    //MARK:- AddINcidentActivityAPI
    
    func addIncidentActivity(at request: AddIncidentActivityRequest){
        
        DailyActivitySerivceHelper.requestFormData(router: DailyActivityServiceManager.addIncidentActivity(request)) {
            
            (result : Result<AddDailyAtivityPhotoResponse,CustomError>) in
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let data):
                    self.delegate?.addDailyActivityPhotoResponse(at: data)
                    
                case .failure(let message):
                    self.delegate?.failure(message: "\(message)")
                    
                }
            }
        }
    }
    
    //MARK:- UpdateNApActivity
    
    func updateNapActivity(at request: UpdateDailyActivityRequest, at activityID: Int){
        
        DailyActivitySerivceHelper.requestFormData(router: DailyActivityServiceManager.updateDailyActivityNap(request, activityID)) {
            
            (result : Result<AddDailyAtivityPhotoResponse,CustomError>) in
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let data):
                    self.delegate?.addDailyActivityPhotoResponse(at: data)
                    
                case .failure(let message):
                    self.delegate?.failure(message: "\(message)")
                    
                }
            }
        }
    }
    
    func activityUpdate(id: String,state:String) {
        
        DailyActivitySerivceHelper.requestFormData(router: DailyActivityServiceManager.activityUpdate(_id: id, state: state)) {
            
            (result : Result<EditPhotoActivityEmptyResponse,CustomError>) in
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let data):
                    self.delegate?.activityUpdateSuccess(activity: data)
                    
                case .failure(let message):
                    self.delegate?.failure(message: "\(message)")
                    
                }
            }
        }
        
    }
    
    
}
