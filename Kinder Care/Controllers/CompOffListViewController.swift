//
//  CompOffListViewController.swift
//  Kinder Care
//
//  Created by CIPL0419 on 17/03/21.
//  Copyright © 2021 Athiban Ragunathan. All rights reserved.
//

import UIKit

class CompOffListViewController: BaseViewController {
  
  lazy var viewModel : CompOffViewModel = {
    return CompOffViewModel()
  }()
  
  private var arrayCompOffList: [CompOffListDatum] = []
  var customFilterObj : FilterVC!
  
  
  @IBOutlet weak var tableviewCompOffList: UITableView! {
    
    didSet{
      
      tableviewCompOffList.register(UINib(nibName: "CompOffListTableViewCell", bundle: nil), forCellReuseIdentifier: "CompOffListTableViewCell")
    }
  }
  @IBOutlet weak var childDropDown: ChildDropDown!
  
  var day: String = ""
  var year: String = ""
  var month: String = ""
  var hours:String = ""
  var mints:String = ""
  var AMPM:String = ""
  
  var checkResetButton:Bool? = false
  
  //MARK:- ViewController LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    titleString = "COMP OFF"
    self.addFilterViewInstance()
    viewModel.delegate = self
    viewModel.viewLeaveList(leaveReqId: "")
  }
  
  
  
  //MARK:- UIButton Action Methodes
  @IBAction func buttonAddCompOffrequestButtonAction(_ sender: Any) {
    performSegue(withIdentifier: "PushAddCompOff", sender: nil)
  }
  
  @IBAction func filterAction(_ sender: Any) {
    self.addCustomFilterSelect()
  }
  
  @IBAction func buttonClickToResetAction(_ sender: Any) {
    if checkResetButton == true {
      
      customFilterObj.selectedLeaveType = ""
      customFilterObj.txtFromDate.text = ""
      customFilterObj.txtTillDate.text  = ""
    }
    
    viewModel.viewLeaveList(leaveReqId: "")
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "PushCompOffListVC" {
      
      if let vc = segue.destination as? CompOffDetailsViewController {
        
        if let indexPath = sender as? NSIndexPath {
          vc.compOffListArray = arrayCompOffList[indexPath.row]
          vc.delegate = self
        }
      }
      
    }else{
      if let vc = segue.destination as? RequestCompOffViewController {
        vc.delegate = self
      }
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
  
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}

//MARK:- Filter Custom Delegate
extension CompOffListViewController: filterDelegate{
  
  func filterSelected(requestStatus: String, requestFromDate: String, requestToDate: String) {
    checkResetButton = true
    print("Cancelled Filter View Selected")
    self.removeCustomFilter()
    
    viewModel.filterCompOffRequest(requestStatus: requestStatus, requestFromDate: requestFromDate, requestToDate: requestToDate, applyLeave: "0")
    
    
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

extension CompOffListViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrayCompOffList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CompOffListTableViewCell", for: indexPath) as! CompOffListTableViewCell
    cell.selectionStyle = .none
    let modeldata = arrayCompOffList[indexPath.row]
    cell.labelReason.text = modeldata.reason
    
    if let status = modeldata.status{
      
      let _status = ApprovalStatus(rawValue: status)
      
      switch _status{
      case .pending:
        cell.btnStatus.setTitle(ApprovalStatus.pending.statusString, for: .normal)
        cell.btnStatus.backgroundColor = UIColor.ctPending
        
      case .approved:
        cell.btnStatus.setTitle(ApprovalStatus.approved.statusString, for: .normal)
        cell.btnStatus.backgroundColor = UIColor.ctApproved
        
      case .rejected:
        cell.btnStatus.setTitle(ApprovalStatus.rejected.statusString, for: .normal)
        cell.btnStatus.backgroundColor = UIColor.ctRejected
        
      default: break
      }
    }
    
    
    
      getYearMonth(date:  modeldata.applyDate)
      cell.labelAppliateDateDayMonth.text = day + " " + month
      cell.labelAppliateDateYear.text = year
    
    
    if let creaitDate = modeldata.createdAt {
      getYearMonth(date: creaitDate)
      cell.labelCreaitDateDayMonth.text = day + " " + month
      cell.labelCreaitDateYear.text = year
    }
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "PushCompOffListVC", sender: indexPath)
  }
  
}

//MARK:- CompOffApplicationDelegate Methodes
extension CompOffListViewController: CompOffApplicationDelegate {
  
  func updateCompOffApprovalSuccess(message: String) {
    
  }
  
  
  func getLeaveApprovalSuccess(_ compOffApprovalListData: [CompOffApporvalDatum]) {
    
  }
  
  
  func deleteLeaveRequestSuccess() {
  }
  
  func addCompOffRequestSuccess(_ message: String) {
  }
  
  func leaveApplicationSuccess(_ compOffApplicationList: [CompOffListDatum]) {
    print(compOffApplicationList)
    arrayCompOffList = compOffApplicationList
    tableviewCompOffList.reloadData()
  }
  
  func failure(message: String) {
    print(message)
    arrayCompOffList.removeAll()
    displayServerError(withMessage: "\(message)")
    tableviewCompOffList.reloadData()
  }
  
}

extension CompOffListViewController: AddCompOffSucessDelegate {
  
  func addcompoffSucessMessage(_ isSucess: Bool) {
    viewModel.delegate = self
    viewModel.viewLeaveList(leaveReqId: "")
    
  }
  
}
