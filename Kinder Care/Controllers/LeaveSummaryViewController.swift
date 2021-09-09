//
//  LeaveSummaryViewController.swift
//  Kinder Care
//
//  Created by PraveenKumar R on 22/03/21.
//  Copyright © 2021 Athiban Ragunathan. All rights reserved.
//

import UIKit

class LeaveSummaryViewController: BaseViewController {
  
  @IBOutlet weak var tableviewLeaveSummary: UITableView!
  
  lazy var viewModel : LeaveApprovalViewModel   =  {
    return LeaveApprovalViewModel()
  }()
  
  private var arrayLeaveSummary: [LeaveSummaryDatum] = []
  
  //MARK:- ViewController LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    titleString = "LEAVE SUMMARY"
    viewModel.delegate = self
    viewModel.getLeaveSummaryList()
    
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

//MARK:-
extension LeaveSummaryViewController: UITableViewDataSource,UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return arrayLeaveSummary.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveSummaryCell", for: indexPath) as! LeaveSummaryTableViewCell
    cell.selectionStyle = .none
    let modelData = arrayLeaveSummary[indexPath.row]
    cell.labelLeaveType.text = modelData.leaveType
    cell.labelActualLeaveCount.text = "\(modelData.allowedCount)"
    cell.labelAppliedLeaveCount.text = "\(modelData.appliedCount)"
    cell.labelLeaveBalance.text = "\(modelData.balanceCount)"
    return cell
    
  }
  
}

//MARK:- leaveApprovalDelegate Methods
extension LeaveSummaryViewController: leaveApprovalDelegate {
  
  func getLeaveApprovalSuccess(leaveData: LeaveApprovalModel) {
    
  }
  
  func updateLeaveApprovalSuccess(message: String) {
    
  }
  
  func getLeaveSummaryData(_ leaveSummaryList: [LeaveSummaryDatum]) {
    arrayLeaveSummary = leaveSummaryList
    tableviewLeaveSummary.reloadData()
  }
  
  func failure(message: String) {
    self.displayServerError(withMessage: message)
  }
  
}
