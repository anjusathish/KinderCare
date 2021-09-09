//
//  CompOffDetailsViewController.swift
//  Kinder Care
//
//  Created by PraveenKumar R on 19/03/21.
//  Copyright © 2021 Athiban Ragunathan. All rights reserved.
//

import UIKit

protocol RefreshCompOffApplicationDelegate {
  func refreshCompOffApplication()
}

class CompOffDetailsViewController: BaseViewController {
  
  
  @IBOutlet weak var labelCreatedDate: UILabel!
  @IBOutlet weak var labelCompoffDate: UILabel!
  @IBOutlet weak var labelReason: UILabel!
  @IBOutlet weak var labelContactNumber: UILabel!
  @IBOutlet weak var labelUpdatedBy: UILabel!
  @IBOutlet weak var labelCompOffUsedDate: UILabel!
  @IBOutlet weak var labelCompOffStatus: UILabel!
  
  @IBOutlet weak var classValueView: UIView!
  @IBOutlet weak var classView: UIView!
  
  @IBOutlet weak var bottomAcceptRejectViw: CTView!
  
  public var compOffListArray: CompOffListDatum?
  
  lazy var viewModel: CompOffViewModel = {
    return CompOffViewModel()
  }()
  
  var delegate: AddCompOffSucessDelegate?
  
  //MARK:- ViewController LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    titleString = "COMP OFF STATUS"
    viewModel.delegate = self
    setupUI()
  }
  
  func setupUI() {
    labelCreatedDate.text = compOffListArray?.createdAt
    labelCompoffDate.text = compOffListArray?.applyDate
    labelReason.text = compOffListArray?.reason
    labelContactNumber.text = compOffListArray?.contact
    // labelUpdatedBy.text = compOffListArray?.updatedAt
    //  labelCompOffStatus.text = compOffListArray?.status
    
    
    if let leaveStatus = compOffListArray?.status{
      
      if let _status = leaveStatusType(rawValue: leaveStatus){
        switch _status {
        case .pending:
          labelCompOffStatus.text = "Pending"
          labelCompOffStatus.textColor = UIColor.ctPending
        case .approved:
          labelCompOffStatus.text = "Approved"
          labelCompOffStatus.textColor = UIColor.ctApproved
        case .rejected:
          labelCompOffStatus.text = "Rejected"
          labelCompOffStatus.textColor = UIColor.ctRejected
        }
      }
    }
  }
  
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
      
      if let requestID = self.compOffListArray?.id{
        
        self.viewModel.deleteCompOffRequest(requestID)
      }
      
    }))
    self.present(alert, animated: true, completion: nil)
    
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

//MARK:- CompOffApplicationDelegate Methodes

extension CompOffDetailsViewController: CompOffApplicationDelegate {
  
  func updateCompOffApprovalSuccess(message: String) {
    
  }
  
  
  func getLeaveApprovalSuccess(_ compOffApprovalListData: [CompOffApporvalDatum]) {
    
  }
  
  
  func leaveApplicationSuccess(_ compOffApplicationList: [CompOffListDatum]) {
    
  }
  
  func addCompOffRequestSuccess(_ message: String) {
    
  }
  
  func deleteLeaveRequestSuccess() {
    
    delegate?.addcompoffSucessMessage(true)
    displayServerError(withMessage: "The Requested CompOff Is Deleted")
    self.navigationController?.popViewController(animated: true)
  }
  
  func failure(message: String) {
    
  }
  
  
}
