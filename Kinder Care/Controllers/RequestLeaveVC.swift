//
//  RequestLeaveVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 13/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import DropDown

protocol refreshLeaveRequestDelegate {
  func refreshLeaveRequest()
}

enum DropDownTypes : Int{
  case leavedays = 0
  case leavetype = 1
  case compOffDate = 3
}

enum LeaveType : String{
  
  case casualLeave = "Casual Leave"
  case sickLeave = "Sick Leave"
  case lop = "Lop"
  
  
}

class RequestLeaveVC: BaseViewController {
  
  //MARK:- Initialization
  @IBOutlet weak var txtLeaveDays: CTTextField!
  @IBOutlet weak var txtFromDate: CTTextField!
  @IBOutlet weak var txtEndDate: CTTextField!
  @IBOutlet weak var txtLeaveType: CTTextField!
  @IBOutlet weak var twReason: UITextView!
  @IBOutlet weak var txtContact: CTTextField!
  @IBOutlet weak var labelLeaveFromeDate: UILabel!
  @IBOutlet weak var labelLeaveTillDate: UILabel!
  
  //Custom Picker Instance variable
  var customPickerObj : CustomPicker!
  var selectedPicker  = ""
  var startDate   = ""
  var compOffID = "0"
  var leaveDaysArray = ["One Day","More than one day"]
  var leaveTypeArray = ["Sick Leave","Casual Leave","Lop"]
  var schoolListArray : [SchoolListData] = []
  var schoolId : Int?
  var leaveDays : Int?
  var delegate: refreshLeaveRequestDelegate?
  var selectedDate:Date?
  var studentID:Int?
  var fromDateSelected: Date?
  var fromDate:String?
  var toDate:String?
  var leaveTypeID:String?
  var leaveTypeNameArray:[LeaveTypeList] = []
  
  
  var compOffListDateArray: [CompOffListDatum] = []
  
  lazy var viewModel : LeaveApplicationViewModel = {
    return LeaveApplicationViewModel()
  }()
  
  //MARK:- View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleString = "REQUEST LEAVE"
    viewModel.delegate = self
    viewModel.leaveTypeList()
    if let schoolData = UserManager.shared.schoolList {
      schoolListArray = schoolData
      self.schoolId = schoolListArray.map({$0.id}).first
    }
    else if let schoolID  = UserManager.shared.currentUser?.school_id {
      self.schoolId = schoolID
    }
    
  }
  
  func showDropDown(sender : UITextField, content : [String]) {
    
    let dropDown = DropDown()
    dropDown.direction = .any
    // The view to which the drop down will appear on
    dropDown.anchorView = sender // UIView or UIBarButtonItem
    dropDown.dismissMode = .automatic
    // The list of items to display. Can be changed dynamically
    dropDown.dataSource = content
    
    dropDown.selectionAction = { (index: Int, item: String) in
      sender.text = item
      
      if let selectedDropDown = DropDownTypes(rawValue: sender.tag){
        
        switch selectedDropDown{
        
        case .leavedays:
          self.txtLeaveDays.text = item
          
        case .leavetype:
          self.txtLeaveType.text = item
          
          if item == "Comp Off" {
            
            self.labelLeaveFromeDate.text = "CompOff Date"
            self.labelLeaveTillDate.text = "Apply Date"
            self.txtFromDate.text = ""
            self.txtEndDate.text = ""
            
          }else {
            self.labelLeaveFromeDate.text = "Leave From"
            self.labelLeaveTillDate.text = "Leave Till"
          }
          
        case .compOffDate:
          
          if let getcompOFFID = self.compOffListDateArray.filter({$0.applyDate == item}).map({$0.id}).first {
            
            if let _compOffID = getcompOFFID {
              self.compOffID = "\(_compOffID)"
            }
          }
          
          let convertDate = item.getDate(inFormat: "yyyy-MM-dd")
          self.txtFromDate.text = convertDate.asString(withFormat: "dd-MM-yyyy") //date.asString(withFormat: "dd-MM-yyyy")
          self.fromDate = convertDate.asString(withFormat: "yyyy-MM-dd")
          self.fromDateSelected = convertDate
        }
      }
      
      if sender == self.txtLeaveType {
        self.leaveTypeID = String(self.leaveTypeNameArray[index].id)
        if let data = self.leaveTypeID {
          self.leaveTypeID = data
        }
        
        
      }
    }
    
    // Will set a custom width instead of the anchor view width
    dropDown.width = sender.frame.width
    dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
    dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
    
    if let visibleDropdown = DropDown.VisibleDropDown {
      visibleDropdown.dataSource = content
    }
    else {
      dropDown.show()
    }
  }
  
  //MARK:- Button Action
  @IBAction func cancelAction(sender: UIButton){
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func ApproveAction(sender: UIButton){
    
    guard let leaveFrom = fromDate,
          !leaveFrom.removeWhiteSpace().isEmpty else {
      displayError(withMessage: .leaveFromDate)
      return
    }
    
    guard let leaveTo = toDate,
          !leaveTo.removeWhiteSpace().isEmpty else {
      displayError(withMessage: .leaveToDate)
      return
    }
    
    guard let leaveType = txtLeaveType.text, !leaveType.removeWhiteSpace().isEmpty else {
      displayError(withMessage: .leaveType)
      return
    }
    
    guard let reasonforLeave = twReason.text, !reasonforLeave.removeWhiteSpace().isEmpty else {
      displayError(withMessage: .reasonforleave)
      return
    }
    
    //        if let contactNumber = txtContact.text{
    //         // contactNumber.removeWhiteSpace().isIndianPhoneNumber()
    //            contactNumber.count >= 10
    //        }else {
    //            displayError(withMessage: .invalidMobileNumber)
    //
    //        }
    
    guard let strleaveType = leaveTypeID
    else {
      displayError(withMessage: .leaveType)
      return
      
    }
    
    //        var strleaveType = ""
    //
    //        if let _leaveType = LeaveType(rawValue:leaveType){
    //
    //            switch _leaveType {
    //            case .casualLeave: strleaveType = "2"
    //            case .sickLeave: strleaveType = "1"
    //            case .lop: strleaveType = "3"
    //            }
    //        }
    
    if let _schoolId = schoolId{
      
      if  let userType = UserManager.shared.currentUser?.userType {
        if let _type = UserType(rawValue:userType ) {
          
          switch _type {
          
          case .admin:
            if leaveType == "Comp Off" {
              
              viewModel.addLeave(school_id: _schoolId, from_date: leaveTo, to_date: leaveTo, leave_type: strleaveType, reason: twReason.text, contact: txtContact.text ?? "", student_id: "", compoffID: compOffID)
              
            }else{
              viewModel.addLeave(school_id: _schoolId, from_date: leaveFrom, to_date: leaveTo, leave_type: strleaveType, reason: twReason.text, contact: txtContact.text ?? "", student_id: "", compoffID: compOffID)
            }
         
          case .parent:
            if let studentID = self.studentID,let fromDate = self.fromDate,let toDate = self.toDate {
              
              viewModel.addLeave(school_id: _schoolId, from_date: fromDate, to_date: toDate, leave_type: strleaveType, reason: twReason.text, contact: txtContact.text ?? "", student_id: "\(studentID)", compoffID: compOffID)
              
            }
            break
            
          case .teacher:
            if let fromDate = self.fromDate,let toDate = self.toDate{
              
              viewModel.addLeave(school_id: _schoolId, from_date: fromDate, to_date: toDate, leave_type: strleaveType, reason: twReason.text, contact: txtContact.text ?? "", student_id: "", compoffID: compOffID)
            }
            
            break
            
          case .superadmin,.student,.all:
            break
            
            
          }
          
        }
        
      }
    }
  }
}

