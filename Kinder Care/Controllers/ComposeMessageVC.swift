//
//  ComposeMessageVC.swift
//  Kinder Care
//
//  Created by CIPL on 19/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import  MobileCoreServices
import DropDown
import IQKeyboardManagerSwift

protocol refreshMessageListDelegate{
  func refreshMessageList()
}


class ComposeMessageVC: BaseViewController {
  
  @IBOutlet weak var viewApproval: UIView!
  @IBOutlet weak var txtTo: CTTextField!
  @IBOutlet weak var labelEmail: UILabel!
  @IBOutlet weak var viewAttachments: UIView!
  @IBOutlet weak var messageTextView: UITextView!
  @IBOutlet weak var subjectTxt: CTTextField!
  @IBOutlet weak var attachmentsSizeLabel: UILabel!
  @IBOutlet weak var attachmentsNumLabel: UILabel!
  @IBOutlet weak var viewClassSection: UIView!
  @IBOutlet weak var txtClass: CTTextField!
  @IBOutlet weak var txtSection: CTTextField!
  
  var classID:Int?
  var sectionID:Int?
  var classNameListArray = [ClassModel]()
  var sectionArray = [Section]()
  
  var messageList: MessageModel?
  var messageDetails = [MessageDetails]()
  
  var arraySelectedUserType:[UserType] = []
  var delegate:refreshMessageListDelegate?
  var arrayUserTypeName:[String] = []
  var arrayUserTypeID:[String] = []
  var sentToIdArray:[Int] = []
  var attachmentsCount:Int = 0
  var attachmentsArray:[URL] = []
  
  var selectedUserID:[Int] = []
  var selectedEmailID:[String] = []
  var selectedUserName:[String]=[]
  
  var selectedUsers:[MessageUserData] = []
  
  
  var schoolID:Int?
  var messageId:Int?
  
  lazy var viewModel : MessageViewModel = {
    return MessageViewModel()
  }()
  
  //MARK:- ViewController LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleString = "COMPOSE MESSAGE"
    
    configUI()
    
    self.viewModel.delegate = self
    
    messageTextView.placeholder = "Type your message here"
    if let _schoolid = schoolID, let msg_id = messageId{
      self.viewModel.viewMessage(schoolId: _schoolid, message_Id: msg_id, student_id: 0)
    }
    
    if attachmentsArray.count == 0 {
      viewAttachments.isHidden = true
    }
    
    //  let attachTap = UITapGestureRecognizer(target: self, action: #selector(attachmentViewAllBtnAction(_:)))
    // viewAttachments.addGestureRecognizer(attachTap)
    
    let addAttachTap = UITapGestureRecognizer(target: self, action: #selector(addAttachmentsBtnAction(_:)))
    subjectTxt.rightView?.isUserInteractionEnabled = true
    subjectTxt.rightView?.addGestureRecognizer(addAttachTap)
    
    self.classNameListArray = SharedPreferenceManager.shared.classNameListArray
    self.sectionArray = SharedPreferenceManager.shared.sectionArray
  }
  
  //MARK:- SetComposeMessage
  func setComposeMessage(){
    let viewMessageDetails = self.messageDetails.first
    if let sentToId = viewMessageDetails?.sendTo  {
      
      sentToIdArray = sentToId.compactMap { Int($0) }
    }
    if let toUserTypeName = viewMessageDetails?.to{
      self.arrayUserTypeName = toUserTypeName
    }
    txtTo.text = arrayUserTypeName.joined(separator: ", ")
    if let subject = viewMessageDetails?.subject{
      subjectTxt.text = subject
    }
    if let messageBodyValue = viewMessageDetails?.message{
      messageTextView.text = messageBodyValue
    }
    if let sentToName = viewMessageDetails?.name {
      self.selectedUserName = sentToName
      
    }
    labelEmail.text = self.selectedUserName.joined(separator: ", ")
    
    if let selectedUserId = viewMessageDetails?.userID{
      
      self.selectedUserID = selectedUserId
    }
  }
  
  func configUI(){
    if  let userType = UserManager.shared.currentUser?.userType {
      if let _type = UserType(rawValue:userType ) {
        switch  _type  {
        case .all,.student : break
        case .teacher:
          viewApproval.isHidden = false
          viewClassSection.isHidden = false
        case .admin:
          viewApproval.isHidden = true
          viewClassSection.isHidden = false
        //txtTo.text = "Teachers,Parents"
        case .superadmin:
          viewApproval.isHidden = true
          viewClassSection.isHidden = false
        //txtTo.text = "Teachers,Parents"
        case .parent:
          viewApproval.isHidden = true
          viewClassSection.isHidden = true
          // txtTo.text = "Childrens"
        }
      }
    }
  }
  
