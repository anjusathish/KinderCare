//
//  LeaveApprovalVC.swift
//  Kinder Care
//
//  Created by CIPL0681 on 06/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

enum leaveRequestStatus : Int {
  case pending = 1
  case approved = 2
  case rejected = 3
}

class LeaveApprovalVC: BaseViewController {
  
  @IBOutlet weak var segmentTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var childDropDown: ChildDropDown!
  @IBOutlet var segmentViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet var segmentStackView: UIStackView!
  @IBOutlet var segmentView: CTSegmentControl!
  @IBOutlet weak var leaveApprovalTableview: UITableView!
  
  
  var schoolID:Int?
  var schoolListArray = [SchoolListData]()
  var userID:Int?
  var selectedUserType :    UserType = .teacher
  var failureMessage:String?
  var totalDays:Int?
  var customLeaveFilterObj : LeaveApprovalFilterViewController!
  lazy var viewModel : LeaveApprovalViewModel   =  {
    return LeaveApprovalViewModel()
  }()
  
  var day: String = ""
  var year: String = ""
  var month: String = ""
  var hours:String = ""
  var mints:String = ""
  var AMPM:String = ""
  
  
  
  
  var leaveApprovalViewArray = [LeaveApprovalList]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleString = "LEAVE APPROVAL"
    
    viewModel.delegate = self
    configureUISetUp()
    
    
    self.view.bringSubviewToFront(childDropDown)
    
    self.leaveApprovalTableview.register(UINib(nibName: "LeaveApprovalCell", bundle: nil), forCellReuseIdentifier: "LeaveApprovalCell")
    leaveApprovalTableview.separatorColor = UIColor.clear
    
    
    
    leaveApprovalTableview.emptyDataSetDelegate = self
    leaveApprovalTableview.emptyDataSetSource = self
    
    guard let type = UserTypeTitle(rawValue: segmentView.selectedSegmentTitle), let userType = UserType(rawValue: type.id) else {
      return
    }
    
