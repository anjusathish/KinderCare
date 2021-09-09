//
//  MessageListVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 20/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

enum MessageType : Int {
    
    case Draft = 1
    case Sent = 2
    case Inbox = 3
    case Trash = 4
    case compose = 0
    
    var stringValue : String {
        
        switch self {
        case .Draft : return "Draft"
        case .Sent : return "Sent"
        case .Inbox : return "Inbox"
        case .Trash : return "Trash"
        case .compose : return "Compose"
        }
    }
}

class MessageListVC: BaseViewController {
    
    //MARK:- Initialization
    @IBOutlet weak var tblMessage: UITableView!
    @IBOutlet weak var vwSegement: CTSegmentControl!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblInboxCount: UILabel!
    @IBOutlet weak var composeView: UIView!
    @IBOutlet weak var trashView: UIView!
    @IBOutlet weak var sentView: UIView!
    @IBOutlet weak var draftView: UIView!
    @IBOutlet weak var inboxView: UIView!
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var slideStackView: UIStackView!
    @IBOutlet weak var childDropdown: ChildDropDown!
    @IBOutlet weak var childDropdownStackView: UIStackView!
    @IBOutlet weak var messageTypeStack: UIStackView!
    
    @IBOutlet var childDropHeightConstraint: NSLayoutConstraint!
    
    var selectedMessageType : MessageType = .Inbox
    var selectedUserType : UserType = .all
    var selectedUserTypeString:String = "All"
    var schoolID:Int?
    var schoolListArray = [SchoolListData]()
    var childNameArray = [ChildName]()
    var childNameID:Int?
    var messageCountInbox:Bool!
    var messageList: [MessageModel] = []
    
    lazy var viewModel : MessageViewModel   =  {
        return MessageViewModel()
    }()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        if let childName = UserManager.shared.childNameList {
            childNameArray = childName
            self.childNameID = childNameArray.map({$0.id}).first
        }
        
        
        if  let userType = UserManager.shared.currentUser?.userType {
            
            if let _type = UserType(rawValue:userType ) {
                
                vwSegement.segmentTitles = _type.messageTitles
                
                switch  _type  {
                    
                case .parent:
                    slideView.isHidden = true
                    topBarHeight = 100
                    childDropdown.isHidden = false
                    setupDropdown(userType: _type)
                    if let schoolID = UserManager.shared.currentUser?.school_id {
                        
                        self.schoolID = schoolID
                    }
                    
                case .teacher:
                  
                  lblInboxCount.isHidden = true
                  if let schoolID = UserManager.shared.currentUser?.school_id {
                      //schoolListArray = schoolData
                      self.schoolID = schoolID
                  }
                    
                    
                case .admin:
                    lblInboxCount.isHidden = true
                    if let schoolID = UserManager.shared.currentUser?.school_id {
                       
                        self.schoolID = schoolID
                    }
                    
                case .superadmin:
                    lblInboxCount.isHidden = true
                    let schoolid = UserDefaults.standard.integer(forKey: "sc")
                    if  schoolid > 1 {
                        self.schoolID = schoolid
                    }
                       
                        
                    else if let schoolData = UserManager.shared.schoolList {
                        self.schoolID = schoolData.first?.id
                    }
                    
                    if let schoolData = UserManager.shared.schoolList {
                       schoolListArray = schoolData
                        
                    }
                    
                    topBarHeight = 100
                    childDropdown.isHidden = false
                    
                case .all,.student: break
                }
                
                setupDropdown(userType: _type)
            }
        }
        if vwSegement.selectedSegmentIndex == 1 {
            print("All")
        }
        
        titleString = "MESSAGES"
        
        tblMessage.delegate = self
        tblMessage.dataSource = self
        
        tblMessage.emptyDataSetSource = self
        tblMessage.emptyDataSetDelegate = self
        
        tblMessage.tableFooterView = UIView()
        tblMessage.tableHeaderView = headerView
        tblMessage.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        
        for item in [inboxView,sentView,draftView,trashView,composeView] {
            item?.layer.cornerRadius = 10
            let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
            item?.addGestureRecognizer(tap)
        }
        
        setSelected()
       
        
        self.view.bringSubviewToFront(childDropdownStackView)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         listMessages()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        slideView.layer.cornerRadius = 12
        slideView.layer.masksToBounds = false
        slideView.clipsToBounds = true
        
