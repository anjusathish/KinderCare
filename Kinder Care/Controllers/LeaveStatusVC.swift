//
//  LeaveStatusVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 13/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

protocol refreshLeaveApplicationDelegate {
    func refreshLeaveApplication()
}

enum leaveStatusType : Int{
    case pending = 1
    case approved = 2
    case rejected = 3
}

class LeaveStatusVC: BaseViewController {
    
    //MARK:- Initialization
  
  
    
    @IBOutlet weak var lblLeaveDays: UILabel!
    @IBOutlet weak var lblLeaveFromDate: UILabel!
    @IBOutlet weak var lblLeaveTillDate: UILabel!
    @IBOutlet weak var lblLeaveType: UILabel!
    @IBOutlet weak var lblReasonLeave: UILabel!
    @IBOutlet weak var lblEmergencyContact: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    var leaveListArray : LeaveApplicationList?
    var leaveId : Int?
    var delegate : refreshLeaveApplicationDelegate?
    var viewLeaveArray = [LeaveApprovalList]()
    
    lazy var viewModel : LeaveApplicationViewModel = {
        return LeaveApplicationViewModel()
    }()
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleString = "LEAVE STATUS"
        viewModel.delegate = self
        getLeaveStatus()
        if let id = leaveListArray?.id{
            viewModel.viewLeaveList(leaveReqId: "\(id)")
        }
        
        
    }
    
    func getLeaveStatus(){
        
        if let leaveDays = leaveListArray?.leaveDays{
            lblLeaveDays.text = "\(leaveDays)"
        }

      lblLeaveFromDate.text = leaveListArray?.fromDate
      lblLeaveTillDate.text = leaveListArray?.toDate
      lblLeaveFromDate.text = leaveListArray?.convertFromDate(currentFormate: DateFormatType.type1.rawValue, toFormate: DateFormatType.type3.rawValue)
      lblLeaveTillDate.text = leaveListArray?.convertToDate(currentFormate: DateFormatType.type1.rawValue, toFormate: DateFormatType.type3.rawValue)

        
        if let leaveType = leaveListArray?.leaveType{
            lblLeaveType.text = leaveType
        }
        
        if let contact = leaveListArray?.contact{
            lblEmergencyContact.text = contact
        }
        
        
        
        if let leaveStatus = leaveListArray?.status{
            
            if let _status = leaveStatusType(rawValue: leaveStatus){
                switch _status {
                case .pending:
                    lblStatus.text = "Pending"
                    lblStatus.textColor = UIColor.ctPending
                case .approved:
                    lblStatus.text = "Approved"
                    lblStatus.textColor = UIColor.ctApproved
                case .rejected:
                    lblStatus.text = "Rejected"
                    lblStatus.textColor = UIColor.ctRejected
                }
            }
        }
    }
    
    //MARK:- Local Methods
    
    //MARK:- Button Action
    @IBAction func deleteAction(_ sender: Any) {
        
        alert()
    }
    
    private func alert(){
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete the request ?", preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            action in
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
            action in
            
            if let leaveRequestID = self.leaveListArray?.id{
                
                self.viewModel.deleteLeaveRequest(leaveRequestID)
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

//MARK:- LeaveApplication Delegate Methodes
extension LeaveStatusVC: leaveApplicationDelegate {
  
  func filterCompOffListData(leaveApplication: [CompOffListDatum]) {
    
  }
  
    func leaveTypeSuccess(leaveType: [LeaveTypeList]) {
        
    }
    
    func viewLeaveDataSuccess(viewLeave: [LeaveApprovalList]) {
        
        self.viewLeaveArray  = viewLeave
        if let reason = viewLeaveArray[0].reason{
            lblReasonLeave.text = reason
        }
        
    }
    
    func leaveApplicationSuccess(leaveApplication: LeaveApplicationModel) {
        
    }
    
    
    func filterLeaveListData(leaveApplication: [LeaveApplicationList]) {
        
    }
    
    
    
    
    func addLeaveSuccess() {
        
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
    }
    
    func deleteLeaveRequestSuccess() {
        delegate?.refreshLeaveApplication()
        displayServerError(withMessage: "The Requested Leave Is Deleted")
        self.navigationController?.popViewController(animated: true)
    }
    
}