    selectedUserType = userType
  }
  
  @IBAction func clicktoReset(_ sender: Any) {
    let schoolid = UserDefaults.standard.integer(forKey: "sc")
    if  schoolid > 1 {
      self.schoolID = schoolid
    }
    else if let schoolID = UserManager.shared.currentUser?.school_id {
      self.schoolID = schoolID
      
    }
    if UserManager.shared.currentUser?.userTypeName == "teacher"{
      
      if let _schoolID = self.schoolID {
        viewModel.getLeaveApproval(schoolID: _schoolID, userType: 6, searchVal: "", status: "")
        
      }
      
    }
    
    else if let _schoolID = self.schoolID {
      viewModel.getLeaveApproval(schoolID: _schoolID, userType:selectedUserType.rawValue, searchVal: "", status: "")
      
    }
    
  }
  
  @IBAction func filterBtn(_ sender: Any) {
    self.addCustomLeaveFilterSelect()
  }
  
  func configureUISetUp(){
    
    if  let userType = UserManager.shared.currentUser?.userType {
      if let _type = UserType(rawValue:userType ) {
        
        segmentView.segmentTitles = _type.leaveApprovalTitles
        
        switch  _type  {
        case .all,.student : break
          
        case .parent:
          topBarHeight = 90
          segmentView.isHidden = true
          segmentStackView.isHidden = true
          segmentViewHeightConstraint.constant = 0
          
        case .teacher:
          topBarHeight = 50
          segmentView.isHidden = true
          segmentStackView.isHidden = true
          segmentViewHeightConstraint.constant = 0
          childDropDown.isHidden = true
          //tableTopConstraint.constant = -150
          segmentTopConstraint.constant = -70
          if let schoolID = UserManager.shared.currentUser?.school_id {
            self.schoolID = schoolID
            
          }
          
          if let _schoolID = self.schoolID {
            viewModel.getLeaveApproval(schoolID: _schoolID, userType: 6, searchVal: "", status: "")
            
          }
          
        case .admin:
          segmentView.isHidden = false
          segmentStackView.isHidden = false
          segmentViewHeightConstraint.constant = 50
          
          childDropDown.isHidden = true
          if let schoolID = UserManager.shared.currentUser?.school_id {
            self.schoolID = schoolID
            
          }
          
          if let _schoolID = self.schoolID {
            viewModel.getLeaveApproval(schoolID: _schoolID, userType:selectedUserType.rawValue, searchVal: "", status: "")
            
          }
          
        case .superadmin:
          
          let schoolid = UserDefaults.standard.integer(forKey: "sc")
          if  schoolid > 1 {
            self.schoolID = schoolid
            if let schoolData =  UserManager.shared.schoolList{
              schoolListArray = schoolData
            }
          }
          
          else if let schoolData = UserManager.shared.schoolList {
            schoolListArray = schoolData
            self.schoolID = schoolListArray.first?.id
          }
          segmentView.isHidden = false
          segmentStackView.isHidden = false
          segmentViewHeightConstraint.constant = 50
          topBarHeight = 100
          childDropDown.isHidden = false
          childDropDown.headerTitle = "Select School Branch"
          //  childDropDown.footerTitle = ""
          self.schoolDropdownAction()
          
        }
      }
    }
    
    self.view.bringSubviewToFront(childDropDown)
    addFilterViewInstance()
    
  }
  
  func getYearMonth(date : String){
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
    let convertedDate = dateFormatter.date(from: date)
    
    dateFormatter.dateFormat = "yyyy"
    if let date1 = convertedDate {
      year  =  dateFormatter.string(from: date1)
      dateFormatter.dateFormat = "MMM"
      month = dateFormatter.string(from: date1)
      dateFormatter.dateFormat = "dd"
      day = dateFormatter.string(from: date1)
    }
  }
  
  @objc func approveBtnAction(_ sender: UIButton) {
    
    self.totalDays = leaveApprovalViewArray[sender.tag].totDays
    if  let userType = UserManager.shared.currentUser?.userType {
      if let _type = UserType(rawValue:userType ) {
        
        switch  _type  {
        
        
        
        case .parent,.all,.student:
          break
        case .teacher:
          
          
          self.userID = leaveApprovalViewArray[sender.tag].id
          if let schoolID = self.schoolID,let user_id = self.userID {
            viewModel.updateLeaveApproval(userID: String(user_id), status: 2, school_id: schoolID)
          }
          break
        case .admin:
          let multiStudent =  "\(UserManager.shared.currentUser?.permissions?.multiLevelStudentLeaveDays)"
          let total = "\(totalDays)"
          if selectedUserType.stringValue ==  "Student"{
            
            if UserManager.shared.currentUser?.permissions?.studentLeaveApprove == 0 {
              displayServerError(withMessage: "Admin Have No Rights to Approve / Reject ")
              
            }
            else if total <=  multiStudent {
              
              guard let type = UserTypeTitle(rawValue: segmentView.selectedSegmentTitle), let userType = UserType(rawValue: type.id) else {
                return
              }
              
              selectedUserType = userType
              self.userID = leaveApprovalViewArray[sender.tag].id
              if let schoolID = self.schoolID,let user_id = self.userID {
                viewModel.updateLeaveApproval(userID: String(user_id), status: 2, school_id: schoolID)
              }
              
            }
            else {
              displayServerError(withMessage: "Admin Have No Rights to Approve / Reject")
            }
            
          }
          
          else{
            if total <=  multiStudent {
              
              guard let type = UserTypeTitle(rawValue: segmentView.selectedSegmentTitle), let userType = UserType(rawValue: type.id) else {
                return
              }
              
              selectedUserType = userType
              self.userID = leaveApprovalViewArray[sender.tag].id
              if let schoolID = self.schoolID,let user_id = self.userID {
                viewModel.updateLeaveApproval(userID: String(user_id), status: 2, school_id: schoolID)
              }
              
            }
            
          }
          break
          
          
        case .superadmin:
          
          guard let type = UserTypeTitle(rawValue: segmentView.selectedSegmentTitle), let userType = UserType(rawValue: type.id) else {
            return
          }
          
          selectedUserType = userType
          self.userID = leaveApprovalViewArray[sender.tag].id
          if let schoolID = self.schoolID,let user_id = self.userID {
            viewModel.updateLeaveApproval(userID: String(user_id), status: 2, school_id: schoolID)
          }
          break
          
          
        }
        
        
      }
      
    }
    
  }
  func getLeaveFilterInstance() -> LeaveApprovalFilterViewController{
    let filterObj = Constants.viewControllerWithName(identifier:"LeaveApprovalFilterViewController") as! LeaveApprovalFilterViewController
    return filterObj
  }
  
  @objc func rejectBtnAction(_ sender: UIButton) {
    if  let userType = UserManager.shared.currentUser?.userType {
      if let _type = UserType(rawValue:userType ) {
        
        switch  _type  {
        
        case .teacher:
          selectedUserType = .teacher
          
          let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Reject ?", preferredStyle: UIAlertController.Style.actionSheet)
          
          alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            action in
          }))
          
          alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: {
            action in
            
            self.userID = self.leaveApprovalViewArray[sender.tag].id
            if let schoolID = self.schoolID,let user_id = self.userID {
              self.viewModel.updateLeaveApproval(userID:String(user_id) , status: 3, school_id: schoolID)
            }
            
          }))
          self.present(alert, animated: true, completion: nil)
        case .superadmin:
          guard let type = UserTypeTitle(rawValue: segmentView.selectedSegmentTitle), let userType = UserType(rawValue: type.id) else {
            return
          }
          
          selectedUserType = userType
          
          let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Reject ?", preferredStyle: UIAlertController.Style.actionSheet)
          
          alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            action in
          }))
          
          alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: {
            action in
            
            self.userID = self.leaveApprovalViewArray[sender.tag].id
            if let schoolID = self.schoolID,let user_id = self.userID {
              self.viewModel.updateLeaveApproval(userID:String(user_id) , status: 3, school_id: schoolID)
            }
            
          }))
          self.present(alert, animated: true, completion: nil)
          
        case .admin:
          
          
          
          let multiStudent =  "\(UserManager.shared.currentUser?.permissions?.multiLevelStudentLeaveDays)"
          
          
          
          
          
          let total = "\(totalDays)"
          
          guard let type = UserTypeTitle(rawValue: segmentView.selectedSegmentTitle), let userType = UserType(rawValue: type.id) else {
            return
          }
          
          selectedUserType = userType
          
          let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Reject ?", preferredStyle: UIAlertController.Style.actionSheet)
          
          alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            action in
          }))
          
          alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: {
            action in
            
            self.userID = self.leaveApprovalViewArray[sender.tag].id
            if let schoolID = self.schoolID,let user_id = self.userID {
              self.viewModel.updateLeaveApproval(userID:String(user_id) , status: 3, school_id: schoolID)
            }
            
          }))
          self.present(alert, animated: true, completion: nil)
          
        case .all,.student,.parent:
          break
          
          
        }}}
    
    
    
  }
  
  @IBAction func segmentViewAction(_ sender: CTSegmentControl) {
    print(sender.selectedSegmentTitle)
    
    guard let type = UserTypeTitle(rawValue: sender.selectedSegmentTitle), let userType = UserType(rawValue: type.id) else {
      return
    }
    
    selectedUserType = userType
    if let _schoolID = self.schoolID {
      viewModel.getLeaveApproval(schoolID:_schoolID , userType: selectedUserType.rawValue, searchVal: "", status: "")
    }
    
  }
  func getRequestDate(date : String){
    let dateFormatter = DateFormatter()
    //"10 Feb 2020 00:00 AM"
    dateFormatter.dateFormat = "dd MMM yyyy HH:mm a"
    let convertedDate = dateFormatter.date(from: date)
    
    dateFormatter.dateFormat = "hh"
    if let date1 = convertedDate {
      hours  =  dateFormatter.string(from: date1)
      dateFormatter.dateFormat = "mm"
      mints = dateFormatter.string(from: date1)
      dateFormatter.dateFormat = "a"
      AMPM = dateFormatter.string(from: date1)
    }
  }
  func schoolDropdownAction(){
    let schoolid = UserDefaults.standard.integer(forKey: "sc")
    childDropDown.titleArray = schoolListArray.map({$0.schoolName})
    childDropDown.subtitleArray = schoolListArray.map({$0.location })
    childDropDown.selectionAction = { (index : Int) in
      self.schoolID = self.schoolListArray[index].id
      UserDefaults.standard.set(self.schoolID, forKey: "sc")
      if let _schoolID = self.schoolID {
        switch self.segmentView.selectedSegmentIndex {
        case 0:
          self.viewModel.getLeaveApproval(schoolID: _schoolID, userType: UserType.admin.rawValue, searchVal: "", status: "")
        case 1 :
          self.viewModel.getLeaveApproval(schoolID: _schoolID, userType: UserType.teacher.rawValue, searchVal: "", status: "")
        case 2 :
          self.viewModel.getLeaveApproval(schoolID: _schoolID, userType: UserType.student.rawValue, searchVal: "", status: "")
        default:
          self.viewModel.getLeaveApproval(schoolID: _schoolID, userType: UserType.teacher.rawValue, searchVal: "", status: "")
        }
      }
    }
    if schoolListArray.count > 0 {
      if schoolid != 0 {
        let index = schoolListArray.firstIndex(where: {$0.id == schoolid})
        childDropDown.selectedIndex = index
        
        DispatchQueue.main.async {
          self.childDropDown.nameLabel.text = self.schoolListArray[index ?? 0].schoolName
          self.childDropDown.section.text = self.schoolListArray[index ?? 0].location
        }
      }
    }
  }
  
  
}
//MARK:- TableView
extension LeaveApprovalVC : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return leaveApprovalViewArray.count
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveApprovalCell", for: indexPath) as! LeaveApprovalCell
    cell.selectionStyle = .none
    if leaveApprovalViewArray[indexPath.row].status == 1 {
      cell.acceptRejectSViw.isHidden = false
      cell.showStatusLbl.text = "Pending"
      cell.showStatusLbl.textColor = UIColor.ctPending
    }
    else if leaveApprovalViewArray[indexPath.row].status == 2 {
      cell.acceptRejectSViw.isHidden = true
      cell.showStatusLbl.text = "Approved"
      cell.showStatusLbl.textColor = UIColor.ctApproved
    }else {
      cell.acceptRejectSViw.isHidden = true
      cell.showStatusLbl.text = "Rejected"
      cell.showStatusLbl.textColor = UIColor.ctRejected
    }
    
    if let name = leaveApprovalViewArray[indexPath.row].name {
      cell.nameLabel.text = name
    }
    if let img = leaveApprovalViewArray[indexPath.row].profile{
      if let urlString = img.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
        if let url = URL(string: urlString) {
          cell.profileImageView.sd_setImage(with: url)
        }
      }
    }
    
    if let startDate = leaveApprovalViewArray[indexPath.row].fromDate {
      getYearMonth(date: startDate)
      cell.startDayMonthLabel.text = day + " " + month
      cell.startYearLabel.text = year
    }
    
    if let endDate = leaveApprovalViewArray[indexPath.row].toDate {
      getYearMonth(date: endDate)
      cell.endDayMonthLabel.text = day + " " + month
      cell.endYearLabel.text = year
    }
    if let leaveType = leaveApprovalViewArray[indexPath.row].leaveType {
      cell.leaveTypleLabel.text = leaveType
    }
    if let totDays = leaveApprovalViewArray[indexPath.row].totDays {
      if totDays == 1 {
        cell.noOfDayLabel.text = String(totDays) + " Day"
      }
      else
      {
        cell.noOfDayLabel.text = String(totDays) + " Days"
      }
      
    }
    if let requestDate = leaveApprovalViewArray[indexPath.row].requestedDate {
      getRequestDate(date: requestDate)
      cell.timeLabel.text =  requestDate // hours + ":" + mints + AMPM
    }
    if let status = leaveApprovalViewArray[indexPath.row].status {
      cell.approveBtn.tag = indexPath.row
      cell.rejectBtn.tag = indexPath.row
      cell.approveBtn.addTarget(self, action: #selector(approveBtnAction(_:)), for: .touchUpInside)
      cell.rejectBtn.addTarget(self, action: #selector(rejectBtnAction(_:)), for: .touchUpInside)
      
      
      
    }
    
    if let stuclass = leaveApprovalViewArray[indexPath.row].stuClass{
      cell.classSectionLabel.isHidden = false
      cell.classSectionLabel.text = stuclass
    }
    else
    {
      cell.classSectionLabel.isHidden = true
    }
    if let section = leaveApprovalViewArray[indexPath.row].section{
      if let text = cell.classSectionLabel.text {
        cell.classSectionLabel.isHidden = false
        cell.classSectionLabel.text = text + " ," + section + " Section"
      }
    }
    else
    {
      cell.classSectionLabel.isHidden = true
    }
    
    
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = UIStoryboard.leaveStoryboard().instantiateViewController(withIdentifier:"LeaveApprovalDetailVC") as! LeaveApprovalDetailVC
    vc.leaveApprovalArray = leaveApprovalViewArray[indexPath.row]
    vc.schoolID = self.schoolID
    vc.delegate = self
    // self.totalDays = leaveApprovalViewArray[indexPath.row].totDays
    vc.userID = leaveApprovalViewArray[indexPath.row].id
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}

extension LeaveApprovalVC : leaveApprovalDelegate {
  
  func getLeaveSummaryData(_ leaveSummaryList: [LeaveSummaryDatum]) {
    
  }
  
  
  func getLeaveApprovalSuccess(leaveData: LeaveApprovalModel) {
    
    if let _data = leaveData.data {
      leaveApprovalViewArray = _data
    }
    
    leaveApprovalTableview.reloadData()
    failureMessage = leaveData.message
  }
  
  func updateLeaveApprovalSuccess(message:String) {
    displayServerSuccess(withMessage: message)
    if let _schoolID = self.schoolID {
      
      if  let userType = UserManager.shared.currentUser?.userType {
        if let _type = UserType(rawValue:userType ) {
          
          
          
          switch  _type  {
          
          case .parent,.all,.student:
            break
            
          case .teacher:
            viewModel.getLeaveApproval(schoolID:_schoolID , userType: 6, searchVal: "", status: "")
            
          case .admin,.superadmin:
            viewModel.getLeaveApproval(schoolID:_schoolID , userType: selectedUserType.rawValue, searchVal: "", status: "")
          }
          
        }
        
      }
      
    }
    leaveApprovalTableview.reloadData()
    
    print("success")
  }
  
  func failure(message: String) {
    displayServerError(withMessage: message)
    failureMessage = message
    leaveApprovalViewArray.removeAll()
    leaveApprovalTableview.reloadData()
    
  }
  
  
}
extension LeaveApprovalVC : refreshLeaveApprovalDelegate {
  func refreshLeaveApproval() {
    guard let type = UserTypeTitle(rawValue: segmentView.selectedSegmentTitle), let userType = UserType(rawValue: type.id) else {
      return
    }
    
    selectedUserType = userType
    if let _schoolID = self.schoolID {
      
      if  let userType = UserManager.shared.currentUser?.userType {
        if let _type = UserType(rawValue:userType ) {
          
          
          
          switch  _type  {
          
          case .parent,.all,.student:
            break
            
          case .teacher:
            viewModel.getLeaveApproval(schoolID:_schoolID , userType: 6, searchVal: "", status: "")
            
          case .admin,.superadmin:
            viewModel.getLeaveApproval(schoolID:_schoolID , userType: selectedUserType.rawValue, searchVal: "", status: "")
          }
          
        }
        
      }
      
      
    }
  }
}

extension LeaveApprovalVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
  
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    var message = "No Records Available!"
    
    if let _failureMessage = failureMessage {
      message = _failureMessage
    }
    
    return message.formatErrorMessage()
  }
}

