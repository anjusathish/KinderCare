//
//  AttendanceVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 21/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import DropDown
import SDWebImage
import DZNEmptyDataSet

class AttendanceVC: BaseViewController {
    
    @IBOutlet weak var dropdownView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBtnView: UIView!
    @IBOutlet weak var tblAttendance: UITableView!
    @IBOutlet weak var btnSingIn: UIButton!
    @IBOutlet weak var btnAbsent: UIButton!
    @IBOutlet weak var btnPresent: UIButton!
    @IBOutlet weak var btnSignOut: UIButton!
    @IBOutlet weak var buttonSignOutTime: UIButton!
    @IBOutlet weak var viewAdminHeader: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var stackviewSegments: UIStackView!
    @IBOutlet weak var stackviewDropdown: UIStackView!
    @IBOutlet weak var stackviewDropdownH: UIStackView!
    @IBOutlet weak var viewSegments: UIView!
    @IBOutlet weak var segementAttendance: CTSegmentControl!
    @IBOutlet weak var imgViewAdmin: UIImageView!
    @IBOutlet weak var dropDownSuperAdmin: ChildDropDown!
    @IBOutlet weak var btnSignInAtt: UIButton!
    @IBOutlet weak var btnSignOutAtt: UIButton!
    @IBOutlet weak var btnAbsentAtt: UIButton!
    @IBOutlet weak var btnMarkAbsentAtt: UIButton!
    @IBOutlet weak var btnMarkPresentAtt: UIButton!
    @IBOutlet weak var txtClass: CTTextField!
    @IBOutlet weak var txtSection: CTTextField!
    @IBOutlet weak var btnMarkAll: UIButton!
    var isSelected:Bool! = false
    
    @IBOutlet weak var calenderView: CTDayCalender!
    
    @IBOutlet weak var adminNameLabel: UILabel!
    
    let userType = UserType(rawValue: UserManager.shared.currentUser!.userType)
    
    var attendanceListArray = [Attendance]()
    var schoolListArray = [SchoolListData]()
    var classNameListArray = [ClassModel]()
    var sectionArray = [Section]()
    
    var selectedUserType : UserType = .admin
    
    var classID :Int?
    var sectionID:Int?
    var schoolID:Int?
    var settingsValue:Int?
    var checkUserId:Int?
    var errorMessage:String?
    
    var selectedUser : [Int] = []
    
    let dispatchGroup = DispatchGroup()
    let window = UIApplication.shared.windows.first
    
    lazy var viewModel : AttendanceListViewModel = {
        return AttendanceListViewModel()
    }()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserId = UserManager.shared.currentUser?.userID
        
        let schoolid = UserDefaults.standard.integer(forKey: "sc")
        if schoolid != 0 {
            self.schoolID = schoolid
            
        }
        else if let _schoolID  = UserManager.shared.currentUser?.school_id {
            self.schoolID = _schoolID
        }
        if let schoolData = UserManager.shared.schoolList {
            schoolListArray = schoolData
            // self.schoolId = schoolListArray.map({$0.id}).first
        }
        
        tblAttendance.emptyDataSetSource = self
        tblAttendance.emptyDataSetDelegate = self
        tblAttendance.delegate = self
        tblAttendance.dataSource = self
        tblAttendance.tableFooterView = UIView()
        
        tblAttendance.register(UINib(nibName: "AttendanceCell", bundle: nil), forCellReuseIdentifier: "AttendanceCell")
        
        getClassAndSectionValues()
        viewModel.delegate = self
        
        self.configUI()
        
        tblAttendance.separatorColor = UIColor.clear
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    func getClassAndSectionValues()
    {
        self.classNameListArray = SharedPreferenceManager.shared.classNameListArray
        self.sectionArray = SharedPreferenceManager.shared.sectionArray
        self.classID = self.classNameListArray.first?.id
        self.sectionID = self.sectionArray.first?.id
        self.txtClass.text = self.classNameListArray.first?.className
        //self.txtSection.text = self.sectionArray.first?.section
    }
    //MARK:- Show DropDown
    
