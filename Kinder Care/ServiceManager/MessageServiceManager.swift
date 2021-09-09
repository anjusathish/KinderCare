//
//  MessageServiceManager.swift
//  Kinder Care
//
//  Created by CIPL0668 on 17/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

enum MessageServiceManager {
    
    
  
    case listMessages(_school_id : Int, msg_type : Int,list_by:Int,student_id:Int)
    case messageUserList(search_user: String,send_to: [Int],school_id: Int, classID:String,sectionID:String)
    case composeMessageWithAttachment(school_id:Int,save_type:Int, send_to : [Int],message:String,subject:String,user_id:[Int],attachments:[URL],msg_id:Int)
    case composeMessageWithoutAttachment(school_id:Int,save_type:Int, send_to : [Int],message:String,subject:String,user_id:[Int],msg_id:Int)
    case viewMessage(schoolID : Int,message_Id : Int,student_id:Int)
    case deleteMessage(msg_Type : Int, message_id : Int,senderType:String,student_id:Int)
    case getStudentList(search_user: String,schoolId : Int,classID: String,sectionID : String)
    case getTeacherList(schoolID:Int)
    

    var scheme: String {
        switch self {
   
            
        case .listMessages,.messageUserList,.composeMessageWithAttachment,.composeMessageWithoutAttachment,.viewMessage,.deleteMessage,.getStudentList,.getTeacherList: return API.scheme
        }
    }
    
    var host: String {
        switch self {
            
        case .listMessages,.messageUserList,.composeMessageWithAttachment,.composeMessageWithoutAttachment,.viewMessage,.deleteMessage,.getStudentList,.getTeacherList : return API.baseURL
        }
    }
    
    var path: String {
        switch self {
            
        case .listMessages: return API.path + "/message/list"
        case .messageUserList: return API.path + "/message/userlist"
        case .composeMessageWithAttachment,.composeMessageWithoutAttachment: return API.path + "/create/message"
        case .viewMessage: return API.path + "/message/view"
        case .deleteMessage: return API.path + "/message/delete"
        case .getStudentList: return API.path + "/superadmin/students/list"
        case .getTeacherList: return API.path + "/superadmin/teacher/list"
        }
    }
    
    var method: String {
        switch self {
        case  .listMessages,.messageUserList,.composeMessageWithAttachment,.composeMessageWithoutAttachment,.viewMessage,.deleteMessage: return "POST"
        case .getStudentList,.getTeacherList: return "GET"
        }
    }
    var port:Int{
        switch self {
        
            
        case  .listMessages,.messageUserList,.composeMessageWithAttachment,.composeMessageWithoutAttachment,.viewMessage,.deleteMessage,.getStudentList,.getTeacherList: return API.port
    
        }
    }
    var parameters: [URLQueryItem]? {
        switch self {
        case  .listMessages,.messageUserList,.composeMessageWithAttachment,.composeMessageWithoutAttachment,.viewMessage,.deleteMessage:
            return nil
            
            
        case .getStudentList(let searchString, let schoolID, let classID, let sectionID):
            return [URLQueryItem(name: "school_id", value: "\(schoolID)"),
            URLQueryItem(name: "class_id", value: "\(classID)"),
            URLQueryItem(name: "section_id", value: "\(sectionID)"),
            URLQueryItem(name: "search_by", value: searchString)]
            
            
        case .getTeacherList(let school_id):
            return [URLQueryItem(name: "school_id", value: "\(school_id)")]
            
            
        }
    }
    
    var body: Data? {
        switch self {
            
   
            
        case  .listMessages,.messageUserList,.composeMessageWithAttachment,.composeMessageWithoutAttachment,.viewMessage,.deleteMessage,.getStudentList,.getTeacherList: return nil
     
        }
    }
    var headerFields: [String : String]
    {
        switch self {
        case .listMessages,.messageUserList,.composeMessageWithAttachment,.composeMessageWithoutAttachment,.viewMessage,.deleteMessage,.getStudentList,.getTeacherList:
            return ["Accept" : "application/json", "API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
        }
    }
    
    var formDataParameters : [String : Any]? {
        
        switch self {
            
        case .listMessages(let _school_id, let msg_type, let list_by,let student_id):
            let parameters = ["school_id" : _school_id,
                              "msg_type" : msg_type,
                              "list_by" : list_by,
                              "student_id":student_id] as [String : Any]
            return parameters
            
        case .messageUserList(let search_user, let arraySendTo, let school_id,let classID,let sectionID):
            
            let parameters = ["search_user" : search_user,
                              "send_to" :     arraySendTo,
                              "school_id" :   school_id,
                              "class_id":      classID,
                              "section_id":   sectionID] as [String : Any]
            return parameters
            
        case .composeMessageWithAttachment(let school_id, let save_type, let send_to, let message, let subject, let user_id, let attachments,let msg_id):
            let parameters = ["school_id" : school_id,
                              "save_type" : save_type,
                              "send_to" : send_to,
                              "subject" : subject ,
                              "user_id" : user_id,
                              "message" : message,
                              "attachment" : attachments,
                              "msg_id":msg_id] as [String : Any]
            return parameters
            
        case .composeMessageWithoutAttachment(let school_id, let save_type, let send_to, let message, let subject, let user_id,let msg_id):
            let parameters = ["school_id" : school_id,
                              "save_type" : save_type,
                              "send_to" : send_to,
                              "subject" : subject ,
                              "user_id" : user_id,
                              "message" : message,
                              "msg_id":msg_id] as [String : Any]
            return parameters
            
        case .viewMessage(let schoolID, let message_Id,let student_id):
            let parameters = ["school_id" : schoolID,
                              "msg_id" : message_Id,"student_id": student_id] as [String : Any]
            return parameters
            
        case .deleteMessage(let msg_Type, let message_id,let senderType,let student_id):
            let parameters = ["msg_type" : msg_Type,
                              "msg_id" : message_id,"sender_type":senderType,"student_id":student_id] as [String : Any]
            return parameters
                      
            
        case .getStudentList,.getTeacherList: return nil
        }
    }
}
