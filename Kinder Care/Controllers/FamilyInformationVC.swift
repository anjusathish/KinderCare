//
//  FamilyInformationVC.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 13/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class FamilyInformationVC: BaseViewController {
    
    @IBOutlet var familyInfoTableView: UITableView!
    @IBOutlet weak var childDropDown: ChildDropDown!
    
    var childNameArray = [ChildName]()
    var childNameID:Int?
    var familyInformation:FamilyInformationData?
    
    lazy var viewModel : familyInformationViewModel = {
        return familyInformationViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarHeight = 100
        titleString = "FAMILY INFORMATION"
        viewModel.delegate = self
        if let childName = UserManager.shared.childNameList {
            childNameArray = childName
            self.childNameID = childNameArray.map({$0.id}).first
        }
        
        self.familyInfoTableView.register(UINib(nibName: "FamilyInfoHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "FamilyInfoHeaderView")
        
        self.familyInfoTableView.register(UINib(nibName: "FamilyHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "FamilyHeaderView")
        
        self.familyInfoTableView.register(UINib(nibName: "FamilyInfoHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "FamilyInfoHeaderTableViewCell") //Top
        
        self.familyInfoTableView.register(UINib(nibName: "FamilyInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "FamilyInfoTableViewCell") //bottom
        
        
        self.view.bringSubviewToFront(childDropDown)
        childNameDropDown()
        if let childId = childNameID{
            viewModel.familyDetail(student_id: childId)
        }
        
        
        
    }
    
    func childNameDropDown(){
        
        childDropDown.titleArray = childNameArray.map({$0.name})
          childDropDown.subtitleArray = childNameArray.map({$0.className + " , " + $0.section + " Section"})
        
        if childNameArray.count > 1 {
            
        
        
        childDropDown.selectionAction = { (index : Int) in
            print(index)
            self.childNameID = self.childNameArray[index].id
            
            if let childId = self.childNameID {
                self.viewModel.familyDetail(student_id: childId)
            }
            
        }
    }
        else{
            childDropDown.isUserInteractionEnabled = false
        }
        childDropDown.addChildAction = { (sender : UIButton) in
            let vc = UIStoryboard.FamilyInformationStoryboard().instantiateViewController(withIdentifier:"AddChildVC") as! AddChildVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    //MARK:- Button Action
    @objc func editPickupPersonAction(sender : UIButton)
    {
        let vc = UIStoryboard.FamilyInformationStoryboard().instantiateViewController(withIdentifier:"AuthorizedPickupDetailVC") as! AuthorizedPickupDetailVC
        vc.pickupDetails = familyInformation?.pickupPerson
        vc.childNameId = self.childNameID
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}

extension FamilyInformationVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyInfoHeaderTableViewCell", for: indexPath) as! FamilyInfoHeaderTableViewCell
            
            cell.lblFather.text = familyInformation?.familyDetail.fatherName
            cell.lblMother.text = familyInformation?.familyDetail.motherName
            
            if let primaryMail = familyInformation?.familyDetail.primaryEmail {
                cell.lblPrimaryMail.text = primaryMail
            }
             if let secondaryMail = familyInformation?.familyDetail.secondaryEmail{
                cell.lblSecondaryMail.text = secondaryMail
            }
             if let fContact = familyInformation?.familyDetail.fatherContact{
                cell.lblFatherContact.text = fContact
            }
             if let mContact = familyInformation?.familyDetail.motherContact{
                cell.lblMotherContact.text = mContact
            }
             if let address = familyInformation?.familyDetail.address{
                cell.lblAddress.text = address
            }
            return cell
            
            
        }
        
        if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyInfoTableViewCell", for: indexPath) as! FamilyInfoTableViewCell
            cell.pickupNameLbl.text = familyInformation?.pickupPerson.pickupPerson
            cell.relationLbl.text = familyInformation?.pickupPerson.relationship
            cell.contactLbl.text = familyInformation?.pickupPerson.pickupContact
            
            
            if let state = familyInformation?.pickupPerson.status,let status = approvalStatus.init(rawValue: state) {
                cell.statusLbl.text = familyInformation?.pickupPerson.status
               // cell.statusLbl.setTitle(familyInformation?.pickupPerson.status, for: .normal)
                cell.statusLbl.textColor =  status.statusColor
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyInfoTableViewCell", for: indexPath) as! FamilyInfoTableViewCell
            cell.grayStackView.isHidden = true
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 400
        }
        else {
            return 250
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FamilyInfoHeaderView") as! FamilyInfoHeaderView
            headerView.headerSectionTitleLbl.text = "Family Detail"
            headerView.headerSectionEditBtn.isHidden = true
            return headerView
            
        }
            
        else{

            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FamilyHeaderView") as! FamilyHeaderView
            headerView.headerTitleLabel.text = "Authorized Pickup Person"
            headerView.headerEditBtn.isHidden = false
            headerView.headerEditBtn.addTarget(self, action: #selector(editPickupPersonAction(sender:)), for: .touchUpInside)
            return headerView
        }
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 50
        }
        else
        {
            return 50
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}

extension FamilyInformationVC: familyInformationDelegate{
    func paymentList(paymentList: [PaymentListData]) {
        
    }
    
    func editPickupSuccess() {
        
    }
    
    func familyDetailsList(familyDetails: FamilyInformationData?) {
        familyInformation = familyDetails
        self.familyInfoTableView.reloadData()
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
    }
    
    
}

extension FamilyInformationVC:refreshAuthorizePickupStatusDelegate{
    func AuthorizePickupStatus() {
        if let childId = childNameID{
            viewModel.familyDetail(student_id: childId)
        }
    }
    
    
}