    func showDropDown(sender : UITextField, content : [String]) {
        
        let dropDown = DropDown()
        dropDown.direction = .any
        dropDown.anchorView = sender // UIView or UIBarButtonItem
        dropDown.dismissMode = .automatic
        dropDown.dataSource = content
        
        dropDown.selectionAction = { (index: Int, item: String) in
            sender.text = item
            
            if sender == self.txtClass {
                self.classID = self.classNameListArray[index].id
                
                if let schoolId = self.schoolID,let classID = self.classID {
                    self.viewModel.sectionList(school_id: schoolId, class_id: classID)
                }
            }
            else if sender == self.txtSection {
                self.sectionID = self.sectionArray[index].id
                
                self.getStudentAttendanceList()
            }
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
    
    func setupSchoolDropdown(){
        var schoolid = UserDefaults.standard.integer(forKey: "sc")
        dropDownSuperAdmin.titleArray = schoolListArray.map({$0.schoolName})
        print(schoolListArray.map({$0.schoolName}))
        dropDownSuperAdmin.subtitleArray = schoolListArray.map({$0.location})
        dropDownSuperAdmin.selectionAction = { (index : Int) in
            self.schoolID = self.schoolListArray[index].id
            if let _schoolId = self.schoolID {
                UserDefaults.standard.set(self.schoolID , forKey: "sc")
                SharedPreferenceManager.shared.getClassNameList(schoolId: "\(_schoolId)")
            }
            self.getClassAndSectionValues()
            self.getAttendanceList()
        }
        
        if schoolListArray.count > 0 {
            if schoolid != 0 {
                let index = schoolListArray.firstIndex(where: {$0.id == schoolid})
                dropDownSuperAdmin.selectedIndex = index
                
                DispatchQueue.main.async {
                    self.schoolID = schoolid
                    self.dropDownSuperAdmin.nameLabel.text = self.schoolListArray[index ?? 0].schoolName
                    self.dropDownSuperAdmin.section.text = self.schoolListArray[index ?? 0].location
                }
            }
        }
    }
    
    func getStudentAttendanceList() {
        
        if let _classID  = self.classID, let _sectionID = self.sectionID, let _schoolID = schoolID {
            
            MBProgressHUD.showAdded(to: self.window!, animated: true)
            // dispatchGroup.enter()
            
            attendanceListArray.removeAll()
            tblAttendance.reloadData()
            
            self.viewModel.studentAttendanceList(school_id:_schoolID, date:self.calenderView.date.getasString(inFormat: "yyyy-MM-dd") , section_id: _sectionID, class_id: _classID)
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            MBProgressHUD.hide(for: self.window!, animated: true)
        })
    }
    
    func getAttendanceList() {
        switch selectedUserType {
        case .all,.parent,.superadmin: break
        case .student : getStudentAttendanceList()
        case .admin,.teacher : getAttendanceAdminAndTeacherList()
        }
    }
    
    func getAttendanceAdminAndTeacherList() {
        
        guard let _schoolID = schoolID else {
            return
        }
        
        MBProgressHUD.showAdded(to: self.window!, animated: true)
        //calenderView.date.getasString(inFormat: "yyyy-MM-dd")
        //dispatchGroup.enter()
        
        attendanceListArray.removeAll()
        tblAttendance.reloadData()
        
        if UserManager.shared.currentUser?.userTypeName == "teacher" {
            viewModel.attendanceList(date:calenderView.date.getasString(inFormat: "yyyy-MM-dd"), user_type: selectedUserType.rawValue, school_id: _schoolID)
        }
        else{ viewModel.attendanceList(date:calenderView.date.getasString(inFormat: "yyyy-MM-dd"), user_type: selectedUserType.rawValue, school_id: _schoolID)
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            MBProgressHUD.hide(for: self.window!, animated: true)
        })
    }
    
    func setAttendance(withTime time : String = "", forType type : AttendanceType){
        
        guard let _schoolID = schoolID else {
            return
        }
        
        MBProgressHUD.showAdded(to: self.window!, animated: true)
        
        // self.dispatchGroup.enter()
        
        if UserManager.shared.currentUser?.userTypeName == "teacher" {
            
            
            self.viewModel.addAttendanceList(school_id: _schoolID , log_type: type.rawValue, selectedUsers: self.selectedUser, date: self.calenderView.date.getasString(inFormat: "yyyy-MM-dd"), time: time, user_type: selectedUserType.rawValue, classId: classID, sectionId: sectionID)
        }
        else{
            self.viewModel.addAttendanceList(school_id: _schoolID , log_type: type.rawValue, selectedUsers: self.selectedUser, date: self.calenderView.date.getasString(inFormat: "yyyy-MM-dd"), time: time, user_type:  self.selectedUserType.rawValue, classId: classID, sectionId: sectionID)
        }
        dispatchGroup.notify(queue: .main, execute: {
            
            MBProgressHUD.hide(for: self.window!, animated: true)
        })
        
    }
    
