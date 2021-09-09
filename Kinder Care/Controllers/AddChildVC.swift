//
//  AddChildVC.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 20/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation
import UIKit
import DropDown
 
class AddChildVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet var sectionTxt: CTTextField!
    @IBOutlet var classTxt: CTTextField!
    @IBOutlet var genderTxt: CTTextField!
    @IBOutlet var DOBTxt: CTTextField!
    @IBOutlet var childNameTxt: CTTextField!
    @IBOutlet var profileImageView: UIImageView!
    
    var classArray = [ClassModel]()
    var sectionArray = [Section]()
    let genderArray = ["Male", "Female"]
    var selectedDate:Date?
    var classID :Int?
    var sectionID:Int?
    var customPickerObj : CustomPicker!
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
           super.viewDidLoad()
        
        titleString = "ADD CHILD"
         createCustomPickerInstance()
        getClassAndSectionValues()
    }
    
    //MARK:- Button Action
    
    @IBAction func submitBtnAction(_ sender: Any) {
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true
        )
    }
    @IBAction func uploadImageBtnAction(_ sender: Any) {
    }
    
    func getClassAndSectionValues()
       {
           self.classArray = SharedPreferenceManager.shared.classNameListArray
           self.sectionArray = SharedPreferenceManager.shared.sectionArray
        
           self.classID = self.classArray.first?.id
           self.sectionID = self.sectionArray.first?.id
           self.classTxt.text = self.classArray.first?.className
           self.sectionTxt.text = self.sectionArray.first?.section
        print(classTxt.text)
        print(classID)
       }
    
    //MARK:- TextField Delegate
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == genderTxt {
            showDropDown(sender: genderTxt, content: genderArray)
            return false
        }
        else if textField ==  classTxt{
            showDropDown(sender: textField, content: classArray.map({$0.className}))
            return false
        }
        else if textField ==  sectionTxt {
            guard let section = sectionArray.map({$0.section}) as? [String] else { return false}
            showDropDown(sender: textField, content: section)
            return false
        }
        else    if textField == DOBTxt {
            let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
            picker.dismissBlock = { date in
                self.selectedDate = date
                self.DOBTxt.text = date.asString(withFormat: "yyyy-MM-dd")
            }
            return false
        }
        
        return true
    }
    func dismissKeyboard() {
        
        self.view.endEditing(true)
    }
    // MARK: - DropDown
    
    func showDropDown(sender : UITextField, content : [String]) {
        
        
        
        let dropDown = DropDown()
        dropDown.direction = .any
        dropDown.anchorView = sender // UIView or UIBarButtonItem
        dropDown.dismissMode = .automatic
        dropDown.dataSource = content
        
        dropDown.selectionAction = { (index: Int, item: String) in
            sender.text = item
            if sender == self.classTxt {
                self.classID = self.classArray[index].id
            }
            else if sender == self.sectionTxt {
                self.sectionID = self.sectionArray[index].id
               
            }
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
}
//MARK:- CustomPicker Methods
extension AddChildVC :CustomPickerDelegate {
    
    func createCustomPickerInstance(){
        // customPickerObj = Constants.shared.getCustomPickerInstance()
        // customPickerObj.delegate = self
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
        dateFormatObj.dateFormat = "dd/MM/yyyy"
        dateFormatObj.locale = Locale(identifier: "en-US")
        let strDate =  dateFormatObj.string(from: pickerDateValue)
        //DOBTxt.text = strDate
        
        removeCustomPicker()
    }
    
    func pickerCancelled(){
        removeCustomPicker()
    }
    
    
}

