//
//  CompOffApprovalViewController.swift
//  Kinder Care
//
//  Created by PraveenKumar R on 19/03/21.
//  Copyright © 2021 Athiban Ragunathan. All rights reserved.
//

import UIKit

class CompOffApprovalViewController: BaseViewController {
  
  @IBOutlet weak var segmentTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
  @IBOutlet var segmentViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet var segmentStackView: UIStackView!
  @IBOutlet var segmentView: CTSegmentControl!
  
  @IBOutlet weak var compOffApprovalTableview: UITableView!{
    didSet{
      
      compOffApprovalTableview.register(UINib(nibName: "CompOffApprovalTableViewCell", bundle: nil), forCellReuseIdentifier: "CompOffApprovalTableViewCell")
    }
  }
  
  
  var schoolID:Int?
  var schoolListArray = [SchoolListData]()
  var userID:Int?
  var selectedUserType: UserType = .teacher
  var failureMessage:String?
  var totalDays:Int?
  var customLeaveFilterObj : LeaveApprovalFilterViewController!
  
  lazy var viewModel: CompOffViewModel   =  {
    return CompOffViewModel()
  }()
  
  var compOffApprovalViewArray = [CompOffApporvalDatum]()
  
  var day: String = ""
  var year: String = ""
  var month: String = ""
  var hours:String = ""
  var mints:String = ""
  var AMPM:String = ""
  
  //MARK:- ViewController LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    titleString = "COMP OFF APPROVAL"
    
    viewModel.delegate = self
    
    configureUISetUp()

  }
  
  
  func configureUISetUp() {
    
    if  let userType = UserManager.shared.currentUser?.userType {
      
      if let _type = UserType(rawValue:userType ) {
        
        segmentView.segmentTitles = _type.compOffApprovalTitles
        
        switch  _type  {
        case .all,.student : break
          
        case .parent:
          topBarHeight = 90
          segmentView.isHidden = true
          segmentStackView.isHidden = true
          segmentViewHeightConstraint.constant = 0
          
        case .teacher: break
          
          
        case .admin:
          segmentView.isHidden = false
          segmentStackView.isHidden = false
          segmentViewHeightConstraint.constant = 50
          
          if let schoolID = UserManager.shared.currentUser?.school_id {
            self.schoolID = schoolID
            
          }
          
          if let _schoolID = self.schoolID {
            viewModel.getLeaveApproval(schoolID: _schoolID, userType:4, searchVal: "", status: "")
            
          }
          
        case .superadmin:
          
//          if let schoolData = UserManager.shared.schoolList {
//            schoolListArray = schoolData
//            self.schoolID = schoolListArray.first?.id
//          }
          segmentView.isHidden = false
          segmentStackView.isHidden = false
          segmentViewHeightConstraint.constant = 50
          topBarHeight = 100
          
          if let schoolID = UserManager.shared.currentUser?.school_id {
            self.schoolID = schoolID
            
          }
          
          if let _schoolID = self.schoolID {
            viewModel.getLeaveApproval(schoolID: _schoolID, userType:3, searchVal: "", status: "")
            
          }
        //  childDropDown.footerTitle = ""
        
        }
      }
    }
    addFilterViewInstance()
  }
  
  @IBAction func clicktoReset(_ sender: Any) {
    
  }
  
  @IBAction func filterBtn(_ sender: Any) {
    self.addCustomLeaveFilterSelect()
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
  
  //MARK:- UIButton Action Methodes
  @objc func approveBtnAction(_ sender: UIButton) {
    
    if  let userType = UserManager.shared.currentUser?.userType {
      
      if let _type = UserType(rawValue:userType ) {
        
        switch  _type  {
        
        case .parent,.all,.student: break
          
        case .teacher:
          
          self.userID = compOffApprovalViewArray[sender.tag].id
          
          if let user_id = self.userID {
            viewModel.updateLeaveApproval(userID: String(user_id), status: 2)
          }
          
        case .admin:
                   
          self.userID = compOffApprovalViewArray[sender.tag].id
          
          if let user_id = self.userID {
            viewModel.updateLeaveApproval(userID: String(user_id), status: 2)
          }
          
        case .superadmin:
         
          self.userID = compOffApprovalViewArray[sender.tag].id
          
          if let user_id = self.userID {
            viewModel.updateLeaveApproval(userID: String(user_id), status: 2)
          }
        }
      }
    }
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
            
            self.userID = self.compOffApprovalViewArray[sender.tag].id
            if let user_id = self.userID {
              self.viewModel.updateLeaveApproval(userID:String(user_id) , status: 3)
            }
            
          }))
          self.present(alert, animated: true, completion: nil)
          
        case .superadmin:
          
          let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Reject ?", preferredStyle: UIAlertController.Style.actionSheet)
          
          alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            action in
          }))
          
          alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: {
            action in
            
            self.userID = self.compOffApprovalViewArray[sender.tag].id
            if let user_id = self.userID {
              self.viewModel.updateLeaveApproval(userID:String(user_id) , status: 3)
            }
            
          }))
          self.present(alert, animated: true, completion: nil)
          
        case .admin:
          
          let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Reject ?", preferredStyle: UIAlertController.Style.actionSheet)
          
          alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            action in
          }))
          
          alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: {
            action in
            
            self.userID = self.compOffApprovalViewArray[sender.tag].id
            
            if let user_id = self.userID {
              
              self.viewModel.updateLeaveApproval(userID:String(user_id) , status: 3)
            }
            
          }))
          self.present(alert, animated: true, completion: nil)
          
        case .all,.student,.parent: break
        }
      }
    }
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}