  //MARK:- Button Action
  @IBAction func attachmentCloseBtnAction(_ sender: Any) {
    attachmentsArray.removeAll()
    viewAttachments.isHidden = true
    
  }
  @IBAction func sendBtnAction(_ sender: Any) {
    
    if isCheckValidateMessage(){
      
      if let school_id = self.schoolID {
        
        if attachmentsArray.count == 0 {
          
          self.viewModel.composeMessageWithoutAttachments(school_id: school_id, save_type: 2, send_to: [1], message:self.messageTextView.text , subject: subjectTxt.text!, user_id: selectedUserID, msg_id: messageId ?? 0)
          
          
        }else{
          self.viewModel.composeMessageWithAttachments(school_id: school_id, save_type: 2, send_to: [1], message: messageTextView.text, subject: subjectTxt.text!, user_id: selectedUserID, attachments: attachmentsArray, msg_id: messageId ?? 0)
          
          
        }
      }
    }
  }
  
  @IBAction func draftBtnAction(_ sender: Any) {
    
    if attachmentsArray.count != 0 {
      
      let alert = UIAlertController(title: "Alert", message: "Attachment cannot be saved in Drafts", preferredStyle: UIAlertController.Style.alert)
      
      alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
        action in
      }))
      
      alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {
        
        action in
        
        if self.isCheckValidateMessage(){
          
          if let school_id = self.schoolID {
            
            self.viewModel.composeMessageWithoutAttachments(school_id: school_id, save_type: 1, send_to: [1], message: self.messageTextView.text, subject: self.subjectTxt.text!, user_id: self.selectedUserID, msg_id: 0)
            
          }
        }
        
      }))
      self.present(alert, animated: true, completion: nil)
      
    }else{
      
      if isCheckValidateMessage(){
        
        if let school_id = self.schoolID {
          
          self.viewModel.composeMessageWithoutAttachments(school_id: school_id, save_type: 1, send_to: [1], message: messageTextView.text, subject: subjectTxt.text!, user_id: self.selectedUserID, msg_id: 0)
          
        }
      }
      
    }
  }
  
  private func isCheckValidateMessage() -> Bool{
    
    if self.selectedUserID.count > 0 && selectedUserID.count > 0{
      
      guard let subject = subjectTxt.text, !subject.removeWhiteSpace().isEmpty else {
        displayError(withMessage: .subject)
        return false
      }
      
      guard let message = messageTextView.text, !message.removeWhiteSpace().isEmpty else {
        displayError(withMessage: .message)
        return false
      }
      
      return true
      
    }else{
      displayError(withMessage: .selectSentToUsers)
      return false
    }
    
  }
  
  @objc func addAttachmentsBtnAction(_ sender: Any){
    
    let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeVideo), String(kUTTypePlainText), String(kUTTypeMP3)], in: .import)
    importMenu.delegate = self
    importMenu.modalPresentationStyle = .formSheet
    
    if let popoverPresentationController = importMenu.popoverPresentationController {
      popoverPresentationController.sourceView = sender as? UIView
      // popoverPresentationController.sourceRect = sender.bounds
    }
    self.present(importMenu, animated: true, completion: nil)
    
  }
  @IBAction func attachmentViewAllBtnAction(_ sender: Any) {
    let vc = UIStoryboard.messageStoryboard().instantiateViewController(withIdentifier:"AttachmentsVC") as! AttachmentsVC
    
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func addButtonHandler(sender:UIButton){
    
    if  let sentTo = txtTo.text {
      if  sentTo.isEmpty
      {
        displayServerError(withMessage: "Please Select Sent to")
      }
      else
      {
        let story = UIStoryboard(name: "AddActivity", bundle: nil)
        let studentListVC = story.instantiateViewController(withIdentifier: "StudentListVC") as! StudentListVC
        
        studentListVC.delegate = self
        studentListVC.modalPresentationStyle = .overCurrentContext
        studentListVC.schoolID = schoolID
        studentListVC.classID = self.classID
        studentListVC.sectionID = self.sectionID
        studentListVC.userTypeArray = arraySelectedUserType
        studentListVC.selectedUsersArray = selectedUsers
        studentListVC.fromMessages = true
        self.navigationController?.present(studentListVC, animated: true, completion: nil)
      }
    }
  }
  
  //MARK:- Show DropDown
  func showDropDown(sender : UITextField, content : [String]) {
    
    let dropDown = DropDown()
    dropDown.direction = .any
    dropDown.anchorView = sender
    dropDown.dismissMode = .automatic
    dropDown.dataSource = content
    
    dropDown.selectionAction = { (index: Int, item: String) in
      
      sender.text = item
      
      if sender == self.txtClass{
        self.classID = self.classNameListArray[index].id
        
      }
      
      if sender == self.txtSection {
        
        self.sectionID = self.sectionArray[index].id
        
      }
      
    }
    dropDown.width = sender.frame.width
    dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
    dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
    
    if let visibleDropdown = DropDown.VisibleDropDown {
      
      visibleDropdown.dataSource = content
      
    }else {
      dropDown.show()
    }
    
  }
  
  
}
extension ComposeMessageVC: messageDelegate{
  func listMessagesSuccessfull(messageData: [MessageModel]?, messageType: Int) {
    
  }
  
