//
//  SalaryFilterVC.swift
//  Kinder Care
//
//  Created by CIPL0681 on 03/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import DropDown
import BEMCheckBox


protocol salaryFilterTableViewDelegate{
    func salaryFilterTableView(UserType:Int,fromDate:String,toDate:String)
}

class SalaryFilterVC: BaseViewController {
    
    @IBOutlet weak var fromDateTxtFld: CTTextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var toDateTxtFld: CTTextField!
    @IBOutlet weak var teacherCheckBox: BEMCheckBox!
    @IBOutlet weak var adminCheckBox: BEMCheckBox!
    var delegate:salaryFilterTableViewDelegate?
    var userTypeId:Int?
    var fromDate:String?
    var toDate:String?
    var selectedDate:Date?
    var fromDateSelected: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _fromDate = fromDate,let _toDate = toDate{
            
            fromDateTxtFld.text = _fromDate.getDateAsStringWith(inFormat: "yyyy-MM-dd", outFormat: "dd-MM-yyyy")
            toDateTxtFld.text = _toDate.getDateAsStringWith(inFormat: "yyyy-MM-dd", outFormat: "dd-MM-yyyy")
        }
        
        teacherCheckBox.on = true
        userTypeId = UserType.teacher.rawValue
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
            print(item)
            
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
    
    override func viewDidLayoutSubviews() {
        contentView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
    }
    @IBAction func applyAction(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportsViewController") as! ReportsViewController
        if let userType = userTypeId,let fromDate = fromDate,let toDate = toDate {
            
            self.delegate?.salaryFilterTableView(UserType: userType, fromDate: fromDate, toDate: toDate)
            self.dismiss(animated: true, completion: nil)
        }
        else{
            displayServerError(withMessage: "Please Select Types")
        }
        
        
        
        
    }
    @IBAction func teacherCheckAction(_ sender: Any) {
        
        userTypeId = UserTypeTitle.teacher.id
        adminCheckBox.on = false
    }
    
    @IBAction func adminCheckbox(_ sender: Any) {
        userTypeId = UserTypeTitle.admin.id
        teacherCheckBox.on = false
    }
}

extension SalaryFilterVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == fromDateTxtFld   {
            
            let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
            toDateTxtFld.text = ""
            picker.dismissBlock = { date in
                self.selectedDate = date
                self.fromDateSelected = date
                self.fromDateTxtFld.text = date.asString(withFormat: "dd-MM-yyyy")
                self.fromDate = date.asString(withFormat: "yyyy-MM-dd")
            }
            return false
            
        }
        
        if textField == toDateTxtFld   {
            
            let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
            picker.timePicker.minimumDate = fromDateSelected
            picker.dismissBlock = { date in
                self.selectedDate = date
                self.toDateTxtFld.text = date.asString(withFormat: "dd-MM-yyyy")
                self.toDate = date.asString(withFormat: "yyyy-MM-dd")
            }
            return false
        }
        
        return true
    }
}