        lblInboxCount.layer.cornerRadius = lblInboxCount.frame.height/2
        lblInboxCount.backgroundColor = UIColor.ctBlue
        lblInboxCount.layer.masksToBounds = false
        lblInboxCount.clipsToBounds = true
    }
    
    //MARK:- DropDown
    func setupDropdown(userType : UserType){
        
        switch userType {
        case .parent:
            childDropdown.titleArray = childNameArray.map({$0.name})
              childDropdown.subtitleArray = childNameArray.map({$0.className + " , " + $0.section + " Section"})
            childDropdown.headerTitle = "Select Child Name"
         //   childDropdown.footerTitle = ""
        case .superadmin:
            var schoolid = UserDefaults.standard.integer(forKey: "sc")
            childDropdown.titleArray = schoolListArray.map({$0.schoolName})
            childDropdown.subtitleArray = schoolListArray.map({$0.location})
            childDropdown.headerTitle = "Select School Branch"
            
          if schoolListArray.count > 0 {
              if schoolid != 0 {
              let index = schoolListArray.firstIndex(where: {$0.id == schoolid})
              childDropdown.selectedIndex = index
               
              DispatchQueue.main.async {
                  self.childDropdown.nameLabel.text = self.schoolListArray[index ?? 0].schoolName
                  self.childDropdown.section.text = self.schoolListArray[index ?? 0].address
              }
            }
          }
        case .all,.teacher,.admin,.student: break
        }
        
        switch userType{
            
        case .parent:
            if childNameArray.count > 1{
            childDropdown.selectionAction = { (index : Int) in
                self.childNameID = self.childNameArray[index].id
                
                self.listMessages()
                }}
            else{
                childDropdown.isUserInteractionEnabled = false
            }
            
        case .teacher,.all,.student,.admin:
            break
            
        case .superadmin:
            childDropdown.selectionAction = { (index : Int) in
                self.schoolID = self.schoolListArray[index].id
                UserDefaults.standard.set(self.schoolID, forKey: "sc")
                self.listMessages()
            }
            
        }
        
        
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer){
        
        guard let type = MessageType(rawValue: gesture.view!.tag) else {
            return
        }
        
        selectedMessageType = type
        
        setSelected()
        
        switch type {
            
        case .Sent,.Inbox,.Trash:
            listMessages()
            
        case .Draft:
            listMessages()
            
        case .compose:
            let storyBoard = UIStoryboard.attendanceStoryboard()
            let composeVC = storyBoard.instantiateViewController(withIdentifier: "ComposeMessageVC") as! ComposeMessageVC
            composeVC.schoolID = self.schoolID
            self.navigationController?.pushViewController(composeVC, animated: true)
        }
    }
    
    
    
    //MARK:- SetSelected
    func setSelected() {
        
        for view in messageTypeStack.subviews {
            
            if view.tag == selectedMessageType.rawValue {
                if view.tag == 0 {
                    return
                }
                view.backgroundColor = .white
                
                for item in view.subviews {
                    
                    if item is UILabel {
                        if (item as! UILabel).tag == 1{
                            (item as! UILabel).textColor = .white
                        }else{
                            (item as! UILabel).textColor = .ctYellow
                        }
                    }
                    else {
                        item.tintColor = .ctYellow
                    }
                }
            }
            else {
                view.backgroundColor = .clear
                
                for item in view.subviews {
                    if item is UILabel {
                        (item as! UILabel).textColor = .white
                    }
                    else {
                        item.tintColor = .white
                    }
                }
            }
        }
    }
    
    
    //MARK:-  SEGUE Methods
    
    override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier ==  "messageListToInbox" {
            if let destination = segue.destination as? InboxViewController {
                destination.delegate = self
                
                let  array = sender as? NSArray
                if let msg_type = array?[0] as? MessageType{
                    destination.messageType = msg_type
                }
                if let school_id = array?[1] as? Int{
                    destination.schoolID = school_id
                }
                if let msg_id = array?[2] as? Int{
                    destination.messageID = msg_id
                    destination.studentID = self.childNameID ?? 0
                    
                }
                
                
            }
        }
    }
    
    //MARK:- Local Methods
    
    @IBAction func segmentViewAction(_ sender: CTSegmentControl) {
        
        guard let type = UserTypeTitle(rawValue: sender.selectedSegmentTitle), let userType = UserType(rawValue: type.id) else {
            return
        }
        selectedUserType = userType
        selectedUserTypeString = sender.selectedSegmentTitle
        //lblInboxCount.text = "0"
        listMessages()
    }
    
    func listMessages(){
        print(selectedMessageType.rawValue)
        if let _schoolId = self.schoolID,selectedMessageType.rawValue == 0 {
            
            viewModel.listMessages(schoolId: _schoolId, listBy: selectedUserType.rawValue, msg_type: 3, student_id: childNameID ?? 0)
        }
            
        else if let _schoolId = self.schoolID {
            
            viewModel.listMessages(schoolId: _schoolId, listBy: selectedUserType.rawValue, msg_type: selectedMessageType.rawValue, student_id: childNameID ?? 0)
            
        }
    }
}

