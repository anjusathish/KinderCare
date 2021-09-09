//
//  LeaveListVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 13/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

enum ApprovalStatus : Int{
  case pending = 1
  case approved = 2
  case rejected = 3
  
  var statusString : String {
    switch self {
    case .pending: return "Pending"
    case .approved: return "Approved"
    case .rejected: return "Rejected"
    }
  }
  
  var statusColor : UIColor {
    switch self {
    case .pending: return .pendingColor
    case .approved: return .approvedColor
    case .rejected: return .rejectColor
    }
  }
}

protocol addLeaveListDelegate{
  func addLeave()
}

class LeaveListVC: BaseViewController {
  
  // MARK: - Initialization
  @IBOutlet weak var tblLeave: UITableView!
  @IBOutlet weak var topConstarint: NSLayoutConstraint!
  @IBOutlet weak var childDropDown: ChildDropDown!
  
  var arrLeave = ["Pending","Approved","Rejected"]
  var customFilterObj : FilterVC!
  var requestId : Int?
  var leaveApplicationArray : [LeaveApplicationList] = []
  var delegate : addLeaveListDelegate?
  var childNameArray = [ChildName]()
  var childNameID:Int?
  var checkResetButton:Bool? = false
  lazy var viewModel : LeaveApplicationViewModel = {
    return LeaveApplicationViewModel()
  }()
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let childName = UserManager.shared.childNameList {
      childNameArray = childName
      self.childNameID = childNameArray.map({$0.id}).first
    }
    else{
      
      
    }
    
