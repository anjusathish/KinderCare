//
//  PickUpPersonDetailViewController.swift
//  Kinder Care
//
//  Created by CIPL0590 on 12/4/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

protocol refreshPickUpDataDelegate {
    func refreshPickUpList()
}

class PickUpPersonDetailViewController: BaseViewController {
    
    @IBOutlet weak var childNameLbl: UILabel!
    @IBOutlet weak var classLbl: UILabel!
    @IBOutlet weak var fatherLbl: UILabel!
    @IBOutlet weak var motherLbl: UILabel!
    @IBOutlet weak var pickUpPersonLbl: UILabel!
    @IBOutlet weak var relationLbl: UILabel!
    @IBOutlet weak var mobileNoLbl: UILabel!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var approveBtn: UIButton!
    @IBOutlet weak var approveRejectUiViw: CTView!
    
    var pickupList:PickUpList?
    var listID:Int?
    var delegate : refreshPickUpDataDelegate?
    
    lazy var viewModel : PickUpPersonViewModel = {
        return PickUpPersonViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        self.titleString = "PICKUP PERSON DETAIL"
        self.pickUpDetails()
        self.statusButton()
    }
    
    func  statusButton(){
        
        if let status = approvalStatus(rawValue: pickupList!.approvalStatus){
            
            switch status {
                
            case .pending:
                approveBtn.isHidden = false
                rejectBtn.isHidden = false
                approveRejectUiViw.isHidden = false
                
            case .approved:
                approveBtn.isHidden = true
                rejectBtn.isHidden = true
                approveRejectUiViw.isHidden = true
                
            case .rejected:
                approveBtn.isHidden = true
                rejectBtn.isHidden = true
                approveRejectUiViw.isHidden = true
                
                
            }
        }
    }
    
    func pickUpDetails(){
        
        self.childNameLbl.text = pickupList?.name
       
        self.fatherLbl.text = pickupList?.fathername
        self.motherLbl.text = pickupList?.mothername
        self.pickUpPersonLbl.text = pickupList?.pickupPersonName
        self.relationLbl.text = pickupList?.relationType
        self.mobileNoLbl.text = pickupList?.contactNumber
        if let className = pickupList?.datumClass,let section = pickupList?.section{
            self.classLbl.text = className + ", " + section
            
        }
    }
    
    @IBAction func rejectBtn(_ sender: Any) {
        if let id = self.listID{
            viewModel.PickUpPersonStatus(status: "rejected", listId: "\(id)")
        }
        
    }
    
    @IBAction func approveBtn(_ sender: Any) {
        if let id = self.listID{
            viewModel.PickUpPersonStatus(status: "approved", listId: "\(id)")
        }
        
    }
    
}

extension PickUpPersonDetailViewController:PickUpPersonDelegate {
   
    
    
    func pickUpStatus(message: String) {
        self.displayServerSuccess(withMessage: message)
        self.delegate?.refreshPickUpList()
        self.navigationController?.popViewController(animated: true)
    }
    
    func PickUpPersonList(PickUp: [PickUpList]) {
        
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
    }
    
    
}

