//
//  PickUpPersonApprovalViewController.swift
//  Kinder Care
//
//  Created by CIPL0590 on 12/4/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import SDWebImage
import DZNEmptyDataSet

enum approvalStatus : String {
    case pending = "pending"
    case approved = "approved"
    case rejected = "rejected"
    
    var statusColor : UIColor {
        switch self {
        case .pending: return .pendingColor
        case .approved: return .approvedColor
        case .rejected: return .rejectColor
        }
    }
}


class PickUpPersonApprovalViewController: BaseViewController {
    
    @IBOutlet weak var tableTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var childDropdown: ChildDropDown!
    @IBOutlet weak var tblViewPickupperson: UITableView!
    var schoolListArray = [SchoolListData]()
    var pickupListArray = [PickUpList]()
    var schoolID:Int?
    var listID:Int?
    var hours:String = ""
    var mints:String = ""
    var AMPM:String = ""
    var failureMessage:String?
    
    lazy var viewModel : PickUpPersonViewModel = {
        return PickUpPersonViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let schoolData = UserManager.shared.schoolList {
            schoolListArray = schoolData
            self.schoolID = schoolListArray.map({$0.id}).first
        }
        else if let schoolID  = UserManager.shared.currentUser?.school_id{
            self.schoolID = schoolID
            
        }
        viewModel.delegate = self
        
        let schoolid = UserDefaults.standard.integer(forKey: "sc")
        if  schoolid > 1 {
            self.schoolID = schoolid
        }
        
        if let schoolID = self.schoolID {
            viewModel.PickUpPersonList(school_id: schoolID)
        }
        
        tblViewPickupperson.emptyDataSetDelegate = self
        tblViewPickupperson.emptyDataSetSource = self
        tblViewPickupperson.register(UINib(nibName: "PickUpPersonApprovalTableViewCell", bundle: nil), forCellReuseIdentifier: "PickUpPersonApprovalTableViewCell")
        self.configureUI()
        self.titleString = "PICKUP PERSON APPROVAL"
        self.view.bringSubviewToFront(childDropdown)
        
        
    }
    
    func configureUI(){
        if  let userType = UserManager.shared.currentUser?.userType {
            if let _type = UserType(rawValue:userType ) {
                
                switch  _type  {
                case .all,.student : break
                    
                case .admin, .parent ,.teacher:
                    tableTopConstarint.constant = 0
                    topBarHeight = 75
                    childDropdown.isHidden = true
                    break
                case .superadmin:
                    topBarHeight = 100
                    childDropdown.isHidden = false
                    childDropdown.headerTitle = "Select School Branch"
                    // childDropdown.footerTitle = ""
                    self.schoolDropdownAction()
                    
                    
                }
            }
        }
        
    }
    
    func schoolDropdownAction(){
        let schoolid = UserDefaults.standard.integer(forKey: "sc")
        childDropdown.titleArray = schoolListArray.map({$0.schoolName})
        
        
        childDropdown.subtitleArray = schoolListArray.map({$0.location})
        
        childDropdown.selectionAction = { (index : Int) in
            self.schoolID = self.schoolListArray[index].id
            UserDefaults.standard.set(self.schoolID, forKey: "sc")
            if let schoolID = self.schoolID {
                self.viewModel.PickUpPersonList(school_id: schoolID)
            }
            
            
        }
        
        if schoolListArray.count > 0 {
            if schoolid != 0 {
                let index = schoolListArray.firstIndex(where: {$0.id == schoolid})
                childDropdown.selectedIndex = index
                
                  DispatchQueue.main.async {
                      self.childDropdown.nameLabel.text = self.schoolListArray[index ?? 0].schoolName
                      self.childDropdown.section.text = self.schoolListArray[index ?? 0].location
                  }
                }
              }
    }
    