    //MARK:- Local Methods
    
    func configUI(){
        
        if  let userType = UserManager.shared.currentUser?.userType {
            
            if let _type = UserType(rawValue:userType ) {
                
                segementAttendance.segmentTitles = _type.attendanceTitles
                
                switch  _type  {
                case .all,.student : break
                    
                case .teacher:
                    if UserManager.shared.currentUser?.permissions?.teacherLogin == 0{
                        viewAdminHeader.isHidden = true
                        topBarHeight = 60
                    }
                    else {
                        viewAdminHeader.isHidden = false
                        topBarHeight = 100
                        
                    }
                    
                    
                    viewSegments.isHidden = false
                    stackviewDropdown.isHidden = true
                    imgViewAdmin.layer.cornerRadius = 30
                    imgViewAdmin.layer.masksToBounds = true
                    topBarHeight = 100
                    titleString = "DAILY ATTENDANCE"
                    segementAttendance.segmentTitles = "Students"
                    self.view.bringSubviewToFront(viewHeader)
                    dropDownSuperAdmin.isHidden = true
                    
                    selectedUserType = .teacher
                    getAttendanceList()
                    
                    selectedUserType = .student
                    getAttendanceList()
                    
                    dispatchGroup.notify(queue: .main, execute: {
                        
                        MBProgressHUD.hide(for: self.window!, animated: true)
                    })
                    
                    
                    
                    
                case .admin:
                    if UserManager.shared.currentUser?.permissions?.adminLogin == 0{
                        viewAdminHeader.isHidden = true
                        topBarHeight = 60
                    }
                    else {
                        viewAdminHeader.isHidden = false
                        topBarHeight = 100
                        
                    }
                    
                    
                    viewSegments.isHidden = false
                    stackviewDropdown.isHidden = true
                    imgViewAdmin.layer.cornerRadius = 30
                    
                    
                    imgViewAdmin.layer.masksToBounds = true
                    
                    titleString = "DAILY ATTENDANCE"
                    self.view.bringSubviewToFront(viewHeader)
                    dropDownSuperAdmin.isHidden = true
                    
                    
                    selectedUserType = .admin
                    getAttendanceList()
                    
                    selectedUserType = .teacher
                    getAttendanceList()
                    
                    dispatchGroup.notify(queue: .main, execute: {
                        
                        MBProgressHUD.hide(for: self.window!, animated: true)
                    })
                    
                case .superadmin:
                    
                    getAttendanceList()
                    
                    viewSegments.isHidden = false
                    viewAdminHeader.isHidden = true
                    stackviewDropdown.isHidden = true
                    topBarHeight = 100
                    titleString = "DAILY ATTENDANCE"
                    dropDownSuperAdmin.isHidden = false
                    dropDownSuperAdmin.headerTitle = "Select School Branch"
                    
                    self.view.bringSubviewToFront(viewHeader)
                    self.setupSchoolDropdown()
                    
                case .parent:
                    titleString = "DAILY ATTENDANCE"
                }
            }
        }
        
        modifyUI(forSelectedUserType: selectedUserType.rawValue)
    }
    
    func modifyUI(forSelectedUserType type : Int) {
        
        if let _type = UserType(rawValue:type ) {
            
            switch  _type  {
            case .all,.parent,.superadmin : break
            case .teacher:
                stackviewDropdown.isHidden = true
                showTeachersTitles()
            case .admin:
                stackviewDropdown.isHidden = true
                showAdminTitles()
            case .student:
                stackviewDropdown.isHidden = false
                showStudentTitles()
            }
        }
    }
    
    //MARK:- Button Action
    