  func deleteMessageSuccessfull(message:String) {
    
  }
  
  func viewMessageSuccessfull(messageDetail: [MessageDetails]) {
    self.messageDetails = messageDetail
    setComposeMessage()
  }
  
  
  func composeMessageSuccessfull(message:String) {
    
    
    self.delegate?.refreshMessageList()
    self.navigationController?.popViewController(animated: true)
    displayServerSuccess(withMessage: message)
  }
  
  func failure(message: String) {
    displayServerError(withMessage: message)
  }
  
  
}

extension ComposeMessageVC : UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    if [txtTo].contains(textField) {
      let story = UIStoryboard(name: "Message", bundle: nil)
      let selecPopup = story.instantiateViewController(withIdentifier: "SelectSenderPopUpVC") as! SelectSenderPopUpVC
      selecPopup.selectedUserTypeArray = arraySelectedUserType
      selecPopup.delegate = self
      selecPopup.modalPresentationStyle = .overCurrentContext
      self.navigationController?.present(selecPopup, animated: true, completion: nil)
      return false
      
    }else if textField == txtClass{
      
      showDropDown(sender: textField, content: SharedPreferenceManager.shared.classNameListArray.map({$0.className}))
      return false
      
    }else if textField == txtSection{
      
      showDropDown(sender: textField, content: SharedPreferenceManager.shared.sectionArray.map({$0.section!}))
      return false
    }
    
    
    return true
  }
  
  
}

extension ComposeMessageVC: SelectedUserDelegate{
  
  func selectedUserList(arrayUserList: [UserType]) {
    arraySelectedUserType = arrayUserList
    txtTo.text = arrayUserList.map({$0.stringValue}).joined(separator: ", ")
  }
  
}

extension ComposeMessageVC: sendSelectedEmailDelegate{
  
  func selectedTeachers(students: [TeacherListData], users: [MessageUserData]) {
    
  }
  
  func classNameList(classData: [ClassModel], classId: Int) {
    
  }
  
  
  func selectedStudents(students: [Student],users:[MessageUserData]) {
    print(students)
    selectedUserID = users.map({$0.id})
    
    selectedUsers = users
    
    labelEmail.text = users.map({$0.email}).compactMap({$0}).joined(separator: ", ")
    
    
  }
  
  func selectedUsers(users: [MessageUserData]) {
    
    selectedUserID = users.map({$0.id})
    
    selectedUsers = users
    
    labelEmail.text = users.map({$0.email}).compactMap({$0}).joined(separator: ", ")
  }
}

extension ComposeMessageVC : UIDocumentMenuDelegate,UIDocumentPickerDelegate {
  
  
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    
    do {
      
      viewAttachments.isHidden = false
      
      if let url = urls.first{
        
        attachmentsArray.append(url)
        
        let fileData = try Data(contentsOf: url)
        
        let bcf = ByteCountFormatter()
        
        bcf.allowedUnits = [.useKB]
        
        bcf.countStyle = .file
        
        let fileSizeString = bcf.string(fromByteCount: Int64(fileData.count))
        
        attachmentsNumLabel.text = "Attachments (" + "\(attachmentsArray.count)" + ")"
        
        if let sizeText = attachmentsSizeLabel.text {
          
          if sizeText.isEmpty {
            
            attachmentsSizeLabel.text =  fileSizeString
          }
            
          else{
            
            let replacedString1 = sizeText.replacingOccurrences(of: " KB", with: "")
            
            let replacedString2 = fileSizeString.replacingOccurrences(of: " KB", with: "")
            
            if  let  oldValue = Int(replacedString1), let newValue = Int(replacedString2) {
              
              let addedIntValue = oldValue + newValue
              
              attachmentsSizeLabel.text = String(addedIntValue) + " KB"
            }
          }
        }
      }
    }catch {
      
      print("Error: \(error)")
      
    }
    
  }
  func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController){
    
    documentPicker.delegate = self
    
    self.present(documentPicker, animated: true, completion: nil)
  }
  
  
  
  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    dismiss(animated: true, completion: nil)
  }
  
}