    viewModel.delegate = self
    configDataSetUp()
    UIConfig()
  }
  @IBAction func resetButton(_ sender: Any) {
    
    if checkResetButton == true {
      
      customFilterObj.selectedLeaveType = ""
      customFilterObj.txtFromDate.text = ""
      customFilterObj.txtTillDate.text  = ""
    }
    
    
    if let childID =  self.childNameID {
      
      viewModel.filterLeaveRequest(requestStatus: "", requestFromDate: "", requestToDate: "", student_id: "\(childID)")
    }
    else{
      viewModel.filterLeaveRequest(requestStatus: "", requestFromDate: "", requestToDate: "", student_id: "")
    }
    
    
  }
  
  func configDataSetUp(){
    
    if  let userType = UserManager.shared.currentUser?.userType {
      if let _type = UserType(rawValue:userType ) {
        
        switch _type {
        case .parent:
          
          topBarHeight = 100
          titleString = "LEAVE STATUS"
          childDropDown.isHidden  = false
          self.childDropdownAction()
          if let childID =  self.childNameID {
            
            viewModel.filterLeaveRequest(requestStatus: "", requestFromDate: "", requestToDate: "", student_id: "\(childID)")
          }
          
          break
          
        case .teacher,.admin :
          
          titleString = "LEAVE APPLICATION"
          childDropDown.isHidden  = true
          topConstarint.constant = 0
          viewModel.leaveListApplication()
          break
          
        default:
          break
        }
      }
    }
    
  }
  
  func childDropdownAction(){
    
    self.view.bringSubviewToFront(childDropDown)
    childDropDown.titleArray = childNameArray.map({$0.name})
    childDropDown.subtitleArray = childNameArray.map({$0.className + " , " + $0.section + " Section"})
    if childNameArray.count > 1 {
      childDropDown.selectionAction = { (index : Int) in
        print(index)
        self.childNameID = self.childNameArray[index].id
        
        if let childID =  self.childNameID {
          
          self.viewModel.filterLeaveRequest(requestStatus: "", requestFromDate: "", requestToDate: "", student_id: "\(childID)")
        }
        
      }}
    else{
      childDropDown.isUserInteractionEnabled = false
    }
    
    childDropDown.addChildAction = { (sender : UIButton) in
      let vc = UIStoryboard.FamilyInformationStoryboard().instantiateViewController(withIdentifier:"AddChildVC") as! AddChildVC
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  // MARK: - Local Methods
  func UIConfig(){
    self.addFilterViewInstance()
    tblLeave.delegate = self
    tblLeave.dataSource = self
    tblLeave.tableFooterView = UIView()
    tblLeave.register(UINib(nibName: "LeaveListCell", bundle: nil), forCellReuseIdentifier: "LeaveListCell")
  }
  
  // MARK:- Button Action
  @IBAction func filterAction(_ sender: Any) {
    self.addCustomFilterSelect()
  }
  
  @IBAction func addLeaveAction(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Leave", bundle: nil)
    let nextVC = storyboard.instantiateViewController(withIdentifier: "RequestLeaveVC") as! RequestLeaveVC
    nextVC.delegate = self
    nextVC.studentID = self.childNameID
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
}


// MARK: - Delegate Methods
extension LeaveListVC: UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //  return self.arrLeave.count
    return leaveApplicationArray.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell:LeaveListCell = tableView.dequeueReusableCell(withIdentifier: "LeaveListCell", for: indexPath) as! LeaveListCell
    
    let leaveList = leaveApplicationArray[indexPath.row]
    
    if leaveList.leaveDays == 0{
      cell.lblDays.text = String(leaveList.leaveDays)
    }
    else if leaveList.leaveDays == 1{
      cell.lblDays.text = String(leaveList.leaveDays) + " " + "Day"
    }
    else{
      cell.lblDays.text = String(leaveList.leaveDays) + " " + "Days"
    }
    
    cell.lblStartDate.text = leaveList.fromDate
    cell.lblEndDate.text = leaveList.toDate
    cell.lblLeaveType.text = leaveList.leaveType
    cell.lblStartDate.text = leaveList.convertFromDate(currentFormate: DateFormatType.type1.rawValue, toFormate: DateFormatType.type2.rawValue)
    cell.lblEndDate.text = leaveList.convertToDate(currentFormate: DateFormatType.type1.rawValue, toFormate: DateFormatType.type2.rawValue)
    cell.lblStartYear.text = leaveList.convertFromDate(currentFormate: DateFormatType.type1.rawValue, toFormate: DateFormatType.type4.rawValue)
    cell.lblEndYear.text = leaveList.convertFromDate(currentFormate: DateFormatType.type1.rawValue, toFormate: DateFormatType.type4.rawValue)
    
    if let status = leaveApplicationArray[indexPath.row].status{
      
      let _status = ApprovalStatus(rawValue: status)
      
      switch _status{
      case .pending:
        cell.btnStatus.setTitle("Pending", for: .normal)
        cell.vwStatusView.backgroundColor = UIColor.pendingColor.withAlphaComponent(0.15)
        cell.btnStatus.backgroundColor = UIColor.ctPending
        
      case .approved:
        cell.btnStatus.setTitle("Approved", for: .normal)
        cell.vwStatusView.backgroundColor = UIColor.approvedColor.withAlphaComponent(0.15)
        cell.btnStatus.backgroundColor = UIColor.ctApproved
        
      case .rejected:
        cell.btnStatus.setTitle("Rejected", for: .normal)
        cell.vwStatusView.backgroundColor = UIColor.rejectColor.withAlphaComponent(0.15)
        cell.btnStatus.backgroundColor = UIColor.ctRejected
        
      default: break
      }
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let storyboard = UIStoryboard(name: "Leave", bundle: nil)
    let nextVC = storyboard.instantiateViewController(withIdentifier: "LeaveStatusVC") as! LeaveStatusVC
    nextVC.delegate = self
    nextVC.leaveListArray = leaveApplicationArray[indexPath.row]
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
}

//MARK :- Color Extension
extension UIColor{
  //Leave Status Color
  static var pendingColor = UIColor(hex: 0xF39C12, alpha: 1.0)
  static var rejectColor = UIColor(hex: 0xE74C3C, alpha: 1.0)
  static var approvedColor = UIColor(hex: 0x2ECC71, alpha: 1.0)
  
  static var appColor = UIColor(hex: 0x4F3DB9, alpha: 1.0)
}

//MARK:- Filter Custom Delegate
extension LeaveListVC: filterDelegate{
  
  func filterSelected(requestStatus: String, requestFromDate: String, requestToDate: String) {
    checkResetButton = true
    print("Cancelled Filter View Selected")
    self.removeCustomFilter()
    
    viewModel.filterLeaveRequest(requestStatus: requestStatus, requestFromDate: requestFromDate, requestToDate: requestToDate, student_id: "\(self.childNameID ?? 0)")
    
  }
  
  
  func addFilterViewInstance(){
    customFilterObj = Constants.shared.getFilterInstance()
    customFilterObj.delegate = self
  }
  
  func cancelFilter() {
    print("Cancelled Filter View")
    self.removeCustomFilter()
  }
  
  func addCustomFilterSelect() {
    
    self.customFilterObj.modalPresentationStyle = .overCurrentContext
    self.navigationController?.present(self.customFilterObj, animated: true, completion: nil)
    
  }
  
  func removeCustomFilter(){
    if customFilterObj != nil{
      self.dismiss(animated: true, completion: nil)
    }
  }
}
//MARK:- leaveApplicationDelegate Methodes
extension LeaveListVC: leaveApplicationDelegate {
  
  func filterCompOffListData(leaveApplication: [CompOffListDatum]) {
    
  }
  
  
  func leaveTypeSuccess(leaveType: [LeaveTypeList]) {
    
  }
  
  func viewLeaveDataSuccess(viewLeave: [LeaveApprovalList]) {
    
  }
  func leaveApplicationSuccess(leaveApplication: LeaveApplicationModel) {
    
    if let data = leaveApplication.data{
      leaveApplicationArray = data
    }
    self.requestId = leaveApplication.data?.first?.id
    
    self.tblLeave.reloadData()
  }
  
  
  func filterLeaveListData(leaveApplication: [LeaveApplicationList]) {
    
    leaveApplicationArray = leaveApplication
    self.requestId = leaveApplication.first?.id
    self.tblLeave.reloadData()
  }
  
  func deleteLeaveRequestSuccess() {
    
  }
  
  func addLeaveSuccess() {
    delegate?.addLeave()
  }
  
  func failure(message: String) {
    displayServerError(withMessage: "\(message)")
  }
}

//MARK:- RefreshLeaveApplication Delegate Methodes
extension LeaveListVC : refreshLeaveApplicationDelegate {
  
  func refreshLeaveApplication() {
    if  let userType = UserManager.shared.currentUser?.userType {
      if let _type = UserType(rawValue:userType ) {
        
        switch _type {
        
        case .parent:
          if let childID =  self.childNameID {
            
            viewModel.filterLeaveRequest(requestStatus: "", requestFromDate: "", requestToDate: "", student_id: "\(childID)")
          }
          break
          
        case .teacher,.admin,.superadmin,.student,.all:
          viewModel.leaveListApplication()
          break
        }
      }
    }
  }
}

//MARK:- RefreshLeaveRequest Delegate Methodes
extension LeaveListVC : refreshLeaveRequestDelegate{
  func refreshLeaveRequest() {
    
    if  let userType = UserManager.shared.currentUser?.userType {
      if let _type = UserType(rawValue:userType ) {
        
        switch _type {
        
        case .parent:
          if let childID =  self.childNameID {
            
            viewModel.filterLeaveRequest(requestStatus: "", requestFromDate: "", requestToDate: "", student_id: "\(childID)")
          }
          break
          
        case .teacher,.admin,.superadmin,.student,.all:
          viewModel.leaveListApplication()
          break
        }
      }
    }
  }
}