    @objc func selectChild(_ sender: UIButton){
        
        if let cell = sender.superview?.superview?.superview as? AttendanceCell {
            
            if let indexPath = tblAttendance.indexPath(for: cell) {
                
                if let index = selectedUser.firstIndex(where: {$0 == attendanceListArray[indexPath.row].userID}){
                    
                    selectedUser.remove(at: index)
                    
                    if self.selectedUser.count > 0 {
                        btnMarkAll.setImage(UIImage(named: "select"), for: .normal)
                    }else{
                        btnMarkAll.setImage(UIImage(named: "unSelect"), for: .normal)
                    }
                    
                }
                else {
                    selectedUser.append(attendanceListArray[indexPath.row].userID)
                    
                }
            }
        }
        
        tblAttendance.reloadData()
    }
    
    @IBAction func btnAttendanceAction(_ sender: UIButton){
        
        let vc = UIStoryboard.attendanceStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        vc.mode = .time
        
        switch sender.tag {
            
        case 1:
            if let userID = UserManager.shared.currentUser?.userID{
                selectedUser = [userID]
            }
            
            if UserManager.shared.currentUser?.userTypeName == "teacher"{
                selectedUserType = .teacher
            }else{
                selectedUserType = .admin
            }
            
            
            vc.dismissBlock = { dataObj in
                
                self.setAttendance(withTime: dataObj.getasString(inFormat: "HH:mm"), forType: .signin)
            }
            
            present(controllerInSelf: vc)
            
        case 4:
            
            if let userID = UserManager.shared.currentUser?.userID{
                selectedUser = [userID]
            }
            
            if UserManager.shared.currentUser?.userTypeName == "teacher"{
                selectedUserType = .teacher
            }else{
                selectedUserType = .admin
            }
            
            vc.dismissBlock = { dataObj in
                
                self.setAttendance(withTime: dataObj.getasString(inFormat: "HH:mm"), forType: .signout)
            }
            
            present(vc, animated: true)
            
        case 5:
            
            if selectedUser.count > 0{
                
                present(vc, animated: true)
                
                vc.dismissBlock = { dataObj in
                    
                    self.setAttendance(withTime: dataObj.getasString(inFormat: "HH:mm"), forType: .signin)
                }
                
            }else{
                self.displayServerSuccess(withMessage: "Please select \(selectedUserType.stringValue)")
            }
        case 6:
            
            if selectedUser.count > 0{
                
                present(vc, animated: true)
                
                vc.dismissBlock = { dataObj in
                    
                    self.setAttendance(withTime: dataObj.getasString(inFormat: "HH:mm"), forType: .signout)
                }
                
            }else{
                self.displayServerSuccess(withMessage: "Please select \(selectedUserType.stringValue)")
            }
            
        default:break
            
        }
        
    }
    
    @objc func donePicker(sender: Any){
        view.endEditing(true)
        
    }
    @IBAction func btnAbsentAction(_ sender: Any) {
        if selectedUser.count > 0{
            setAttendance(forType: .absent)
        }
        else
        {
            self.displayServerError(withMessage: "Please select \(selectedUserType.stringValue)")
        }
    }
    
    @IBAction func markAllAction(_ sender: Any) {
        
        if !isSelected  {
            isSelected = true
            
            for (index, element) in attendanceListArray.enumerated() {
                print(index, ":", element)
                selectedUser.append(element.userID)
                
            }
            
            
        }
        else{
            isSelected = false
            selectedUser.removeAll()
        }
        
        if self.selectedUser.count > 0 {
            btnMarkAll.setImage(UIImage(named: "select"), for: .normal)
        }else{
            btnMarkAll.setImage(UIImage(named: "unSelect"), for: .normal)
        }
        
        tblAttendance.reloadData()
        
        
        
    }
    
    @IBAction func btnMarkPresentAction(_ sender: Any) {
        if selectedUser.count > 0{
            setAttendance(forType: .present)
        }
        else
        {
            self.displayServerError(withMessage: "Please select \(selectedUserType.stringValue)")
        }
        
    }
    
    
    @IBAction func signinButtonHandler(_ sender: UIButton){
        
        btnSingIn.isHidden = true
        btnAbsent.isHidden = true
        btnPresent.isHidden = false
        btnSignOut.isHidden = false
        
        let vc = UIStoryboard.attendanceStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        
        vc.mode = .time
        
        vc.dismissBlock = { dataObj in
            
            self.setAttendance(withTime: dataObj.getasString(inFormat: "HH:mm"), forType: .signin)
        }
        
        present(vc, animated: true)
    }
    
