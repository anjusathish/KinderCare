//
//  EnrolmentAddViewController.swift
//  Kinder Care
//
//  Created by CIPL0590 on 12/3/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class EnrolmentDetailViewController: BaseViewController {
    
    @IBOutlet weak var btnEnquire:UIButton!
    @IBOutlet weak var childNameLbl: UILabel!
    @IBOutlet weak var childAgeLbl: UILabel!
    @IBOutlet weak var fatherNameLbl: UILabel!
    @IBOutlet weak var mailLbl: UILabel!
    @IBOutlet weak var contactNoLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var purposeLbl: UILabel!
    @IBOutlet weak var editenquirySA: UIButton!
    @IBOutlet weak var motherNameLbl: UILabel!
    @IBOutlet weak var classNameLbl: UILabel!
    @IBOutlet weak var dobLbl: UILabel!
    
    
    
    var schoolID:Int?
    var enrolmentList: EnrolmentList?
    var delegate:refreshTableViewDelegate?
    
    lazy var viewModel : enrolmentEnquiryViewModel = {
        return enrolmentEnquiryViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        self.titleString = "ENROLLMENT ENQUIRY" //Delete & EditDetail
        self.tableData()
        setUPUI()
        
        
    }
    
    func setUPUI(){
        
        if  let userType = UserManager.shared.currentUser?.userType {
            
            if let _type = UserType(rawValue:userType ) {
                
                switch _type{
                    
                case .parent,.teacher,.all,.student:
                    break
                case .admin:
                    self.btnEnquire.backgroundColor = UIColor.ctYellow
                    self.btnEnquire.setTitle("Edit Enquire", for: .normal)
                    
                case .superadmin:
                    self.editenquirySA.backgroundColor = UIColor.ctYellow
                    self.btnEnquire.backgroundColor = UIColor.ctRejected
                    self.btnEnquire.setTitle("Delete Enquire", for: .normal)
                    self.editenquirySA.isHidden = false
                    
                }
            }
        }
        
    }
    
    @IBAction func deleteBtnAction(_ sender: Any) {
        
        if  let userType = UserManager.shared.currentUser?.userType {
            if let _type = UserType(rawValue:userType ) {
                switch _type{
                case .parent,.teacher,.all,.student:
                    break
                case .admin:
                    editEnrolmentEnquiry()
                case .superadmin:
                    DeleteEnrolmentEnquiry()
                }
            }
        }
    }
    @IBAction func editSuperAdmin(_ sender: Any) {
         editEnrolmentEnquiry()
        }
    
    func editEnrolmentEnquiry(){
        
        let vc = UIStoryboard.enrolmentEnquiryStoryboard().instantiateViewController(withIdentifier:"EnrolmentAddViewController") as! EnrolmentAddViewController
        vc.editEnrolment = enrolmentList
        vc.isEditEnrolment = true
        vc.delegate = delegate
        vc.schoolId = self.schoolID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func DeleteEnrolmentEnquiry(){
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Delete ?", preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            action in
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
            action in
            
            if let id = self.enrolmentList?.id{
                
                self.viewModel.enrolmentDelete(id: "\(id)")
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func tableData(){
        
        self.childNameLbl.text = enrolmentList?.studentName
        self.fatherNameLbl.text = enrolmentList?.fatherName
        self.mailLbl.text = enrolmentList?.email
        self.contactNoLbl.text = enrolmentList?.contact
        self.purposeLbl.text = enrolmentList?.purpose
        self.motherNameLbl.text = enrolmentList?.motherName
        self.classNameLbl.text = enrolmentList?.className
        if let dob = enrolmentList?.dob {
            
        self.dobLbl.text = dob.getDateAsStringWith(inFormat: "yyyy-MM-dd", outFormat: "dd-MM-yyyy")
        }
        if let status = enrolmentList?.status,let age = enrolmentList?.age{
            if status == 0 {
                self.statusLbl.text = "Awaiting Response"
                self.statusLbl.textColor = UIColor.ctPending
            }
                else if status == 1 {
            
                self.statusLbl.text = "Accepted"
                self.statusLbl.textColor = UIColor.ctApproved
            }
            else{
              self.statusLbl.text = "Rejected"
                self.statusLbl.textColor = UIColor.ctRejected
            }
            
            self.childAgeLbl.text = "\(age)"
        }
    }
}

extension EnrolmentDetailViewController:enrolmentEnquirytDelegate {
    
    func getClassNameListSuccess(classList: [ClassModel]) {
        
    }
    
    func enrolmentEditSuccess() {
    }
    
    func enrolmentList(enrolmentList: EnquiryListData?) {
    }
    
    func entrolmentDelete() {
        self.displayServerSuccess(withMessage: "Enrolment Deleted Successfully")
        self.delegate?.refreshTableView()
        self.navigationController?.popViewController(animated: true)
    }
    
    func enrolmentAdd() {
        
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
    }
}
