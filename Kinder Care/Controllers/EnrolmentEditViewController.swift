//
//  EnrolmentEditViewController.swift
//  Kinder Care
//
//  Created by CIPL0590 on 12/4/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import DropDown

class EnrolmentEditViewController: BaseViewController {
    
    @IBOutlet weak var txtChildName: CTTextField!
    @IBOutlet weak var txtChildAge: CTTextField!
    @IBOutlet weak var txtDateofBirth: CTTextField!
    @IBOutlet weak var txtClass: CTTextField!
    @IBOutlet weak var txtFatherName: CTTextField!
    @IBOutlet weak var txtMotherName: CTTextField!
    @IBOutlet weak var txtContactNumber: CTTextField!
    @IBOutlet weak var txtMailId: CTTextField!
    @IBOutlet weak var txtPurpose: CTTextField!
    @IBOutlet weak var txtStatus: CTTextField!
    
    var editEnrolment:EnrolmentList?
    var classArray = [ClassModel]()
    var purposeArray = ["Admission Enquire","Leave"]
    var statusArray = ["Active","Inactive"]
    var customPickerObj : CustomPicker!
    var schoolId:Int?
    var delegate:refreshTableViewDelegate?
    var status:Int?
    var classID:Int?
    var isEditEnrolment:Bool = false
    
    lazy var viewModel : enrolmentEnquiryViewModel = {
        return enrolmentEnquiryViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        self.titleString = "ENROLMENT ENQUIRY"
        createCustomPickerInstance()
        
        if let schoolId = UserManager.shared.currentUser?.school_id{
            viewModel.classNameList(schoolId: "\(schoolId)")
        }
        
        if let userType = UserManager.shared.currentUser?.userType {
            
            if let _type = UserType(rawValue:userType ) {
                
                switch _type {
                    
                    
                case .parent,.teacher,.superadmin,.all,.student: break
                    
                    
                case .admin:
                    
                    self.schoolId = UserManager.shared.currentUser?.school_id
                    editData()
                }
            }
        }
        
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        guard let studentName = txtChildName.text, !studentName.removeWhiteSpace().isEmpty else {
            displayError(withMessage: .validChildName)
            return
        }
        guard let age = txtChildAge.text,
            !age.removeWhiteSpace().isEmpty else {
                displayError(withMessage: .age)
                return
        }
        guard let dob = txtDateofBirth.text,
            !dob.removeWhiteSpace().isEmpty else {
                displayError(withMessage: .dob)
                return
        }
        
        guard let className = txtClass.text,
            !className.removeWhiteSpace().isEmpty else {
                displayError(withMessage: .className)
                return
        }
        
        guard let fatherName = txtFatherName.text,
            !fatherName.removeWhiteSpace().isEmpty else {
                displayError(withMessage: .fatherName)
                return
        }
        
        guard let motherName = txtMotherName.text,
            !motherName.removeWhiteSpace().isEmpty else {
                displayError(withMessage: .motherName)
                return
        }
        
        guard let contactNumber = txtContactNumber.text,contactNumber.removeWhiteSpace().isIndianPhoneNumber(), contactNumber.count >= 10 else {
            displayError(withMessage: .invalidMobileNumber)
            return
        }
        
        guard let email = txtMailId.text, email.removeWhiteSpace().isValidEmail()else {
            displayError(withMessage: .invalidEmail)
            return
        }
        
        
        if txtStatus.text == "Active"{
            status = 1
        }
        else {
            status = 0
        }
        
        
        
        if let institute_id = UserManager.shared.currentUser?.instituteID,let schoolId = self.schoolId,let purpose = self.txtPurpose.text,let _status  =  status{
            
            if let userType = UserManager.shared.currentUser?.userType {
                
                if let _type = UserType(rawValue:userType ) {
                    
                    switch _type {
                        
                    case .parent: break
                    case .teacher: break
                    case .admin:
                        if isEditEnrolment {
                            if  let listID = editEnrolment?.id{
                                viewModel.enrolmentEdit(listId: listID, institute_id: "\(institute_id)", school_id: "\(schoolId)", student_name: studentName, age: age, dob: dob, class1: className, father_name: fatherName, mother_name: motherName, contact: contactNumber, email: email, purpose: purpose, status: "\(_status)")
                            }}
                        else
                        {
                            viewModel.enrolmentAdd(institute_id: institute_id, school_id: schoolId, student_name: studentName, age: Int(age) ?? 0, dob: dob, class1: className, father_name: fatherName, mother_name: motherName, contact: contactNumber, email: email, purpose: purpose, status: _status)
                        }
                    case .superadmin:
                        viewModel.enrolmentAdd(institute_id: institute_id, school_id: schoolId, student_name: studentName, age: Int(age) ?? 0, dob: dob, class1: className, father_name: fatherName, mother_name: motherName, contact: contactNumber, email: email, purpose: purpose, status: _status)
                        
                    case .all:break
                    case .student:break
                        
                    }
                }
                
            }
            
            
        }
        
        
        
    }
    func showDropDown(sender : UITextField, content : [String]) {
        
        let dropDown = DropDown()
        dropDown.direction = .any
        dropDown.anchorView = sender // UIView or UIBarButtonItem
        dropDown.dismissMode = .automatic
        dropDown.dataSource = content
        
        dropDown.selectionAction = { (index: Int, item: String) in
            
            sender.text = item
            if sender == self.txtClass{
                self.classID = self.classArray[index].id
            }
            
            print(item)
        }
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
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func editData(){
        
        txtChildName.text = editEnrolment?.studentName
        if let age = editEnrolment?.age,let status = editEnrolment?.status{
            txtChildAge.text = "\(age)"
            txtStatus.text = "\(status)"
        }
        
        txtClass.text = editEnrolment?.listClass
        txtMailId.text = editEnrolment?.email
        txtFatherName.text = editEnrolment?.fatherName
        txtMotherName.text = editEnrolment?.motherName
        txtPurpose.text = editEnrolment?.purpose
        txtContactNumber.text = editEnrolment?.contact
        txtDateofBirth.text = editEnrolment?.dob
        
        
    }
    
}

extension EnrolmentEditViewController :UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtClass{
            showDropDown(sender: textField, content:classArray.map({$0.className}))
            