    @IBAction func signoutButtonHandler(_ sender: UIButton){
        
        btnSingIn.isHidden = false
        btnAbsent.isHidden = false
        btnPresent.isHidden = true
        btnSignOut.isHidden = true
        let vc = UIStoryboard.attendanceStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        // vc.timePicker.minimumDate =
        vc.mode = .time
        vc.dismissBlock = { dataObj in
            
            self.setAttendance(withTime: dataObj.getasString(inFormat: "HH:mm"), forType: .signout)
        }
        
        present(vc, animated: true)
    }
    
    @IBAction func segmentControlValueChanged(_ sender: CTSegmentControl){
        
        guard let type = UserTypeTitle(rawValue: sender.selectedSegmentTitle), let userType = UserType(rawValue: type.id) else {
            return
        }
        
        selectedUserType = userType
        modifyUI(forSelectedUserType: selectedUserType.rawValue)
        
        getAttendanceList()
        dispatchGroup.notify(queue: .main, execute: {
            MBProgressHUD.hide(for: self.window!, animated: true)
        })
    }
    
    @IBAction func calendarViewValueChanged(_ sender: Any) {
        
        getAttendanceList()
    }
    
    func updateBottomButtons(value : Int) {
        if  value == 1 {
            [btnSignInAtt,btnSignOutAtt,btnAbsentAtt].forEach({$0.isHidden = false})
            [btnMarkAbsentAtt,btnMarkPresentAtt].forEach({$0.isHidden = true})
        }
        else
        {
            [btnSignInAtt,btnSignOutAtt,btnAbsentAtt].forEach({$0.isHidden = true})
            [btnMarkAbsentAtt,btnMarkPresentAtt].forEach({$0.isHidden = false})
        }
        
    }
    
    func showTeachersTitles() {
        
        if let settingsValue  = UserManager.shared.currentUser?.permissions?.teacherLogin {
            self.settingsValue = settingsValue
            updateBottomButtons(value: settingsValue)
        }
    }
    
    func showAdminTitles() {
        
        if let settingsValue  = UserManager.shared.currentUser?.permissions?.adminLogin {
            self.settingsValue = settingsValue
            updateBottomButtons(value: settingsValue)
        }
    }
    
    func showStudentTitles() {
        
        if let settingsValue  = UserManager.shared.currentUser?.permissions?.studentLogin {
            self.settingsValue = settingsValue
            updateBottomButtons(value: settingsValue)
        }
    }
}