    func getRequestDate(date : String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm a"
        let convertedDate = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "hh"
        if let date1 = convertedDate {
            hours  =  dateFormatter.string(from: date1)
            dateFormatter.dateFormat = "mm"
            mints = dateFormatter.string(from: date1)
            dateFormatter.dateFormat = "a"
            AMPM = dateFormatter.string(from: date1)
        }
    }
    
}
extension PickUpPersonApprovalViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickupListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickUpPersonApprovalTableViewCell", for: indexPath as IndexPath) as! PickUpPersonApprovalTableViewCell
        cell.childNameLbl.text = pickupListArray[indexPath.row].name
        cell.fatherLbl.text = pickupListArray[indexPath.row].pickupPersonName
        cell.classLbl.text = pickupListArray[indexPath.row].datumClass + "," +  pickupListArray[indexPath.row].section + " Section"
        let requestDate = pickupListArray[indexPath.row].date
        getRequestDate(date: requestDate)
        cell.timeLbl.text = requestDate //hours + ":" + mints + AMPM
        
        
        cell.lblStatus.text = pickupListArray[indexPath.row].approvalStatus
        
        if let status = approvalStatus(rawValue: pickupListArray[indexPath.row].approvalStatus){
            
            switch status {
                
            case .pending:
                cell.acceptBtn.isHidden = false
                cell.rejectBtn.isHidden = false
                cell.lblStatus.isHidden = true
                cell.lblStatus.textColor = UIColor.ctPending
            case .approved:
                cell.acceptBtn.isHidden = true
                cell.rejectBtn.isHidden = true
                cell.lblStatus.isHidden = false
                cell.lblStatus.textColor = UIColor.ctApproved
            case .rejected:
                cell.acceptBtn.isHidden = true
                cell.rejectBtn.isHidden = true
                cell.lblStatus.isHidden = false
                cell.lblStatus.textColor = UIColor.ctRejected
                
            }
        }
        
        cell.acceptBtn.addTarget(self, action: #selector(acceptBtnAction), for: .touchUpInside)
        cell.rejectBtn.addTarget(self, action: #selector(rejectBtnAction), for: .touchUpInside)
        
        
        if let url = URL(string: pickupListArray[indexPath.row].profile) {
            cell.mainImgView.sd_setImage(with: url)
        }
        
        if  let userType = UserManager.shared.currentUser?.userType {
            if let _type = UserType(rawValue:userType ) {
                
                switch  _type  {
                case .all,.student,.superadmin,.admin,.parent :
                    //cell.acceptBtn.isHidden = false
                    //cell.rejectBtn.isHidden = false
                    cell.isUserInteractionEnabled = true
                case .teacher:
                    cell.acceptBtn.isHidden = true
                    cell.rejectBtn.isHidden = true
                    cell.isUserInteractionEnabled = false
                }}}
        
        return cell
    }
    
    @objc func acceptBtnAction(_ sender : UIButton){
        self.listID = pickupListArray[sender.tag].id
        if let id = self.listID {
            viewModel.PickUpPersonStatus(status: approvalStatus.approved.rawValue, listId: "\(id)")
        }
        
    }
    
    @objc func rejectBtnAction(_ sender : UIButton) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Reject ?", preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            action in
        }))
        
        alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: {
            action in
            
            self.listID = self.pickupListArray[sender.tag].id
            if let id = self.listID {
                self.viewModel.PickUpPersonStatus(status: approvalStatus.rejected.rawValue, listId: "\(id)")
            }
            
            
            
            
        }))
        self.present(alert, animated: true, completion: nil)
        
        //        self.listID = pickupListArray[sender.tag].id
        //        if let id = self.listID {
        //            viewModel.PickUpPersonStatus(status: approvalStatus.rejected.rawValue, listId: "\(id)")
        //        }
        //
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickUpPersonDetailViewController") as! PickUpPersonDetailViewController
        vc.delegate = self
        vc.pickupList = pickupListArray[indexPath.row]
        vc.listID = pickupListArray[indexPath.row].id
        self.listID = pickupListArray[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension PickUpPersonApprovalViewController:PickUpPersonDelegate {
    func PickUpPersonList(PickUp: [PickUpList]) {
        pickupListArray = PickUp
        self.tblViewPickupperson.reloadData()
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
        failureMessage = message
    }
    func pickUpStatus(message: String) {
        self.displayServerSuccess(withMessage: message)
        if let schoolID = self.schoolID {
            viewModel.PickUpPersonList(school_id: schoolID)
        }
    }
    
    
}

extension PickUpPersonApprovalViewController : refreshPickUpDataDelegate {
    
    func refreshPickUpList() {
        if let schoolID = self.schoolID {
            viewModel.PickUpPersonList(school_id:schoolID)
        }
    }
}

extension PickUpPersonApprovalViewController : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var message = "No data available !"
        
        if let _failureMessage = failureMessage {
            message = _failureMessage
        }
        
        return message.formatErrorMessage()
    }
}
