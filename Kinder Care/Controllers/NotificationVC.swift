//
//  NotificationVC.swift
//  Kinder Care
//
//  Created by CIPL0681 on 25/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class NotificationVC: BaseViewController {
    
    @IBOutlet weak var notificationTable: UITableView!
    
    var notificationListArray = [NotificationsList]()
    var childNameArray = [ChildName]()
    var failureMessage: String?
    var childNameID:Int?
    
    lazy var viewModel : NotificationViewModel  =  {
        return NotificationViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleString = "NOTIFICATION"
        
        if let childName = UserManager.shared.childNameList {
            childNameArray = childName
            self.childNameID = childNameArray.map({$0.id}).first
        }
        
        notificationTable.tableFooterView = UIView()
        notificationTable.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
        viewModel.delegate = self
        notificationTable.emptyDataSetDelegate = self
        notificationTable.emptyDataSetSource = self
        
      if  let userType = UserManager.shared.currentUser?.userType {
        
        if let _type = UserType(rawValue:userType ) {
          
          switch  _type  {
          
          case .parent:
            
            if let _schoolID = UserManager.shared.currentUser?.school_id,let studentID = self.childNameID {
              viewModel.getNotificationLists(school_id: _schoolID, student_id: studentID)
            }
            
            
          case .teacher,.admin,.superadmin,.all:
            
            if let _schoolID = UserManager.shared.currentUser?.school_id {
              viewModel.getNotificationLists(school_id: _schoolID, student_id: 0)
            }
            
          case.student:
            
            if let _schoolID = UserManager.shared.currentUser?.school_id,let studentID = self.childNameID {
              viewModel.getNotificationLists(school_id: _schoolID, student_id: studentID)
            }
            
          }
          
        }
        
      }
        
        let clearAll = UIButton(frame: CGRect(x: self.view.frame.width - (16 + 70), y: 15 + safeAreaHeight, width: 70, height: 30))
        clearAll.setTitle("Clear all", for: .normal)
        clearAll.backgroundColor = UIColor.clear
        clearAll.addTarget(self, action: #selector(clearAllButtonHandler), for: .touchUpInside)
        self.view.addSubview(clearAll)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func clearAllButtonHandler(){
        
        if let _schoolID = UserManager.shared.currentUser?.school_id,let studentID = self.childNameID {
            viewModel.clearAllNotifications(school_id: _schoolID, student_id: studentID)
            
        }}
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}

extension NotificationVC :UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notificationListArray.count
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let type = notificationListArray[indexPath.row].type
        if  type == "message" {
            let vc = UIStoryboard.messageStoryboard().instantiateViewController(withIdentifier:"MessageListVC") as! MessageListVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if  type == "Leave request" {
            let vc = UIStoryboard.leaveStoryboard().instantiateViewController(withIdentifier:"LeaveApprovalVC") as! LeaveApprovalVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if  type == "pickup request" {
            let vc = UIStoryboard.FamilyInformationStoryboard().instantiateViewController(withIdentifier:"PickUpPersonApprovalViewController") as! PickUpPersonApprovalViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.activeCircle.onFillColor = UIColor(red:0.95, green:0.61, blue:0.07, alpha:1.0)
        cell.activeCircle.layer.borderColor = UIColor(red:0.95, green:0.61, blue:0.07, alpha:1.0).cgColor
        cell.selectionStyle = .none
        cell.labelName.text = notificationListArray[indexPath.row].name
        cell.labelRequest.text = notificationListArray[indexPath.row].datumDescription
        cell.labelTime.text = notificationListArray[indexPath.row].createdAt
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            alert()
        }
    }
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func delete(deleteStr: String) {
        
    }
    
    private func alert(){
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete the data ?", preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: {
            action in
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {
            action in
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
}


extension NotificationVC :notificationDelegate {
    
    func getNotificationListSuccessfull(notificationList: NotificationModel) {
        notificationListArray = notificationList.data
        failureMessage = notificationList.message
        notificationTable.reloadData()
    }
    
    func clearNotification() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func failure(message: String) {
        displayServerError(withMessage: message)
        failureMessage = message
    }
}

extension NotificationVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var message = "No data available !"
        
        if let _failureMessage = failureMessage {
            message = _failureMessage
        }
        
        return message.formatErrorMessage()
    }
}
