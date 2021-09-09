//
//  LeaveApprovalFilterViewController.swift
//  Kinder Care
//
//  Created by CIPL0590 on 9/22/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol filterLeaveDelegate: class {
    func cancelFilter()
    func filterLeaveSelected(searchVal: String, Status: String)
}

class LeaveApprovalFilterViewController: BaseViewController {

    @IBOutlet weak var pendingCheck: BEMCheckBox!
    @IBOutlet weak var approvedCheck: BEMCheckBox!
    @IBOutlet weak var rejectedCheck: BEMCheckBox!
    @IBOutlet weak var searchTxtFld: CTTextField!
    
    @IBOutlet weak var mainView: UIView!
    var delegate:filterLeaveDelegate? = nil
    var userTypeData:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      userTypeData = "0"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        mainView.roundCorners([.topLeft, .topRight], radius: 30)
    }
    
    @IBAction func pendingAct(_ sender: Any) {
        pendingCheck.on = true
        approvedCheck.on = false
        rejectedCheck.on = false
        
        userTypeData = "1"
    }
    
    @IBAction func approvedAct(_ sender: Any) {
        pendingCheck.on = false
        approvedCheck.on = true
        rejectedCheck.on = false
        userTypeData = "2"
    }
    
    @IBAction func rejectedAct(_ sender: Any) {
        pendingCheck.on = false
        approvedCheck.on = false
        rejectedCheck.on = true
        userTypeData = "3"
    }
    
    @IBAction func applyAct(_ sender: Any) {
        
        if self.delegate != nil,let _searchVal = self.searchTxtFld.text,let _status = self.userTypeData{
            
            self.delegate?.filterLeaveSelected(searchVal: _searchVal, Status: _status)
            

        }
        
    }
    @IBAction func cancelBtn(_ sender: Any) {
        
        if self.delegate != nil{
                   
                   self.delegate?.cancelFilter()
               }
        
    }
    

}
//case pending = 1
//   case approved = 2
//   case rejected = 3
