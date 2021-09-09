//
//  InboxViewController.swift
//  Kinder Care
//
//  Created by CIPL0681 on 18/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

protocol deletedMessageDelegate {
  func refreshAfterDeleteMessage()

}

class InboxViewController: BaseViewController {
  
  @IBOutlet weak var attachmentsSizeLabel: UILabel!
  @IBOutlet weak var attachmentsNumLabel: UILabel!
  @IBOutlet weak var labelAttachment: UILabel!
  @IBOutlet weak var attachmentView: CTView!
  @IBOutlet weak var labelMessage: UILabel!
  @IBOutlet weak var labelSubject: UILabel!
  @IBOutlet weak var labelAdmin: UILabel!
  @IBOutlet weak var labelName: UILabel!
  @IBOutlet weak var imgProfile: UIImageView!
  @IBOutlet weak var labelDate: UILabel!
  @IBOutlet weak var fromView: UIView!
  @IBOutlet weak var toView: UIView!
  
  @IBOutlet weak var toAddressLabel: UILabel!
  @IBOutlet weak var toTimeDateLabel: UILabel!
  
  @IBOutlet weak var deleteMessageBtn: CTButton!
  var messageType : MessageType!
  var messageID:Int?
  var schoolID:Int?
    var senderType:String?
  var messageDetails = [MessageDetails]()
  var attachmentsCount:Int?
    var studentID:Int?
    var attachmentSize:String?
  var delegate:deletedMessageDelegate?
  
  lazy var viewModel: MessageViewModel = {
    return MessageViewModel()
  }()
  
  //MARK:- ViewController LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleString = messageType.stringValue.uppercased()
    
    self.attachmentView.isHidden = true
    
    self.viewModel.delegate = self
    
    if let _schoolid = schoolID, let msg_id = messageID {
      
        self.viewModel.viewMessage(schoolId: _schoolid, message_Id: msg_id, student_id: studentID ?? 0)
      
    }
  }
  
  override func viewDidLayoutSubviews(){
    
    imgProfile.layer.cornerRadius = imgProfile.frame.height/2
    imgProfile.layer.borderWidth = 2
    imgProfile.layer.borderColor = UIColor.white.cgColor
    imgProfile.layer.masksToBounds = false
    imgProfile.clipsToBounds = true
  }
  
  //MARK:- SETUP UI
  func setMessage(){
    
    if let message_Details = messageDetails.first {
      
      switch messageType {
        
      case .compose,.Draft,.none: break
        
      case .Trash:
        
        toView.isHidden = false
        fromView.isHidden = false
        deleteMessageBtn.isHidden = true
        
      case .Inbox:
        
        toView.isHidden = true
        fromView.isHidden = false
        deleteMessageBtn.isHidden = false
        
      case .Sent:
        
        toView.isHidden = false
        fromView.isHidden = true
        deleteMessageBtn.isHidden = false
      }
      
      setupMessageUI(message_Details)
      
    }
  }
  
  //MARK:- setup MessageUI
  
  func setupMessageUI(_ messageDetails: MessageDetails){
    
    if let img = messageDetails.profile{
      
      if let urlString = img.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed){
        
        if let url = URL(string: urlString){
          
          imgProfile.sd_setImage(with: url)
        }
      }
    }
    
    if messageDetails.attachment?.count == 0{
      
      attachmentView.isHidden = true
      
    }else{
      
      attachmentView.isHidden = false
      
      if let _attachementCount = messageDetails.attachment?.count{
        
        attachmentsNumLabel.text = "Attachments (" + "\(_attachementCount)" + ")"
        
        if let arrayAttachement = messageDetails.attachment {
          
          let fileSize = getAttachementSize(attachmentFile: arrayAttachement)
          
          if fileSize.isEmpty{
            
            if let attchmentCount = attachmentSize{
                attachmentsSizeLabel.text = attchmentCount
            }
            
          }else{
            
            
            
           if let attchmentCount = attachmentSize{
                attachmentsSizeLabel.text = attchmentCount
            }
          }
          
        }
      }
    }
    
    switch messageType {
      
    case .compose,.Draft,.none: break
      
    case .Trash:
      
      toAddressLabel.text = messageDetails.name.joined(separator: ", ")
      labelName.text = messageDetails.from
      labelSubject.text = messageDetails.subject
      labelMessage.text = messageDetails.message
      labelAdmin.text = messageDetails.fromUserType
      self.senderType = messageDetails.fromUserType
      labelDate.text = messageDetails.date
      
    case .Inbox:
      
      labelName.text = messageDetails.from
      labelSubject.text = messageDetails.subject
      labelMessage.text = messageDetails.message
      labelAdmin.text = messageDetails.fromUserType
       self.senderType = messageDetails.fromUserType
      labelDate.text = messageDetails.date
      
    case .Sent:
      
      toAddressLabel.text = messageDetails.name.joined(separator: ", ")
      labelSubject.text = messageDetails.subject
      labelMessage.text = messageDetails.message
      toTimeDateLabel.text = messageDetails.date
         self.senderType = messageDetails.fromUserType
    }
  }
  
  //MARK:- Get AttachementSize
  func getAttachementSize(attachmentFile: [String]) -> String {
    
    var fileSizeString = ""
    
    for fileUrl in attachmentFile {
      do {
        
        let _url = URL(fileURLWithPath: fileUrl)
        
        let fileData = try Data (contentsOf: _url)
        
        let bcf = ByteCountFormatter()
        
        bcf.allowedUnits = [.useKB]
        
        bcf.countStyle = .file
        
        fileSizeString = bcf.string(fromByteCount: Int64(fileData.count))
        
      }catch {
        print("Error: \(error)")
        if let attchmentCount = attachmentSize{
            attachmentsSizeLabel.text = attchmentCount
        }
        
      }
    }
    
    return fileSizeString
  }
  //MARK:- Button Action Methodes
  
  @IBAction func attachmentViewAllBtnAction(_ sender: Any){
    let vc = UIStoryboard.messageStoryboard().instantiateViewController(withIdentifier:"MessageAttechmentViewController") as! MessageAttechmentViewController
    vc.attachmentsDetails = messageDetails
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  @IBAction func deleteAction(_ sender: UIButton){
    
    let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Delete ?", preferredStyle: UIAlertController.Style.actionSheet)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
      action in
    }))
    
    alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
      action in
      
        if let message_id = self.messageID , let senderType = self.senderType {
        
            self.viewModel.deleteMessage(msg_type: self.messageType.rawValue, message_Id: message_id, senderType: senderType, student_id: self.studentID ?? 0)
      }
      
    }))
    self.present(alert, animated: true, completion: nil)
    
  }
  

}

//MRAK:- Message Delegate Methodes

extension InboxViewController : messageDelegate{
  
  func listMessagesSuccessfull(messageData: [MessageModel]?, messageType: Int) {
  }
  
  func deleteMessageSuccessfull(message:String){
    displayServerSuccess(withMessage: message)
    
    self.delegate?.refreshAfterDeleteMessage()
    self.navigationController?.popViewController(animated: true)
  }
  
  func viewMessageSuccessfull(messageDetail: [MessageDetails]){
    print(messageDetail)
    self.messageDetails = messageDetail
    self.setMessage()
  }
  
  func composeMessageSuccessfull(message:String){
    
  }
  
  func failure(message: String){
  }
}
