//
//  SelectStudentVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 29/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class SelectStudentVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var tblStudent: UITableView!
    @IBOutlet weak var vwTop: UIView!
    
    var activityType : ActivityType!
    public var viewDailyActivityDetails:DailyActivityDetail?
    var arrIndexpath = [IndexPath]()
    var users = [String]()
    var addClassRoomRequest: AddClassRoomActivityRequest?
    var selectedDate:Date?
    var fromDate:String?
    
    
    private var classID : Int?
    private var sectionID : Int?
    private var selectedStudentsArray : [Student] = []
    
    //MARK:- ViewCotoller LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleString = "SELECT STUDENTS"
        tblStudent.tableFooterView = UIView()
        tblStudent.tableHeaderView = vwTop
        tblStudent.register(UINib(nibName: "AddCommonActivityCell", bundle: nil), forCellReuseIdentifier: "AddCommonActivityCell")
        
        if let arrayStudentName = viewDailyActivityDetails?.students{
            
            selectedStudentsArray =  arrayStudentName
        }
        
        
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("shdshhdw")
    }
    
    //MARK:-:- Button Action
    @IBAction func cancelAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(sender: UIButton){
        
        switch activityType {
            
        case .meal:
            guard let _classID = classID, let _sectionID = sectionID else {
                return displayError(withMessage: .selectClassAndSection)
            }
            //      guard let _fromDate = self.fromDate  else {
            //        return displayError(withMessage: .selectDate)
            //      }
            
            if selectedStudentsArray.count > 0{
                let story = UIStoryboard(name: "AddActivity", bundle: nil)
                let nextVC = story.instantiateViewController(withIdentifier: "AddMealVC") as! AddMealVC
                nextVC.selectedStudentsArray = selectedStudentsArray
                nextVC.classID = _classID
                nextVC.sectionID = _sectionID
                // nextVC.fromDate = _fromDate
                self.navigationController?.pushViewController(nextVC, animated: true)
            }else{
                displayError(withMessage: .selectStudent)
            }
            
        case .classroom:
            
            guard let _classID = classID, let _sectionID = sectionID else {
                return displayError(withMessage: .selectClassAndSection)
            }
            if selectedStudentsArray.count > 0{
                
                let story = UIStoryboard(name: "AddActivity", bundle: nil)
                let nextVC = story.instantiateViewController(withIdentifier: "AddClassRoomVC") as! AddClassRoomVC
                nextVC.selectedStudentsArray = selectedStudentsArray
                nextVC.classID = _classID
                nextVC.sectionID = _sectionID
                self.navigationController?.pushViewController(nextVC, animated: true)
                
                //        let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"ClassRoomDailyActivityVC") as! ClassRoomDailyActivityVC
                //        vc.activityType = activityType
                //        vc.addClassRoomRequest = addClassRoomRequest
                //        vc.selectedStudentsArray = selectedStudentsArray
                //        vc.classID = _classID
                //        vc.sectionID = _sectionID
                //        self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                displayError(withMessage: .selectStudent)
            }
            
        default:
            
            guard let _classID = classID, let _sectionID = sectionID else {
                return displayError(withMessage: .selectClassAndSection)
            }
            
            if let _napActivityDetails = viewDailyActivityDetails{
                
                let story = UIStoryboard(name: "AddActivity", bundle: nil)
                let nextVC = story.instantiateViewController(withIdentifier: "AddActivityVC") as! AddActivityVC
                nextVC.activityType = activityType
                nextVC.selectedStudentsArray = selectedStudentsArray
                nextVC.classID = _classID
                nextVC.sectionID = _sectionID
                nextVC.viewNapDailyActivityDetails = _napActivityDetails
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            }else{
                if selectedStudentsArray.count > 0{
                    
                    let story = UIStoryboard(name: "AddActivity", bundle: nil)
                    let nextVC = story.instantiateViewController(withIdentifier: "AddActivityVC") as! AddActivityVC
                    nextVC.activityType = activityType
                    nextVC.selectedStudentsArray = selectedStudentsArray
                    nextVC.classID = _classID
                    nextVC.sectionID = _sectionID
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    
                }else{
                    
                    displayError(withMessage: .selectStudent)
                }
            }
        }
    }
    
    @objc func selectStudent(sender: UIButton){
        
        guard let _classID = classID, let _sectionID = sectionID else {
            return displayError(withMessage: .selectClassAndSection)
        }
        
        let story = UIStoryboard(name: "AddActivity", bundle: nil)
        let studentListVC = story.instantiateViewController(withIdentifier: "StudentListVC") as! StudentListVC // abdul
        studentListVC.delegate = self
        studentListVC.userTypeArray = [.student]
        studentListVC.classID = _classID
        studentListVC.sectionID = _sectionID
        studentListVC.schoolID = UserManager.shared.currentUser?.school_id
        if let _napActivityDetails = viewDailyActivityDetails{
            
            if let _selectedStudentsArray = _napActivityDetails.students{
                
                studentListVC.selectedStudentsArray = _selectedStudentsArray
                
            }else{
                studentListVC.selectedStudentsArray = selectedStudentsArray
            }
        }else{
            
            studentListVC.selectedStudentsArray = selectedStudentsArray
        }
        
        studentListVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(studentListVC, animated: true, completion: nil)
    }
}

extension SelectStudentVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommonActivityCell", for: indexPath) as! AddCommonActivityCell
        
        cell.delegate = self
        cell.selectedUsers = selectedStudentsArray.map({$0.studentName})
        cell.lblActivityName.text = activityType.rawValue + " Activity"
        cell.dateTxtFld.tag = 4
        cell.dateTxtFld.delegate = self
        if let _napActivityDetails = viewDailyActivityDetails{
            
            cell.txtClass.text = _napActivityDetails.className
            cell.txtSection.text = _napActivityDetails.classSection
            
            self.classID = _napActivityDetails.classID
            self.sectionID = _napActivityDetails.sectionID
            
            cell.selectedUsers = selectedStudentsArray.map({$0.studentName})
            
        }else{
            cell.selectedUsers = selectedStudentsArray.map({$0.studentName})
        }
        cell.selectionStyle = .none
        
        cell.btnSelectStudent.addTarget(self, action: #selector(selectStudent), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
extension SelectStudentVC:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 4 {
            let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
            
            picker.dismissBlock = { date in
                self.selectedDate = date
                //self.fromDateSelected = date
                textField.text = date.asString(withFormat: "dd-MM-yyyy")
                self.fromDate = date.asString(withFormat: "yyyy-MM-dd")
                
            }
            return false
            
        }
        return true
    }
}
extension SelectStudentVC:sendSelectedEmailDelegate{
  
  func selectedTeachers(students: [TeacherListData], users: [MessageUserData]) {
    
  }
  
    func selectedStudents(students: [Student], users: [MessageUserData]) {
        selectedStudentsArray = students
        tblStudent.reloadData()
    }
    
    func classNameList(classData: [ClassModel], classId: Int) {
        
    }
    
    
    
    
    func selectedUsers(users: [MessageUserData]) {
        
    }
}

extension SelectStudentVC:sendSelectedDetailsDelegate{
    
    func getSelectedDetails(classID: Int, sectionID: Int, _ classModel: ClassModel, _ sectionModel: Section) {
        self.classID = classID
        self.sectionID = sectionID
    }
}