            return false
        }
        else if textField == txtPurpose {
            showDropDown(sender: textField, content: purposeArray)
            return false
        }
        else if textField == txtStatus {
            showDropDown(sender: textField, content: statusArray)
            return false
        }
        else if textField == txtDateofBirth {
            self.dateOfBirthAction()
            return false
        }
        
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
    
    
    
    
}
extension EnrolmentEditViewController:CustomPickerDelegate{
    
    func createCustomPickerInstance(){
        customPickerObj = Constants.shared.getCustomPickerInstance()
        customPickerObj.delegate = self
    }
    
    func listOfCompany(listData : [String]){
        
        customPickerObj.totalComponents = 1
        customPickerObj.arrayComponent = listData
        addCustomPicker()
        
        customPickerObj.loadCustomPicker(pickerType: CustomPickerType.e_PickerType_String)
        customPickerObj.customPicker.reloadAllComponents()
    }
    
    func addCustomPicker() {
        self.view.addSubview(customPickerObj.view)
        self.customPickerObj.vwBaseView.frame.size.height = self.view.frame.size.height
        self.customPickerObj.vwBaseView.frame.size.width = self.view.frame.size.width
    }
    
    func removeCustomPicker(){
        if customPickerObj != nil{
            customPickerObj.view.removeFromSuperview()
        }
    }
    
    func itemPicked(item: AnyObject) {
        let pickerDateValue = item as! Date
        let dateFormatObj = DateFormatter()
        dateFormatObj.dateFormat = "yyyy-MM-dd"
        dateFormatObj.locale = Locale(identifier: "en-US")
        let strDate =  dateFormatObj.string(from: pickerDateValue)
        txtDateofBirth.text = strDate
        removeCustomPicker()
    }
    
    func pickerCancelled(){
        removeCustomPicker()
    }
    
    func dateOfBirthAction(){
        dismissKeyboard()
        addCustomPicker()
        customPickerObj.loadCustomPicker(pickerType: CustomPickerType.e_PickerType_Date)
        var components = DateComponents()
        components.day = 0
        let minDate = Calendar.current.date(byAdding: components, to:  Date())!
        customPickerObj.customDatePicker.maximumDate = minDate
        customPickerObj.customDatePicker.datePickerMode = .date
    }
}

extension EnrolmentEditViewController:enrolmentEnquirytDelegate{
    func getClassNameListSuccess(classList: [ClassModel]) {
        classArray = classList
        
        self.classID = self.classArray.first?.id
        self.txtClass.text = self.classArray.first?.className
    }
    
    
    func enrolmentEditSuccess() {
        
        for item in navigationController?.viewControllers ?? [] {
            
            if item is EnrolmentAddViewController {
                
                item.removeFromParent()
            }
            
        }
        self.delegate?.refreshTableView()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func enrolmentAdd() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnrolmentEnquiryViewController") as! EnrolmentEnquiryViewController
        self.delegate?.refreshTableView()
        self.navigationController?.popViewController(animated: true)
    }
    
    func enrolmentList(enrolmentList: EnquiryListData?) {
        
    }
    
    func entrolmentDelete() {
        
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
    }
    
    
}
