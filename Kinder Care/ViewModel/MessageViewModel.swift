//
//  MessageViewModel.swift
//  Kinder Care
//
//  Created by CIPL0668 on 17/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol messageDelegate {
  func listMessagesSuccessfull(messageData : [MessageModel]?,messageType: Int)
    func composeMessageSuccessfull(message:String)
    func deleteMessageSuccessfull(message:String)
    func viewMessageSuccessfull(messageDetail : [MessageDetails])
    func failure(message : String)
}

class MessageViewModel  {
    
    var delegate : messageDelegate?
    
    func listMessages(schoolId : Int, listBy:Int,msg_type : Int,student_id:Int) {
        
        MessageServiceHelper.requestFormData(router: MessageServiceManager.listMessages(_school_id: schoolId, msg_type: msg_type, list_by: listBy, student_id: student_id), completion: {
            (result : Result<ListMessageModel, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                  self.delegate?.listMessagesSuccessfull(messageData: data.data, messageType: msg_type)
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    func viewMessage(schoolId : Int, message_Id:Int,student_id:Int) {
        
        MessageServiceHelper.requestFormData(router: MessageServiceManager.viewMessage(schoolID: schoolId, message_Id: message_Id, student_id: student_id), completion: {
            (result : Result<ViewMessageModel, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.delegate?.viewMessageSuccessfull(messageDetail: data.data)
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    func deleteMessage(msg_type : Int, message_Id:Int,senderType:String,student_id:Int) {
        
        MessageServiceHelper.requestFormData(router: MessageServiceManager.deleteMessage(msg_Type: msg_type, message_id: message_Id, senderType: senderType, student_id: student_id), completion: {
            (result : Result<EmptyResponse, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.delegate?.deleteMessageSuccessfull(message: "Message Deleted Successfully")
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    func composeMessageWithAttachments(school_id:Int,save_type:Int, send_to: [Int],message:String,subject:String,user_id:[Int],attachments:[URL], msg_id:Int){
        
        MessageServiceHelper.requestFormData(router: MessageServiceManager.composeMessageWithAttachment(school_id: school_id, save_type: save_type, send_to: send_to, message: message, subject: subject, user_id: user_id, attachments: attachments, msg_id: msg_id), completion: {
            
            (result : Result<EmptyResponse, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                case .success:
                    
                    self.delegate?.composeMessageSuccessfull(message: "Mail has been sent successfully")
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    
    func composeMessageWithoutAttachments(school_id:Int,save_type:Int, send_to : [Int],message:String,subject:String,user_id:[Int], msg_id:Int){
        
        MessageServiceHelper.requestFormData(router: MessageServiceManager.composeMessageWithoutAttachment(school_id: school_id, save_type: save_type, send_to: send_to, message: message, subject: subject, user_id: user_id, msg_id: msg_id), completion: {
            
            (result : Result<EmptyResponse, CustomError>) in
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success:
                    if save_type == 1 {
                        self.delegate?.composeMessageSuccessfull(message: "The Message has been saved to draft successfully")
                    }
                    else{
                        self.delegate?.composeMessageSuccessfull(message: "Mail has been sent successfully")
                    }
                    
                case .failure(let message): self.delegate?.failure(message: "\(message)")
                }
            }
        })
    }
    
}