extension AttendanceVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendanceListArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendanceCell", for: indexPath) as! AttendanceCell
        cell.selectionStyle = .none
        
        cell.btnSelect.addTarget(self, action: #selector(self.selectChild), for: .touchUpInside)
        if  let userType = UserManager.shared.currentUser?.userType {
            if let _type = UserType(rawValue:userType ) {
                
                
                switch  _type {
                case .admin,.teacher:
                    
                    if Int(segementAttendance.selectedSegmentIndex) == 0 {
                        if UserManager.shared.currentUser?.permissions?.editStaffAttendance == 0{
                            cell.btnSelect.isHidden = true
                        }
                        else{
                            cell.btnSelect.isHidden = false
                        }
                    }
                    else  {
                        cell.btnSelect.isHidden = false
                    }
                    
                    
                    break
                case .parent,.student,.superadmin,.all: break
                    
                    
                    
                }}}
        
        if  let userType = UserManager.shared.currentUser?.userType {
            if let _type = UserType(rawValue:userType ) {
                
                
                switch  _type {
                case .admin,.teacher:
                    
                    
                    
                    if Int(segementAttendance.selectedSegmentIndex) == 0 {
                        if UserManager.shared.currentUser?.permissions?.editStaffAttendance == 0{
                            cell.btnSelect.isHidden = true
                        }
                        else{
                            cell.btnSelect.isHidden = false
                        }
                    }
                    else  {
                        cell.btnSelect.isHidden = false
                    }
                    
                    break
                case .parent,.student,.superadmin,.all: break
                    
                    
                    
                }}}
        
        
        let attendance = attendanceListArray[indexPath.row]
        
        if self.selectedUser.contains(attendance.userID) {
            cell.btnSelect.setImage(UIImage(named: "select"), for: .normal)
        }else{
            cell.btnSelect.setImage(UIImage(named: "unSelect"), for: .normal)
        }
        
        if self.settingsValue == 0 {
            
            if attendance.status == 0 {
                
                cell.btnPresentAbsent.isHidden = true
                cell.stackViewTime.isHidden = true
            }
                
            else if attendance.status == 1{
                cell.btnPresentAbsent.isHidden = false
                cell.btnPresentAbsent.setTitle("   Present", for: .normal)
                cell.btnPresentAbsent.setTitleColor(UIColor.ctGrgeen, for: .normal)
                cell.btnPresentAbsent.setImage(UIImage(named: "tick"), for: .normal)
            }
                
            else  if attendance.status == 2{
                cell.btnPresentAbsent.isHidden = false
                cell.btnPresentAbsent.setTitle("X   Absent", for: .normal)
                cell.btnPresentAbsent.setImage(nil, for: .normal)
                cell.btnPresentAbsent.setTitleColor(UIColor.red, for: .normal)
            }
            
        }else{
            
            cell.stackViewTime.isHidden = false
            
            switch attendance.status {
                
            case 0:
                cell.btnPresentAbsent.isHidden = true
                cell.stackViewTime.isHidden = true
                cell.signInView.isHidden = false //aabdul
                cell.signOutView.isHidden = true
                
            case 1:
                
                if  !attendance.signInTime.isEmpty && !attendance.signOutTime.isEmpty {
                    
                    cell.signInView.isHidden = false
                    cell.signOutView.isHidden = false
                    cell.btnPresentAbsent.isHidden = true
                    
                    cell.inTime.text = attendance.signInTime
                    
                    cell.outTimeLbl.text = attendance.signOutTime
                    
                } else if !attendance.signInTime.isEmpty {
                    
                    cell.signInView.isHidden = false
                    cell.signOutView.isHidden = true
                    cell.btnPresentAbsent.isHidden = true
                    
                    cell.inTime.text = attendance.signInTime
                    
                }else if !attendance.signInTime.isEmpty{
                    cell.signInView.isHidden = true
                    cell.signOutView.isHidden = false
                    cell.btnPresentAbsent.isHidden = true
                    
                    cell.outTimeLbl.text = attendance.signInTime
                }
            case 2:
                cell.btnPresentAbsent.isHidden = false
                cell.btnPresentAbsent.setTitle("X   Absent", for: .normal)
                cell.btnPresentAbsent.setImage(nil, for: .normal)
                cell.btnPresentAbsent.setTitleColor(UIColor.red, for: .normal)
                
                cell.stackViewTime.isHidden = true
                cell.signInView.isHidden = true
                cell.signOutView.isHidden = true
                
            default: break
                
            }
        }
        cell.nameLbl.text = attendance.name
        
        if let url = URL(string: attendance.profile) {
            cell.profileImg.sd_setImage(with: url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension AttendanceVC : UITextFieldDelegate {
    
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
        if textField == txtClass{
            showDropDown(sender: textField, content: classNameListArray.map({$0.className}))
            let className = classNameListArray.map({$0.className})
            return false
        }else if textField == txtSection{
            guard let section = sectionArray.map({$0.section}) as? [String] else { return false}
            showDropDown(sender: textField, content: section)
            
            return false
            
        }
        return true
    }
    
}

//MARK:- Attendance Delegate Methodes
//extension
extension AttendanceVC:AttendanceListDelegate{
    
    func getAttendanceListSuccess(attendanceList: [Attendance], forUserType: Int) {
        
        //  dispatchGroup.leave()
        
        if let _type = UserType(rawValue:forUserType ){
            
            if _type == .admin {
                
                if  let userType = UserManager.shared.currentUser?.userType {
                    
                    if let _type = UserType(rawValue:userType ) {
                        
                        if _type == .superadmin {
                            attendanceListArray = attendanceList
                            tblAttendance.reloadData()
                        }
                        else {
                            adminNameLabel.text = attendanceList[0].name
                            
                            switch attendanceList[0].status {
                                
                            case 0:
                                btnSingIn.isHidden = false
                                btnAbsent.isHidden = false
                                // btnPresent.isHidden = true
                                btnSignOut.isHidden = true
                                
                            case 1:
                                
                                btnSingIn.isHidden = true
                                btnAbsent.isHidden = true
                                
                                if !attendanceList[0].signInTime.isEmpty && !attendanceList[0].signOutTime.isEmpty {
                                     btnPresent.isHidden = false
                                    btnSignOut.isHidden = true
                                    buttonSignOutTime.isHidden = false
                                    btnPresent.setTitle(attendanceList[0].signInTime, for: .normal)
                                    buttonSignOutTime.setTitle(attendanceList[0].signOutTime, for: .normal)
                                    
                                }else if !attendanceList[0].signInTime.isEmpty {
                                    btnPresent.isHidden = false
                                    btnSignOut.isHidden = false
                                    buttonSignOutTime.isHidden = true
                                    btnPresent.setTitle(attendanceList[0].signInTime, for: .normal)
                                }
                                
                            case 2:
                                btnSingIn.isHidden = true
                                btnAbsent.isHidden = false
                                
                            default: break
                                
                            }
                        }
                    }
                }
            }
            else  if _type == .teacher {
                
                if let userTypeName = UserManager.shared.currentUser?.name {
                    adminNameLabel.text = userTypeName
                }
                if let img = UserManager.shared.currentUser?.profile{
                    if let urlString = img.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
                        if let url = URL(string: urlString) {
                            imgViewAdmin.sd_setImage(with: url)
                        }
                    }
                    
                }
                attendanceListArray = attendanceList
                
                if UserManager.shared.currentUser?.userTypeName == "teacher" {
                    
                    
                    let dat = attendanceListArray.filter({$0.userID == checkUserId})
                    print(dat)
                    
                    if dat.first?.signInTime == "" {
                        
                    }
                        
                    else if dat.first?.signOutTime == "" && dat.first?.signInTime != nil {
                        btnAbsent.isHidden = false
                        btnSingIn.isHidden = true
                        btnPresent.setTitle(dat[0].signInTime, for: .normal)
                        btnPresent.isHidden = false
                    }
                    else{
                        btnPresent.isHidden = false
                        btnSingIn.isHidden = true
                        buttonSignOutTime.isHidden = false
                        btnPresent.setTitle(dat[0].signInTime, for: .normal)
                        buttonSignOutTime.setTitle(dat[0].signOutTime, for: .normal)
                    }
                }
                
                tblAttendance.reloadData()
            }
            else{
                
                
                attendanceListArray = attendanceList
                tblAttendance.reloadData()
            }
        }else{
            attendanceListArray = attendanceList
            tblAttendance.reloadData()
        }
        selectedUser.removeAll()
    }
    
    
    func updateAttendanceListSuccess() {
        //  dispatchGroup.leave()
        
        getAttendanceList()
        
        tblAttendance.reloadData()
        
        self.dispatchGroup.notify(queue: .main, execute: {
            MBProgressHUD.hide(for: self.window!, animated: true)
        })
        
        guard let type = UserTypeTitle(rawValue: segementAttendance.selectedSegmentTitle), let userType = UserType(rawValue: type.id) else {
            return
        }
        
        selectedUserType = userType
    }
    
    func gettingAttendanceListFailure(message: String) {
        // dispatchGroup.leave()
        self.dispatchGroup.notify(queue: .main, execute: {
            MBProgressHUD.hide(for: self.window!, animated: true)
        })
        displayServerError(withMessage: message)
        
        errorMessage  = message
        attendanceListArray.removeAll()
        selectedUser.removeAll()
        tblAttendance.reloadData()
    }
    
    func getSectionNameListSuccess(sectionList: [Section]) {
        
        //        dispatchGroup.leave()
        sectionArray = sectionList
        self.sectionID = self.sectionArray.first?.id
       // self.txtSection.text =  self.sectionArray.first?.section
        
    }
    
    func getClassNameListSuccess(classList: [ClassModel]) {
        
        classNameListArray = classList
        
        self.classID = self.classNameListArray.first?.id
        self.txtClass.text = self.classNameListArray.first?.className
        
    }
    
    func failure(message: String) {
        //        dispatchGroup.leave()
        self.dispatchGroup.notify(queue: .main, execute: {
            MBProgressHUD.hide(for: self.window!, animated: true)
        })
        displayServerError(withMessage: message)
        
        errorMessage  = message
        selectedUser.removeAll()
        tblAttendance.reloadData()
    }
}

extension AttendanceVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!{
        
        var message = "No data available !"
        
        if let _failureMessage = errorMessage {
            message = _failureMessage
        }
        
        return message.formatErrorMessage()
    }
}





