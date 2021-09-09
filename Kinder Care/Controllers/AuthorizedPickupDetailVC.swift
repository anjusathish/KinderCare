//
//  AuthorizedPickupDetailVC.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 14/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import DropDown

protocol refreshAuthorizePickupStatusDelegate{
    func AuthorizePickupStatus()
}


class AuthorizedPickupDetailVC: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet var contactNumberTxt: CTTextField!
    @IBOutlet var relationShipTxt: CTTextField!
    @IBOutlet var pickupPersonNameTxt: CTTextField!
    var pickupDetails:PickupPerson?
    var childNameId:Int?
    var delegate:refreshAuthorizePickupStatusDelegate?
    let relationshipArray = ["Father", "Mother", "Uncle", "Aunty", "GrandFather", "GrandMother"]
    
    lazy var viewModel : familyInformationViewModel = {
        return familyInformationViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleString = "AUTHORIZED PICKUP"
        pickupDetailsdata()
        viewModel.delegate = self
    }
    
    
    func pickupDetailsdata(){
        if let pickupName = pickupDetails?.pickupPerson,let contact =  pickupDetails?.pickupContact,let relation = pickupDetails?.relationship    {
            pickupPersonNameTxt.text = pickupName
            relationShipTxt.text = relation
            contactNumberTxt.text = contact
        }
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        guard let contactNumber = contactNumberTxt.text,contactNumber.removeWhiteSpace().isIndianPhoneNumber(), contactNumber.count >= 10 else {
            displayError(withMessage: .invalidMobileNumber)
            return
        }
        
        guard let pickUpPerson = pickupPersonNameTxt.text, !pickUpPerson.removeWhiteSpace().isEmpty else {
            displayError(withMessage: .invalidName)
            return
        }
        
        
        if let relation = relationShipTxt.text,let childNameId = self.childNameId {
            
            viewModel.editPickUpDetails(pickup_person: pickUpPerson, relationship: relation, pickup_contact: contactNumber, _method: "PUT", pickupId: "\(childNameId)")
            
            
        }
    }
    //MARK:- Textfield Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == relationShipTxt {
            
            showDropDown(sender: relationShipTxt, content: relationshipArray)
            
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
    
    // MARK: - DropDown
    
    func showDropDown(sender : UITextField, content : [String]) {
        
        let dropDown = DropDown()
        dropDown.direction = .any
        dropDown.anchorView = sender // UIView or UIBarButtonItem
        dropDown.dismissMode = .automatic
        dropDown.dataSource = content
        
        dropDown.selectionAction = { (index: Int, item: String) in
            sender.text = item
            
            
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


extension AuthorizedPickupDetailVC:familyInformationDelegate{
    func paymentList(paymentList: [PaymentListData]) {
        
    }
    
    func familyDetailsList(familyDetails: FamilyInformationData?) {
        
    }
    
    func editPickupSuccess() {
        self.delegate?.AuthorizePickupStatus()
        self.navigationController?.popViewController(animated: true)
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
    }
    
    
}
