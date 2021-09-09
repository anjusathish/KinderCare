//
//  FilterVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 15/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol filterDelegate: class {
    func cancelFilter()
    func filterSelected(requestStatus: String, requestFromDate: String, requestToDate: String)
}

enum requestLeaveStatusType : String{
    case pending = "PENDING"
    case approved = "APPROVED"
    case rejected = "REJECTED"
}

class FilterVC: BaseViewController {
    
    @IBOutlet var statusTableView: UITableView!
    @IBOutlet weak var txtFromDate: CTTextField!
    @IBOutlet weak var txtTillDate: CTTextField!
    
    //MARK:- Initialization
    @IBOutlet weak var mainView: UIView!
    var strSelected = ""
    var delegate:filterDelegate? = nil
    var image:UIImage?
    var statusButtonArray = ["False","True","False","False"]
    var statusLabelArray = ["PENDING","APPROVED","REJECTED"]
    var selectedLabel: String?
    var selectedPicker  = ""
    var startDate   = ""
    var selectedDate:Date?
    var selectedLeaveType = ""
    var selectedRequestStatus: String?
    var fromDateSelected: Date?
    var fromDate:String?
    var toDate:String?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusTableView.delegate = self
        self.statusTableView.dataSource = self
        self.statusTableView.register(UINib(nibName: "LeaveFilterTableViewCell", bundle: nil), forCellReuseIdentifier: "LeaveFilterTableViewCell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
             self.statusTableView.reloadData()
        }
    }
    override func viewDidLayoutSubviews() {
        mainView.roundCorners([.topLeft, .topRight], radius: 30)
    }
    
    //MARK:- Button Action
    @IBAction func cancelAction(_ sender: Any) {
        
        if self.delegate != nil{
            
            self.delegate?.cancelFilter()
        }
    }
    
    @IBAction func applyAction(_ sender: Any) {
        if self.delegate != nil, let selectedRequest = selectedRequestStatus {
            
            self.delegate?.filterSelected(requestStatus: selectedRequest, requestFromDate: self.fromDate ?? "", requestToDate: self.toDate ?? "")
        }
            
        else if self.delegate != nil, let fromDate = self.fromDate,let toDate = self.toDate {
            
            self.delegate?.filterSelected(requestStatus: selectedRequestStatus ?? "", requestFromDate: fromDate, requestToDate: toDate)
        }
            
        else{
            displayServerError(withMessage: "Kindly filter either by status or by date")
        }
        
    }
    
    @objc func sectionRoomAction(sender:BEMCheckBox){
        selectedLeaveType = statusLabelArray[sender.tag]
        if let _status = requestLeaveStatusType(rawValue: statusLabelArray[sender.tag]){
            
            switch _status {
                
            case .pending: selectedRequestStatus = "1"
                
                
            case .approved: selectedRequestStatus = "2"
                
            case .rejected: selectedRequestStatus = "3"
                
            }
        }
        self.statusTableView.reloadData()
        
    }
    
}

//MARK:- UITableViewDataSource,UITableViewDelegate Methodes

extension FilterVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveFilterTableViewCell", for: indexPath) as! LeaveFilterTableViewCell
        cell.selectionStyle = .none
        cell.statusLabel.text  = statusLabelArray[indexPath.row]
        cell.selectedCheckBox.addTarget(self, action: #selector(sectionRoomAction(sender:)), for: .valueChanged)
        cell.selectedCheckBox.tag = indexPath.row
        
        if(statusLabelArray[indexPath.row] == selectedLeaveType){
            
            cell.selectedCheckBox.on = true
        }
        else{
            
            cell.selectedCheckBox.on = false
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusLabelArray.count
    }
}

//MARK:- UITextFieldDelegate Methodes

extension FilterVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (range.location == 0 && string == " ") {
            return false;
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFromDate {
            
            let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
            txtTillDate.text = ""
            picker.dismissBlock = { date in
                self.selectedDate = date
                self.fromDateSelected = date
                self.txtFromDate.text = date.asString(withFormat: "dd-MM-yyyy")
                self.fromDate = date.asString(withFormat: "yyyy-MM-dd")
            }
            return false
        }
            
        else if textField == txtTillDate {
            
            let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
            picker.timePicker.minimumDate = fromDateSelected
            picker.dismissBlock = { date in
                self.selectedDate = date
                self.txtTillDate.text = date.asString(withFormat: "dd-MM-yyyy")
                self.toDate = date.asString(withFormat: "yyyy-MM-dd")
            }
            return false
        }
        return true
    }
    
}