//MARK:- UITableViewDataSource,UITableViewDelegate Methodes
extension CompOffApprovalViewController: UITableViewDataSource,UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return compOffApprovalViewArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CompOffApprovalTableViewCell", for: indexPath) as! CompOffApprovalTableViewCell
    cell.selectionStyle = .none
    
    cell.leaveTypleLabel.text = compOffApprovalViewArray[indexPath.row].reason
    if compOffApprovalViewArray[indexPath.row].status == 1 {
      cell.acceptRejectSViw.isHidden = false
      cell.showStatusLbl.text = "Pending"
      cell.showStatusLbl.textColor = UIColor.ctPending
      //cell.leaveTypleLabel.text = "Pending"
    }
    else if compOffApprovalViewArray[indexPath.row].status == 2 {
      cell.acceptRejectSViw.isHidden = true
      cell.showStatusLbl.text = "Approved"
      cell.showStatusLbl.textColor = UIColor.ctApproved
      // cell.leaveTypleLabel.text = "Approved"
    }else {
      cell.acceptRejectSViw.isHidden = true
      cell.showStatusLbl.text = "Rejected"
      cell.showStatusLbl.textColor = UIColor.ctRejected
      // cell.leaveTypleLabel.text = "Rejected"
    }
    
    if let name = compOffApprovalViewArray[indexPath.row].name {
      cell.nameLabel.text = name
    }
    if let img = compOffApprovalViewArray[indexPath.row].profileurl {
      if let urlString = img.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
        if let url = URL(string: urlString) {
          cell.profileImageView.sd_setImage(with: url)
        }
      }
    }
    
    if let startDate = compOffApprovalViewArray[indexPath.row].applyDate {
      getYearMonth(date: startDate)
      cell.lblStartDate.text = day + " " + month
      cell.lblStartYear.text = year
    }
    
    if let endDate = compOffApprovalViewArray[indexPath.row].createdAt {
      getYearMonth(date: endDate)
      cell.lblEndDate.text = day + " " + month
      cell.lblEndYear.text = year
    }
    
    if let requestDate = compOffApprovalViewArray[indexPath.row].createdAt {
      getRequestDate(date: requestDate)
      cell.timeLabel.text =  requestDate // hours + ":" + mints + AMPM
    }
    
    if let _ = compOffApprovalViewArray[indexPath.row].status {
      
      cell.approveBtn.tag = indexPath.row
      cell.rejectBtn.tag = indexPath.row
      cell.approveBtn.addTarget(self, action: #selector(approveBtnAction(_:)), for: .touchUpInside)
      cell.rejectBtn.addTarget(self, action: #selector(rejectBtnAction(_:)), for: .touchUpInside)
      
    }
    
    return cell
  }
  
  
}

//MARK:- filterLeaveDelegate Methodes
extension CompOffApprovalViewController: filterLeaveDelegate {
  
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
  
  func addFilterViewInstance() {
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

//MARK:- CompOffApplicationDelegate Methodes
extension CompOffApprovalViewController: CompOffApplicationDelegate {
  
  func updateCompOffApprovalSuccess(message: String) {
    
    displayServerError(withMessage: message)
    if let schoolID = UserManager.shared.currentUser?.school_id {
      self.schoolID = schoolID
    }
    
    if let _schoolID = self.schoolID {
      viewModel.getLeaveApproval(schoolID: _schoolID, userType: 4, searchVal: "", status: "All")
    }
  }
  
  
  func leaveApplicationSuccess(_ compOffApplicationList: [CompOffListDatum]) {
    
  }
  
  func getLeaveApprovalSuccess(_ compOffApprovalListData: [CompOffApporvalDatum]) {
    compOffApprovalViewArray = compOffApprovalListData
    compOffApprovalTableview.reloadData()
    print(compOffApprovalListData)
  }
  
  func addCompOffRequestSuccess(_ message: String) {
    
  }
  
  func deleteLeaveRequestSuccess() {
    
  }
  
  func failure(message: String) {
    displayServerError(withMessage: message)
  }
  
}
