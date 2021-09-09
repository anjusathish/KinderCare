//
//  RequestCompOffViewController.swift
//  Kinder Care
//
//  Created by PraveenKumar R on 18/03/21.
//  Copyright © 2021 Athiban Ragunathan. All rights reserved.
//

import UIKit

protocol AddCompOffSucessDelegate {
  func addcompoffSucessMessage(_ isSucess: Bool)
}

class RequestCompOffViewController: BaseViewController {
  
  @IBOutlet weak var txtFieldCompoffDate: CTTextField!
  @IBOutlet weak var textViewReason: UITextView!
  @IBOutlet weak var txtFieldContact: CTTextField!
  var delegate: AddCompOffSucessDelegate?
  
  lazy var viewModel : CompOffViewModel = {
    return CompOffViewModel()
  }()
  var compOffDate:String?
  var selectedDate:Date?
  var fromDateSelected: Date?
  
  //MARK:- ViewController LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    titleString = "ADD COMP OFF"
    viewModel.delegate = self
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
  @IBAction func applyButtonAction(sender: UIButton){
    
    guard let _compOffDate = compOffDate,
          !_compOffDate.removeWhiteSpace().isEmpty else {
      displayError(withMessage: .leaveFromDate)
      return
    }
    
    guard let reasonforLeave = textViewReason.text, !reasonforLeave.removeWhiteSpace().isEmpty else {
      displayError(withMessage: .reasonforleave)
      return
    }
    guard let contactNumber = txtFieldContact.text, !contactNumber.removeWhiteSpace().isEmpty else {
      displayError(withMessage: .invalidMobileNumber)
      return
    }
    
    viewModel.addCompOffRequest(_compOffDate, contactNumber, reasonforLeave)
  }
  
  @IBAction func cancelButtonAction(sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  
}

extension RequestCompOffViewController: CompOffApplicationDelegate {
  
  func updateCompOffApprovalSuccess(message: String) {
    
  }
  
  
  func getLeaveApprovalSuccess(_ compOffApprovalListData: [CompOffApporvalDatum]) {
    
  }
  
  func deleteLeaveRequestSuccess() {
    
  }
  
  func leaveApplicationSuccess(_ compOffApplicationList: [CompOffListDatum]) {
    print("")
  }
  
  func addCompOffRequestSuccess(_ message: String) {
    print(message)
    delegate?.addcompoffSucessMessage(true)
    displayServerError(withMessage: "CompOff Request Added successfully")
    self.navigationController?.popViewController(animated: true)
    
  }
  
  func failure(message: String) {
    print(message)
    self.displayServerError(withMessage: message)
    //delegate?.addcompoffSucessMessage(false)
  }
  
}

extension RequestCompOffViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    if textField == txtFieldCompoffDate {
      
      let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
      fromDateSelected = Date()
      picker.timePicker.maximumDate = fromDateSelected
      picker.dismissBlock = { date in
        self.selectedDate = date
        self.txtFieldCompoffDate.text = date.asString(withFormat: "dd-MM-yyyy")
        self.compOffDate = date.asString(withFormat: "yyyy-MM-dd")
        
      }
      
      return false
    }
    return true
  }
}
