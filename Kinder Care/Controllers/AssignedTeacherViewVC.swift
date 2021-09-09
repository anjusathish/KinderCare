//
//  AssignedTeacherViewVC.swift
//  Kinder Care
//
//  Created by CIPL0590 on 7/1/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit

class AssignedTeacherViewVC: BaseViewController {
    
    @IBOutlet weak var AssignedViewTableView: UITableView!
    
    @IBOutlet weak var dateTxtFld: CTTextField!
    var assignedTeacherViewArray = [viewHealth]()
    var id:Int?
    var selectedDate:Date?
    var fromDate:String?
    var fromDateSelected:Date?
    lazy var viewModel : ProfileViewModel   =  {
        return ProfileViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleString = "VIEW HEALTH STATUS"
        viewModel.delegate = self
        
        

        
//        if let _fromDate = fromDate{
//
//            dateTxtFld.text = _fromDate.getDateAsStringWith(inFormat: "yyyy-MM-dd", outFormat: "dd-MM-yyyy")
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//
//
//
//        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var result = formatter.string(from: date)
        fromDateSelected = formatter.date(from:result)!
        fromDate = result
        dateTxtFld.text = result.getDateAsStringWith(inFormat: "yyyy-MM-dd", outFormat: "dd-MM-yyyy")

        
        if let id = self.id,let date = fromDate{
            viewModel.viewHealthStatus(id: "\(id)", date: date)
        }
    }
    
    
    
    
}
extension AssignedTeacherViewVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignedTeacherViewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignedTableViewCell", for: indexPath as IndexPath) as! AssignedTableViewCell
        cell.teacher1StLbl.text = "Temperature"
        cell.teacherLbl.text = "\(assignedTeacherViewArray[indexPath.row].temp)"
        cell.email2Lbl.text = "Santizer Used"
        if assignedTeacherViewArray[indexPath.row].santizer == 0 {
            cell.emailLbl.text = "No"
            cell.emailLbl.textColor = UIColor.ctRejected
        }
        else{
            cell.emailLbl.text = "Yes"
            cell.emailLbl.textColor = UIColor.ctGrgeen
        }
        cell.contact3rdLbl.text = "Date & Time"
        cell.contactLbl.text =  assignedTeacherViewArray[indexPath.row].createdAt
        return cell
    }
    
    
}
extension AssignedTeacherViewVC : UITextFieldDelegate {

func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    if textField == dateTxtFld   {
        
        let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
       picker.timePicker.maximumDate = fromDateSelected
        picker.dismissBlock = { date in
            self.selectedDate = date
            self.dateTxtFld.text = date.asString(withFormat: "dd-MM-yyyy")
            
            self.fromDate = date.asString(withFormat: "yyyy-MM-dd")
             if let id = self.id{
            self.viewModel.viewHealthStatus(id: "\(id)", date: self.fromDate ?? "")
            }
        }
        return false
        
    }
    return true
    }
    
}
extension AssignedTeacherViewVC:profileDelegate{
    func healthViewSuccess(viewHealth: [viewHealth]) {
        assignedTeacherViewArray = viewHealth
        AssignedViewTableView.reloadData()
    }
    
    func getProfileData(profileData: ProfileData) {
        
    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
    
    func editProfileData(message: String) {
        
    }
    
    func changePasswordSuccessfully(message: String) {
        
    }
    
    func healthStatusListSuccess(listHealth: [ListHelath]) {
        
    }
    
    func healthAddSuccuess(message: String) {
        
    }
    
    func healthDeleteSuccess(message: String) {
        
    }
    
    
}
