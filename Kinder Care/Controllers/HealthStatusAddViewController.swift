//
//  HealthStatusAddViewController.swift
//  Kinder Care
//
//  Created by CIPL0590 on 6/29/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit
protocol refreshHealthTableViewDelegate{
    func refreshHealthTableView()
}

class HealthStatusAddViewController: BaseViewController {
    
    @IBOutlet weak var tempTxtFld: CTTextField!
    @IBOutlet weak var santYesBtn: UIButton!
    @IBOutlet weak var sanNoBtn: UIButton!
    @IBOutlet weak var timeTxtFld: CTTextField!
    var sanitizerValue:Int?
    var startTime: String = ""
    var delegate:refreshHealthTableViewDelegate?
    
    lazy var viewModel : ProfileViewModel   =  {
        return ProfileViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleString = "ADD HEALTH STATUS"
        sanitizerValue = 1
        viewModel.delegate = self
    
    }
    
    @IBAction func sanYesBtnAction(_ sender: Any) {
        sanitizerValue = 1
        sanNoBtn.setImage(UIImage(named: "unSelectFilter"), for: .normal)
        santYesBtn.setImage(UIImage(named: "selectFilter"), for: .normal)
    }
    
    @IBAction func sanNoBtnAction(_ sender: Any) {
        
        santYesBtn.setImage(UIImage(named: "unSelectFilter"), for: .normal)
        sanNoBtn.setImage(UIImage(named: "selectFilter"), for: .normal)
        
        sanitizerValue = 0
        
        
    }
    
    
    @IBAction func addHealthStatusBtn(_ sender: Any) {
        
        guard let temp = tempTxtFld.text, !temp.removeWhiteSpace().isEmpty else {
            displayError(withMessage: .temperature)
            return
        }
        if startTime == "" {
            displayError(withMessage: ErrorMessage(rawValue: "Please Select Time")!)
        }
        else{
        if let userId = UserManager.shared.currentUser?.userID,let sant = sanitizerValue{
            
            viewModel.healthAddStatus(user_id: userId, temp: "\(temp)", sanitizer: "\(sant)", time:startTime ?? "")
            
        }
        }
    }
    
    
}
extension HealthStatusAddViewController: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == timeTxtFld{
            
            let vc = UIStoryboard.attendanceStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
            
            vc.mode = .time
            
            vc.dismissBlock = { dataObj in
                textField.text = dataObj.getasString(inFormat: "hh:mm a")
                self.startTime = dataObj.getasString(inFormat: "HH:mm")
            }
            present(controllerInSelf: vc)
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
         return updatedText.count <= 5
     }
     
}

extension HealthStatusAddViewController:profileDelegate{
    func healthViewSuccess(viewHealth: [viewHealth]) {
        
    }
    
    func editProfileData(message: String) {
        
    }
    
    func changePasswordSuccessfully(message: String) {
        
    }
    
    func getProfileData(profileData: ProfileData) {
        
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
    }
    
    
    
    func healthStatusListSuccess(listHealth: [ListHelath]) {
        
    }
    
    func healthAddSuccuess(message:String) {
        self.displayServerSuccess(withMessage: "Added Successfully")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HealthStatusListViewController") as! HealthStatusListViewController
        self.delegate?.refreshHealthTableView()
        self.navigationController?.popViewController(animated: true)
    }
    
    func healthDeleteSuccess(message: String) {
        
    }
    
    
    
    
}