extension MessageListVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
         
        
        if messageList[indexPath.row].attachment_cnt == 0 {
            cell.attachmentIconImgView.isHidden = true
        }
        else{
            cell.attachmentIconImgView.isHidden = false
        }
        
        if messageCountInbox == true {
         let countUnread = messageList.filter({$0.read_status == 0})
        print(countUnread.count)
            lblInboxCount.text = "\(countUnread.count)"
        }
        
        if messageList[indexPath.row].read_status == 0 {
            
           
           
            cell.indicationBtn.isHidden = true
            cell.mainView.layer.borderColor = UIColor.ctBlue.cgColor
            cell.mainView.layer.borderWidth = 1.0
            cell.mainView.layer.cornerRadius = 20
            cell.mainView.layer.masksToBounds = true

            
        }
        else{
            cell.mainView.layer.borderColor = UIColor.white.cgColor
            cell.indicationBtn.isHidden = true
        }

        cell.selectionStyle = .none
        
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.height/2
        cell.imgProfile.layer.masksToBounds = false
        cell.imgProfile.clipsToBounds = true
        
        
        if selectedMessageType == .Draft {
            cell.imgProfile.isHidden = true
            cell.attachmentIconImgView.isHidden = true
           
        }
        else {
            let img = messageList[indexPath.row].profile
            
            if let _image = img {
                if let urlString = _image.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
                    if let url = URL(string: urlString) {
                        cell.imgProfile.sd_setImage(with: url)
                    }
                }
            }
            cell.imgProfile.isHidden = false
        }
        
        if let date = messageList[indexPath.row].date {
            
            cell.labelTime.text = date.getDateAsStringWith(inFormat: "hh:mm a dd MMM yyyy", outFormat: "dd MMM yyyy hh:mm")
        }
        else {
            cell.labelTime.text = ""
        }
        
        cell.labelName.text = messageList[indexPath.row].name
        if let sender = messageList[indexPath.row].senderType {
            cell.userTypeLabel.text = sender
        }
        else if let receiver = messageList[indexPath.row].receiverType {
            cell.userTypeLabel.text = receiver
        }
        
        
        if let subject = messageList[indexPath.row].subject {
            cell.subjectLabel.text =  "Sub: " +  subject
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let school_id = self.schoolID, let msg_id = messageList[indexPath.row].msgID {
            
            if selectedMessageType == .Draft {
                
                let storyBoard = UIStoryboard.attendanceStoryboard()
                let composeVC = storyBoard.instantiateViewController(withIdentifier: "ComposeMessageVC") as! ComposeMessageVC
                composeVC.schoolID = self.schoolID
                composeVC.messageId = msg_id
                composeVC.delegate = self
                self.navigationController?.pushViewController(composeVC, animated: true)
            }
            else
            {
                let storyBoard = UIStoryboard.messageStoryboard()
                let vc = storyBoard.instantiateViewController(withIdentifier: "InboxViewController") as! InboxViewController
                vc.schoolID = school_id
                vc.messageID = msg_id
                vc.studentID = self.childNameID
                vc.messageType = selectedMessageType
                vc.attachmentsCount = messageList[indexPath.row].attachment_cnt
                vc.attachmentSize = messageList[indexPath.row].attachment_size
                self.navigationController?.pushViewController(vc, animated: true)
               
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MessageListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        
        let str = "No Messages in " + selectedMessageType.stringValue + " for " + selectedUserTypeString +  " !"
        return NSAttributedString(string: str, attributes: attrs)
    }
}

extension MessageListVC : messageDelegate {
    
    func listMessagesSuccessfull(messageData: [MessageModel]?, messageType: Int) {
        if let _messageData = messageData {
            print(messageType)
            if messageType == 3 {
                messageCountInbox = true
            }
            else{
                messageCountInbox = false
            }
            messageList = _messageData
            
            let messageType = MessageType(rawValue: messageType)
            
            switch messageType {
            case .Inbox:
                //lblInboxCount.text = "\(_messageData.count)"
                lblInboxCount.isHidden = false
                
            default:break
                
            }
            
        }
        
        tblMessage.reloadData()
    }
    
    
    func deleteMessageSuccessfull(message:String) {
        displayServerSuccess(withMessage: message)
        print("Abdul")
        //delete
    }
    
    func viewMessageSuccessfull(messageDetail: [MessageDetails]) {
        //view
    }
    
    func composeMessageSuccessfull(message:String) {
        
        self.displayServerSuccess(withMessage: message)
        //Extra
    }
    
    
    func failure(message: String) {
        displayServerError(withMessage: message)
        messageList.removeAll()
        tblMessage.reloadData()
    }
    
    
}
extension MessageListVC : deletedMessageDelegate {
    
    func refreshAfterDeleteMessage() {
        listMessages()
    }
}

extension Date {
    
    var tomorrow: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
}

extension MessageListVC:refreshMessageListDelegate {
    
    func refreshMessageList() {
        self.listMessages()
    }
    
}
