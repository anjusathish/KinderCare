//
//  LeaveApprovalDetailVC.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 17/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

protocol refreshLeaveApprovalDelegate {
  func refreshLeaveApproval()
}


class LeaveApprovalDetailVC: BaseViewController {
  
  
  
  
  
  @IBOutlet weak var contactLabel: UILabel!
  @IBOutlet weak var leaveReasonLabel: UILabel!
  @IBOutlet weak var leaveTypeLabel: UILabel!
  @IBOutlet weak var leaveTillLabel: UILabel!
  @IBOutlet weak var leaveFromLabel: UILabel!
  @IBOutlet weak var leaveDaysLabel: UILabel!
  @IBOutlet weak var requestDateLabel: UILabel!
  @IBOutlet weak var classLabel: UILabel!
  @IBOutlet weak var stuNameLabel: UILabel!
  
  @IBOutlet weak var classValueView: UIView!
  @IBOutlet weak var classView: UIView!
  
  @IBOutlet weak var bottomAcceptRejectViw: CTView!
  
  
  var leaveApprovalArray: LeaveApprovalList?
  var schoolID : Int?
  
  var day: String = ""
  var year: String = ""
  var month: String = ""
  var hours:String = ""
  var mints:String = ""
  var AMPM:String = ""
  var userID: Int?
  var delegate:refreshLeaveApprovalDelegate?
  
  lazy var viewModel : LeaveApprovalViewModel   =  {
    return LeaveApprovalViewModel()
  }()
  
  override func viewDidLoad() {
    titleString = "LEAVE APPROVAL"
    super.viewDidLoad()
    
    getLeaveDetails()
    self.viewModel.delegate = self
    self.statusButton()
    // Do any additional setup after loading the view.
  }
  
  func getYearMonth(date : String){
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
    let convertedDate = dateFormatter.date(from: date)
    
    dateFormatter.dateFormat = "yyyy"
    if let date1 = convertedDate {
      year  =  dateFormatter.string(from: date1)
      dateFormatter.dateFormat = "MM"
      month = dateFormatter.string(from: date1)
      dateFormatter.dateFormat = "dd"
      day = dateFormatter.string(from: date1)
    }
  }
  
  func getRequestDate(date : String){
    let dateFormatter = DateFormatter()
    //"10 Feb 2020 00:00 AM"
    dateFormatter.dateFormat = "dd MMM yyyy HH:mm a"
    let convertedDate = dateFormatter.date(from: date)
    
    dateFormatter.dateFormat = "yyyy"
    if let date1 = convertedDate {
      year  =  dateFormatter.string(from: date1)
      dateFormatter.dateFormat = "MM"
      month = dateFormatter.string(from: date1)
      dateFormatter.dateFormat = "dd"
      day = dateFormatter.string(from: date1)
    }
  }
  
  func getLeaveDetails(){
    
    if let name = leaveApprovalArray?.name {
      stuNameLabel.text = name
    }
    if let user_id = leaveApprovalArray?.id {
      userID = user_id
    }
    if let startDate = leaveApprovalArray?.fromDate {
      getYearMonth(date: startDate)
      leaveFromLabel.text = day + "/" + month + "/" + year
    }
    if let endDate = leaveApprovalArray?.toDate {
      getYearMonth(date: endDate)
      leaveTillLabel.text = day + "/" + month + "/" + year
    }
    if let leaveType = leaveApprovalArray?.leaveType {
      leaveTypeLabel.text = leaveType
    }
    if let totDays = leaveApprovalArray?.totDays {
      leaveDaysLabel.text = String(totDays)
    }
    if let requestDate = leaveApprovalArray?.requestedDate {
      getRequestDate(date: requestDate)
      requestDateLabel.text = day + "/" + month + "/" + year
    }
    if let reason = leaveApprovalArray?.reason {
      leaveReasonLabel.text = reason
    }
    if let contact = leaveApprovalArray?.contactNo {
      contactLabel.text = contact
    }
    if let stuclass = leaveApprovalArray?.stuClass{
      classView.isHidden = false
      classValueView.isHidden = false
      classLabel.text = stuclass
    }
    else
    {
      classView.isHidden = true
      classValueView.isHidden = true
    }
    if let section = leaveApprovalArray?.section{
      if let text = classLabel.text {
        classView.isHidden = false
        classValueView.isHidden = false
        classLabel.text = text + "," + section + " Section"
      }
    }
    else
    {
      classView.isHidden = true
      classValueView.isHidden = true
    }
  }
  
  func  statusButton(){
    
    let _status = leaveRequestStatus(rawValue:(leaveApprovalArray?.status)!)
    switch  _status {
    
    case .pending:
      
      bottomAcceptRejectViw.isHidden = false
      break
    case .approved:
      
      bottomAcceptRejectViw.isHidden = true
      break
    case .rejected:
      
      bottomAcceptRejectViw.isHidden = true
      break
      
    case .none:
      bottomAcceptRejectViw.isHidden = false
    }
  }
  
  @IBAction func approveBtnAction(_ sender: Any) {
    if let schoolID = self.schoolID,let user_id = self.userID {
      
      viewModel.updateLeaveApproval(userID: String(user_id), status: 2, school_id: schoolID)
    }
  }
  
  @IBAction func rejectBtnAction(_ sender: Any) {
    
    let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Reject ?", preferredStyle: UIAlertController.Style.actionSheet)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
      action in
    }))
    
    alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: {
      action in
      
      if let schoolID = self.schoolID,let user_id = self.userID {
        self.viewModel.updateLeaveApproval(userID:String(user_id) , status: 3, school_id: schoolID)
      }
      
    }))
    self.present(alert, animated: true, completion: nil)
    
    
  }
  
}

extension LeaveApprovalDetailVC: leaveApprovalDelegate {
  
  func getLeaveSummaryData(_ leaveSummaryList: [LeaveSummaryDatum]) {
  }
  
  func getLeaveApprovalSuccess(leaveData: LeaveApprovalModel) {
  }
  
  func updateLeaveApprovalSuccess(message:String) {
    displayServerSuccess(withMessage: message)
    self.delegate?.refreshLeaveApproval()
    self.navigationController?.popViewController(animated: true)
  }
  
  func failure(message: String) {
    displayServerError(withMessage: message)
  }
}
