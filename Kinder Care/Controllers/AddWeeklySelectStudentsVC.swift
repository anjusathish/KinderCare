 //
 //  AddWeeklySelectStudentsVC.swift
 //  Kinder Care
 //
 //  Created by Ragavi Rajendran on 14/01/20.
 //  Copyright © 2020 Athiban Ragunathan. All rights reserved.
 //
 
 import UIKit
 import DropDown
 
 class AddWeeklySelectStudentsVC: BaseViewController {
  
  @IBOutlet var selectStudentsTableView: UITableView!
  
  var classId : Int?
  var selectedUsers : [MessageUserData] = []
  var selectedStudent : [Student] = []
  var selectedTeacher : [TeacherListData] = []
  var delegate : EditSelectedMenuDelegate?
  
  var selectedMenuItems : [Menu] = []
  var savaSelectedMenuItems: [Menu] = []
  var selectedDate : Date!
  var courseTypeArray = [CourseType]()
  var menuItemsArray = [MenuItem]()
  var isEdit: Bool = false
  var weeklyMenuID: String = ""
  var classArray = [ClassModel]()
  var classNameTxtFld:String?
  var classIdArray:[Int]?
  var checkClassID:Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    topBarHeight = 70
    titleString = "ADD WEEKLY MENU"
    
    self.selectStudentsTableView.register(UINib(nibName: "AddWeeklySelectStudentsHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "AddWeeklySelectStudentsHeader")
    
    self.selectStudentsTableView.register(UINib(nibName: "SelectedStudentsTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectedStudentsTableViewCell")
    
    // Do any additional setup after loading the view.
  }
  
  func showDropDown(sender : UITextField, content : [String]) {
    
    let dropDown = DropDown()
    dropDown.direction = .any
    dropDown.anchorView = sender
    dropDown.dismissMode = .automatic
    dropDown.dataSource = content
    
    dropDown.selectionAction = { (index: Int, item: String) in
      sender.text = item
      self.classId = SharedPreferenceManager.shared.classNameListArray[index].id
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
  
  //MARK:- Button Action
  
  @IBAction func backBtnAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func nextBtnAction(_ sender: Any) {
    
    guard let _classId = classIdArray else {
      return displayError(withMessage: .className)
    }
    
    if self.classIdArray?.count ?? 0 < 2 {
      
//      guard !selectedUsers.filter({$0.detail.lowercased().contains("-\(UserType.student.stringValue.lowercased())")}).isEmpty else {
//        return displayError(withMessage: .selectStudent)
//      }
      
    }
    
//    guard !selectedUsers.filter({$0.detail.lowercased().contains("-\(UserType.teacher.stringValue.lowercased())")}).isEmpty else {
//      return displayError(withMessage: .selectTeacher)
//    }
    
    if selectedStudent.count == 0 {
      return displayError(withMessage: .selectStudent)
      
    }
    if selectedTeacher.count == 0 {
      return displayError(withMessage: .selectTeacher)
    }
    
    
    
    guard let _date = selectedDate else {
      return displayError(withMessage: .selectDate)
    }
    
    let storyBoard = UIStoryboard.AddWeeklyMenuStoryboard()
    let vc = storyBoard.instantiateViewController(withIdentifier: "AddWeeklyPreviewVC") as! AddWeeklyPreviewVC
    vc.selectedMenuItems = selectedMenuItems
    vc.selectedDate = _date
    vc.classId = _classId.first
    vc.selectedUsers = selectedUsers
    vc.strSelectedClasses = self.classNameTxtFld ?? ""
    vc.courseTypeArray = courseTypeArray
    vc.menuItemsArray = menuItemsArray
    vc.delegate = delegate
    vc.isEdit = isEdit
    vc.weeklyMenuID  = weeklyMenuID
    vc.selectedStudent = selectedStudent
    vc.selectedTeacher = selectedTeacher
    vc.savaSelectedMenuItems = savaSelectedMenuItems
    
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  @objc func selectStudent(sender: UIButton){
    
    let story = UIStoryboard(name: "AddActivity", bundle: nil)
    let studentListVC = story.instantiateViewController(withIdentifier: "StudentListVC") as! StudentListVC
    
    if sender.tag == 0 {
      studentListVC.userTypeArray = [.student]
      studentListVC.checkStudentList = true
    }
    else {
      studentListVC.userTypeArray = [.teacher]
      studentListVC.checkStudentList = false
    }
    
    studentListVC.delegate = self
    studentListVC.selectedUsersArray = selectedUsers
    studentListVC.schoolID = UserManager.shared.currentUser?.school_id
    studentListVC.fromWeeklyMenu = true
    studentListVC.checkClassId = self.checkClassID
    studentListVC.modalPresentationStyle = .overCurrentContext
    
    self.navigationController?.present(studentListVC, animated: true, completion: nil)
  }
 }
 
 extension AddWeeklySelectStudentsVC : UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedStudentsTableViewCell", for: indexPath) as! SelectedStudentsTableViewCell
    
    cell.activityTypeView.isHidden = true
    
    if let attributedTitle =  cell.editBtn.attributedTitle(for: .normal) {
      let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
      mutableAttributedTitle.replaceCharacters(in: NSMakeRange(0, mutableAttributedTitle.length), with: "Add/Remove")
      cell.editBtn.setAttributedTitle(mutableAttributedTitle, for: .normal)
      cell.editBtn.addTarget(self, action: #selector(selectStudent), for: .touchUpInside)
    }
    
    cell.editBtn.tag = indexPath.row
    
    if indexPath.row == 0 {
      
      if self.classIdArray?.count ?? 0 > 1{
        cell.editBtn.isHidden = true
      }
      
      cell.selectLbl.text = "Select Students"
      //cell.selectedUsers = selectedUsers.filter({$0.detail.lowercased().contains("-\(UserType.student.stringValue.lowercased())")}).map({$0.detail.replacingOccurrences(of: "-\(UserType.student.stringValue.lowercased())", with: "")})
      
      cell.selectedUsers = selectedStudent.map({$0.studentName})
      
      // cell.selectedUsers = selectedStudent.filter({$0.studentName.lowercased().contains("-\(UserType.student.stringValue.lowercased())")}).map({$0.studentName.replacingOccurrences(of: "-\(UserType.student.stringValue.lowercased())", with: "")})
      
      
    }
    else
    {
      cell.selectLbl.text = "Select Teachers"
      // cell.selectedUsers = selectedUsers.filter({$0.detail.lowercased().contains("-\(UserType.teacher.stringValue.lowercased())")}).map({$0.detail.replacingOccurrences(of: "-\(UserType.teacher.stringValue.lowercased())", with: "")})
      
      cell.selectedUsers = selectedTeacher.map({$0.firstname})
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AddWeeklySelectStudentsHeader") as! AddWeeklySelectStudentsHeader
    headerView.classTxt.delegate = self
    
    headerView.classTxt.text = classNameTxtFld ?? ""
    
    
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 120
  }
 }
 
 extension AddWeeklySelectStudentsVC : UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    let story = UIStoryboard(name: "AddActivity", bundle: nil)
    let studentListVC = story.instantiateViewController(withIdentifier: "StudentListVC") as! StudentListVC
    studentListVC.ClassList = true
    studentListVC.delegate = self
    studentListVC.fromWeeklyMenu = true
    studentListVC.modalPresentationStyle = .overCurrentContext
    self.navigationController?.present(studentListVC, animated: true, completion: nil)
    
    
    
    // showDropDown(sender: textField, content: SharedPreferenceManager.shared.classNameListArray.map({$0.className}))
    return false
  }
 }
 
 extension AddWeeklySelectStudentsVC: sendSelectedEmailDelegate{
  
  func selectedTeachers(students: [TeacherListData], users: [MessageUserData]) {
    print(students)
    selectedTeacher = students
    selectStudentsTableView.reloadData()
    
  }
  
  
  func selectedStudents(students: [Student], users: [MessageUserData]) {
    print(students)
    selectedStudent = students
    selectedUsers = users
    selectStudentsTableView.reloadData()
  }
  
  func classNameList(classData: [ClassModel], classId: Int) {
    classArray = classData
    
    let classStr = classArray.map({$0.className})
    classNameTxtFld = classStr.joined(separator: ", ")
    classIdArray = classData.map({($0.id ?? 0)})
    self.checkClassID = classId
    
    if self.classIdArray?.count ?? 0 > 1 {
      self.selectedUsers = selectedUsers.filter({$0.detail.lowercased().contains("-\(UserType.teacher.stringValue.lowercased())")})
    }
    
    selectStudentsTableView.reloadData()
  }
  func selectedUsers(users: [MessageUserData]) {
    selectedUsers = users
    selectStudentsTableView.reloadData()
  }
 }
