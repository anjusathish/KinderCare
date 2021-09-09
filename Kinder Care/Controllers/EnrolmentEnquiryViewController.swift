//
//  EnrolmentEnquiryViewController.swift
//  Kinder Care
//
//  Created by CIPL0590 on 12/3/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class EnrolmentEnquiryViewController: BaseViewController {
    
    @IBOutlet weak var calendarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var childDropdown: ChildDropDown!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblAccepted: UILabel!
    @IBOutlet weak var lblRejected: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var acceptedLbl: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var rejectLbl: UILabel!
    
    @IBOutlet weak var calenderView: CTDayCalender!{
        didSet {
            calenderView.calenderType = .month
        }
    }
    
    let userType = UserType(rawValue: UserManager.shared.currentUser!.userType)
    
    var schoolListArray = [SchoolListData]()
    var schoolID:Int?
    var enrolmentList:EnquiryListData?
    var enrolmentListArray = [EnrolmentList]()
    var delegate:refreshTableViewDelegate?
    
    lazy var viewModel : enrolmentEnquiryViewModel = {
        return enrolmentEnquiryViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userType = UserManager.shared.currentUser?.userType {
        
        if let _type = UserType(rawValue:userType ) {
            
            switch _type {
                
                
            case .parent,.teacher,.all,.student: break
                
            case .admin:
                if let schoolID  = UserManager.shared.currentUser?.school_id{
                    self.schoolID = schoolID
                 
                }
            case .superadmin:
                if let schoolData = UserManager.shared.schoolList {
                    schoolListArray = schoolData
                    self.schoolID = schoolListArray.map({$0.id}).first
                    
                }
                else if let schoolID  = UserManager.shared.currentUser?.school_id{
                    self.schoolID = schoolID
                    
                }
            }}}
        
       
        viewModel.delegate = self
        
        
        self.configureUI()
        
        self.titleString = "ENROLLMENT ENQUIRY"
        self.view.bringSubviewToFront(childDropdown)
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func configureUI(){
        
        if  let userType = UserManager.shared.currentUser?.userType {
            if let _type = UserType(rawValue:userType ) {
                
                switch  _type  {
                case .all,.student : break
                case .admin, .parent ,.teacher:
                    childDropdown.isHidden = true
                    calendarTopConstraint.constant = -50
                    if let schoolID = self.schoolID {
                        
                        viewModel.enrolmentList(school_id: schoolID, from_date: calenderView.monthStartDate.getasString(inFormat: "yyyy-MM-dd"), to_date: calenderView.monthEndDate.getasString(inFormat: "yyyy-MM-dd"))
                        
                    }
                    break
                case .superadmin:
                    topBarHeight = 100
                    childDropdown.isHidden = false
                    childDropdown.headerTitle = "Select School Branch"
                   // childDropdown.footerTitle = ""
                    self.schoolDropdownAction()
                    
                    let schoolid = UserDefaults.standard.integer(forKey: "sc")
                    if  schoolid > 1 {
                        self.schoolID = schoolid
                    }
                    
                    if let schoolID = self.schoolID {
                        viewModel.enrolmentList(school_id: schoolID, from_date: calenderView.monthStartDate.getasString(inFormat: "yyyy-MM-dd"), to_date: calenderView.monthEndDate.getasString(inFormat: "yyyy-MM-dd"))
                        
                    }
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
            if let schoolID = self.schoolID {
                UserDefaults.standard.set(self.schoolID, forKey: "sc")
                self.viewModel.enrolmentList(school_id: schoolID, from_date: self.calenderView.monthStartDate.getasString(inFormat: "yyyy-MM-dd"), to_date: self.calenderView.monthEndDate.getasString(inFormat: "yyyy-MM-dd"))
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
    
    override func viewDidLayoutSubviews() {
        
        lblTotal.roundCornersforLabel([.bottomLeft, .bottomRight], radius: 10)
        lblAccepted.roundCornersforLabel([.bottomLeft, .bottomRight], radius: 10)
        lblRejected.roundCornersforLabel([.bottomLeft, .bottomRight], radius: 10)
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        
        let vc = UIStoryboard.enrolmentEnquiryStoryboard().instantiateViewController(withIdentifier:"EnrolmentAddViewController") as! EnrolmentAddViewController
        vc.delegate = self
        vc.schoolId = self.schoolID
        vc.isEditEnrolment = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func calenderAction(_ sender: Any) {
        
        if let schoolID = self.schoolID {
            
            self.viewModel.enrolmentList(school_id: schoolID, from_date: calenderView.monthStartDate.getasString(inFormat: "yyyy-MM-dd"), to_date: calenderView.monthEndDate.getasString(inFormat: "yyyy-MM-dd"))
        }
    }
    
}
extension UILabel {
    
    func roundCornersforLabel(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension EnrolmentEnquiryViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enrolmentListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnrollmentEnquiryTableViewCell", for: indexPath as IndexPath) as! EnrollmentEnquiryTableViewCell
        
        cell.nameLbl.text = enrolmentListArray[indexPath.row].studentName
        cell.ageLbl.text = "Age  +  \(enrolmentListArray[indexPath.row].age)"
        
        
        if let Createdate = enrolmentListArray[indexPath.row].createdAt {
            
            cell.dateLbl.text = Createdate.getDateAsStringWith(inFormat: "yyyy-MM-dd HH:mm:ss", outFormat: "dd-MM-yyyy HH:mm:ss")
        }
        cell.subNameLbl.text = enrolmentListArray[indexPath.row].fatherName
        if enrolmentListArray[indexPath.row].status == 2 {
            cell.statusLbl.text = "Rejected"
            cell.statusLbl.textColor = UIColor.red
        }
        else if  enrolmentListArray[indexPath.row].status == 1
        {
            cell.statusLbl.text = "Accepted"
            cell.statusLbl.textColor = UIColor.ctGrgeen
            
        }
        else{
            cell.statusLbl.text = "Pending"
            cell.statusLbl.textColor = UIColor.ctYellow
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if userType == UserType.admin{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnrolmentDetailViewController") as! EnrolmentDetailViewController
            vc.enrolmentList = enrolmentListArray[indexPath.row]
            vc.delegate = self
            vc.schoolID = self.schoolID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnrolmentDetailViewController") as! EnrolmentDetailViewController
            vc.enrolmentList = enrolmentListArray[indexPath.row]
            vc.delegate = self
            vc.schoolID = self.schoolID
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
}


extension EnrolmentEnquiryViewController:enrolmentEnquirytDelegate{
    func getClassNameListSuccess(classList: [ClassModel]) {
        
    }
    
    func enrolmentEditSuccess() {
        
    }
    
    func entrolmentDelete() {
        
    }
    
    func enrolmentAdd() {
        
    }
    
    func enrolmentList(enrolmentList: EnquiryListData?) {
        self.enrolmentListArray.removeAll()
        self.enrolmentList = enrolmentList
        
        if let list = enrolmentList?.list{
            enrolmentListArray = list
            print(enrolmentListArray)
        }
        
        if let total = enrolmentList?.totalCount,let accept = enrolmentList?.acceptedCount,let reject = enrolmentList?.rejectedCount
        {
            self.totalLbl.text = "\(total)"
            self.acceptedLbl.text = "\(accept)"
            self.rejectLbl.text = "\(reject)"
        }
        
        self.tblView.reloadData()
        
        
    }
    
    func failure(message: String) {
         self.enrolmentListArray.removeAll()
        self.tblView.reloadData()
        displayServerError(withMessage: message)
        
    }
    
    
}

extension EnrolmentEnquiryViewController:refreshTableViewDelegate{
    
    func refreshTableView() {
        
        if let schoolID = self.schoolID {
           print(self.schoolID)
            viewModel.enrolmentList(school_id: schoolID, from_date: calenderView.monthStartDate.getasString(inFormat: "yyyy-MM-dd"), to_date: calenderView.monthEndDate.getasString(inFormat: "yyyy-MM-dd"))
        }
        
        self.tblView.reloadData()
    }
}