extension LeaveApprovalVC: filterLeaveDelegate{
  
  func filterLeaveSelected(searchVal: String, Status: String) {
    print("Cancelled Filter View Selected")
    self.removeCustomFilter()
    if let schoolID = self.schoolID{
      
      if UserManager.shared.currentUser?.userTypeName == "teacher" {
        viewModel.getLeaveApproval(schoolID: schoolID, userType: 6, searchVal: searchVal, status: Status)
        
      }
      else{
        viewModel.getLeaveApproval(schoolID: schoolID, userType: selectedUserType.rawValue, searchVal: searchVal, status: Status)
        
      }
    }
  }
  
  
  func addFilterViewInstance(){
    customLeaveFilterObj = Constants.shared.getLeaveFilterInstance()
    customLeaveFilterObj.delegate = self
  }
  
  func cancelFilter() {
    print("Cancelled Filter View")
    self.removeCustomFilter()
  }
  
  func addCustomLeaveFilterSelect() {
    
    self.customLeaveFilterObj.modalPresentationStyle = .overCurrentContext
    self.navigationController?.present(self.customLeaveFilterObj, animated: true, completion: nil)
    
  }
  
  func removeCustomFilter(){
    if customLeaveFilterObj != nil{
      self.dismiss(animated: true, completion: nil)
    }
  }
}
