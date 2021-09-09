//
//  NotificationViewModel.swift
//  Kinder Care
//
//  Created by CIPL0668 on 24/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import Foundation

protocol notificationDelegate {
    func getNotificationListSuccessfull(notificationList : NotificationModel)
    func clearNotification()
    func failure(message : String)
}

class NotificationViewModel {
    var delegate : notificationDelegate?
    
    func getNotificationLists(school_id : Int,student_id:Int){
        
        NotificationServiceHelper.requestFormData(router: NotificationServiceManager.getNotification(school_id, student_id: student_id), completion: {
                  (result : Result<NotificationModel, CustomError>) in
                  DispatchQueue.main.async {
                      
                      switch result {
                      case .success(let data):
                        
                        self.delegate?.getNotificationListSuccessfull(notificationList: data)
                          
                      case .failure(let message): self.delegate?.failure(message: "\(message)")
                      }
                  }
              })
    }
    func clearAllNotifications(school_id : Int,student_id:Int){
          
        NotificationServiceHelper.requestFormData(router: NotificationServiceManager.clearAll(school_id: school_id, student_id: student_id), completion: {
                  (result : Result<EmptyResponse, CustomError>) in
                  DispatchQueue.main.async {
                      
                      switch result {
                      case .success:
                              self.delegate?.clearNotification()
                    
                      case .failure(let message): self.delegate?.failure(message: "\(message)")
                      }
                  }
              })
      }
}