extension RequestLeaveVC : UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    // get the current text, or use an empty string if that failed
    let currentText = textField.text ?? ""
    
    // attempt to read the range they are trying to change, or exit if we can't
    guard let stringRange = Range(range, in: currentText) else { return false }
    
    // add their new text to the existing text
    let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
    
    // make sure the result is under 16 characters
    return updatedText.count <= 10
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if [txtLeaveDays].contains(textField) {
      
      showDropDown(sender: textField, content: leaveDaysArray)
      
      return false
    }
    else if [txtLeaveType].contains(textField){
      showDropDown(sender: textField, content:leaveTypeNameArray.map({$0.leaveTypeName ?? ""}))
      //showDropDown(sender: textField, content: leaveTypeNameArray)
      
      return false
    }else if textField == txtFromDate {
      
   //   self.txtLeaveType.text = item
      if txtLeaveType.text != "Comp Off" {
        
        let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
        txtEndDate.text = ""
        picker.dismissBlock = { date in
          self.selectedDate = date
          self.fromDateSelected = date
          self.txtFromDate.text = date.asString(withFormat: "dd-MM-yyyy")
          self.fromDate = date.asString(withFormat: "yyyy-MM-dd")
          
        }
        
      }else{
        viewModel.viewCompOffDateList()
      }
      return false
    }
    else if textField == txtEndDate {
      
      if txtLeaveType.text != "Comp Off" {
        
        let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
        
        picker.timePicker.minimumDate = fromDateSelected
        picker.dismissBlock = { date in
          self.selectedDate = date
          self.txtEndDate.text = date.asString(withFormat: "dd-MM-yyyy")
          self.toDate = date.asString(withFormat: "yyyy-MM-dd")
          
        }
        
      }else{
        let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
        
       // picker.timePicker.maximumDate = fromDateSelected
        picker.dismissBlock = { date in
          self.selectedDate = date
          self.txtEndDate.text = date.asString(withFormat: "dd-MM-yyyy")
          self.toDate = date.asString(withFormat: "yyyy-MM-dd")
          
        }
      }
      
      return false
    }
    return true
  }
}

extension RequestLeaveVC : leaveApplicationDelegate{
  
  func filterCompOffListData(leaveApplication: [CompOffListDatum]) {
    
    compOffListDateArray = leaveApplication
    
    let applyCompOffDate = leaveApplication.map({$0.applyDate})
    
    showDropDown(sender: txtFromDate, content: applyCompOffDate)
    
    
  }
  
  func leaveTypeSuccess(leaveType: [LeaveTypeList]) {
    leaveTypeNameArray = leaveType
    print(leaveTypeNameArray)
  }
  
  func viewLeaveDataSuccess(viewLeave: [LeaveApprovalList]) {
    
  }
  
  func leaveApplicationSuccess(leaveApplication: LeaveApplicationModel) {
    
  }
  
  
  func filterLeaveListData(leaveApplication: [LeaveApplicationList]) {
    
  }
  
  
  func deleteLeaveRequestSuccess() {
    
  }
  
  
  func addLeaveSuccess() {
    
    delegate?.refreshLeaveRequest()
    displayServerError(withMessage: "Leave Request Added successfully")
    self.navigationController?.popViewController(animated: true)
  }
  func failure(message: String) {
    displayServerError(withMessage: message)
    
  }
}
