//
//  StudentListVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 29/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol sendSelectedEmailDelegate {
  
  func selectedUsers(users : [MessageUserData])
  func selectedStudents(students : [Student],users:[MessageUserData])
  func selectedTeachers(students : [TeacherListData],users:[MessageUserData])
  func classNameList(classData:[ClassModel],classId:Int)
}

class StudentListVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tblStudent: UITableView!
  
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var txtSearch: CTTextField!
  @IBOutlet weak var vwSegement: CTSegmentControl!
  
  private var selectedUserType : UserType!
  private var userArray: [MessageUserData] = []
  private var studentArray: [Student] = []
  private var teacherArray: [TeacherListData] = []
  
  var schoolID:Int?
  var classID:Int?
  var sectionID:Int?
  var classArray:[ClassModel] = []
  var userTypeArray : [UserType] = []
  var delegate:sendSelectedEmailDelegate?
  var selectedUsersArray : [MessageUserData] = []
  var selectedStudentsArray : [Student] = []
  var selectedTeachersArray : [TeacherListData] = []
  var ClassList:Bool!
  var selectedclassArray:[ClassModel] = []
  var fromMessages:Bool = false
  var fromWeeklyMenu:Bool = false
  var checkClassId:Int?
  var checkStudentList:Bool = false
  
  
  lazy var viewModel : ComposeMessageViewModel   =  {
    return ComposeMessageViewModel()
  }()
  
  //MARK:- ViewController LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    classArray = SharedPreferenceManager.shared.classNameListArray
    
    // Do any additional setup after loading the view.
    tblStudent.tableFooterView = UIView()
    tblStudent.delegate = self
    tblStudent.dataSource = self
    //configView()
    viewModel.delegate = self
    
    vwSegement.segmentTitles = userTypeArray.map({$0.stringValue}).joined(separator: ",")
    selectedUserType = userTypeArray.first
    
    txtSearch.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    
    if let _schoolID = self.schoolID {
      
      if fromMessages{
        if let _classID = self.classID,let _sectionID = self.sectionID{
          
          viewModel.getUserList(search_user: "", send_to: userTypeArray.map({$0.rawValue}), school_id: _schoolID, classID: "\(_classID)", sectionID: "\(_sectionID)")
        }
        else{
          viewModel.getUserList(search_user: "", send_to: userTypeArray.map({$0.rawValue}), school_id: _schoolID, classID: "", sectionID: "")
        }
        
      }else if fromWeeklyMenu {
        
        if checkStudentList{
          
          if let id = checkClassId{
            
            viewModel.getStudentList(search_user: "", schoolId: _schoolID, classID: "\(id)", sectionID: "All")
          }
          
        }else{
          
          viewModel.getTeacherList(schoolId: _schoolID)
          
        }
        
      }else{
        viewModel.getStudentList(search_user: "", schoolId: _schoolID, classID: "\(self.classID ?? 0)", sectionID: "\(self.sectionID ?? 0)")
      }
    }
    
    
    if let userType = UserManager.shared.currentUser?.userType, let type = UserType(rawValue: userType) {
      
      switch type {
      case .admin,.teacher: schoolID = UserManager.shared.currentUser?.school_id
      default: break
      }
    }
    
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    
    if let _schoolID = self.schoolID {
      
      
      if fromMessages{
        
        if let _classID = self.classID,let _sectionID = self.sectionID {
          
          viewModel.getUserList(search_user: "", send_to: userTypeArray.map({$0.rawValue}), school_id: _schoolID, classID: "\(_classID)", sectionID: "\(_sectionID)")
        }
        else{
          viewModel.getUserList(search_user: "", send_to: userTypeArray.map({$0.rawValue}), school_id: _schoolID, classID: "", sectionID: "")
        }
        
      }
      else if fromWeeklyMenu {
        
        if let id  = self.checkClassId {
          
          viewModel.getStudentList(search_user: "", schoolId: _schoolID, classID: "\(id)", sectionID: "All")
        }
        else{
          viewModel.getTeacherList(schoolId: _schoolID)
        }
        
      }
        
        
      else{
        viewModel.getStudentList(search_user: textField.text!, schoolId: _schoolID, classID: "\(self.classID ?? 0)", sectionID: "\(self.sectionID ?? 0)")
        
      }
      
    }
  }
  
  @IBAction func segmentValueChanged(_ sender: CTSegmentControl) {
    
    guard let type = UserTypeTitle(rawValue: sender.selectedSegmentTitle), let userType = UserType(rawValue: type.id) else {
      return
    }
    
    selectedUserType = userType
    tblStudent.reloadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    mainView.roundCorners(corners: [.topLeft,.topRight], radius: 30.0)
  }
  
  //MARK:- Button Action
  
  @IBAction func cancelBtnAction(_ sender: Any) {
    
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func selectAllAction(_ sender: Any) {
    if ClassList == true {
      
    }
      
    else if !fromMessages{
      
      for item in studentArray {
        if !selectedStudentsArray.map({$0.id}).contains(item.id) {
          selectedStudentsArray.append(item)
        }
      }
    }
      
    else if fromWeeklyMenu{
      if checkStudentList{
        for item in studentArray {
          if !selectedStudentsArray.map({$0.id}).contains(item.id) {
            selectedStudentsArray.append(item)
          }
        }}
      else{
        for item in teacherArray {
          if !selectedTeachersArray.map({$0.id}).contains(item.id) {
            selectedTeachersArray.append(item)
          }
        }
        
      }
    }
      
      
    else {
      let users = userArray.filter({$0.detail.lowercased().contains("-\(selectedUserType.stringValue.lowercased())")})
      
      for item in users {
        if !selectedUsersArray.map({$0.id}).contains(item.id) {
          selectedUsersArray.append(item)
        }
      }
    }
    
    tblStudent.reloadData()
  }
  
  @IBAction func applyBtnAction(sender: UIButton){
    
    if ClassList == true {
      if selectedclassArray.isEmpty {
        displayServerError(withMessage: "Please Select Class")
      }
      else{
        self.checkClassId = selectedclassArray.first?.id
        delegate?.classNameList(classData: selectedclassArray, classId: self.checkClassId ?? 0)
      }
      
    }else{
      
      guard !selectedUsersArray.isEmpty || !selectedStudentsArray.isEmpty || !selectedTeachersArray.isEmpty else {
        displayServerError(withMessage: "Please select a \(selectedUserType.stringValue)")
        return
      }
      
      if fromMessages{
        delegate?.selectedStudents(students: selectedStudentsArray,users: selectedUsersArray)
        
      }else if fromWeeklyMenu{
        
        if checkStudentList{
          delegate?.selectedStudents(students: selectedStudentsArray,users: selectedUsersArray)
          
        }else{
          delegate?.selectedTeachers(students: selectedTeachersArray, users: selectedUsersArray)
        }
      }
    }
    self.dismiss(animated: true, completion: nil)
    
  }
  
  //MARK:- Button Action
  @objc func selectChild( _ sender: BEMCheckBox){
    
    if ClassList == true {
      
      if let index =  selectedclassArray.firstIndex(where: {$0.id == classArray[sender.tag].id}) {
        selectedclassArray.remove(at: index)
        
      }else{
        selectedclassArray.append(classArray[sender.tag])
        self.checkClassId = classArray[sender.tag].id
      }
      
    }else if fromMessages{
      
      let users = userArray.filter({$0.detail.lowercased().contains("-\(selectedUserType.stringValue.lowercased())")})
      
      if let index = selectedUsersArray.firstIndex(where: {$0.id == users[sender.tag].id}) {
        selectedUsersArray.remove(at: index)
      }
      else {
        selectedUsersArray.append(users[sender.tag])
      }
      
    }else if fromWeeklyMenu{
      
      if checkStudentList{
        
        if let index = selectedStudentsArray.firstIndex(where: {$0.id == studentArray[sender.tag].id}) {
          
          selectedStudentsArray.remove(at: index)
          selectedUsersArray.remove(at: index)
          
          let users = userArray.filter({$0.detail.lowercased().contains("-\(selectedUserType.stringValue.lowercased())")})
          selectedUsersArray.append(users[sender.tag])
          
        }else {
          
          selectedStudentsArray.append(studentArray[sender.tag])
        }
        
      }else{
        
        if let index = selectedTeachersArray.firstIndex(where: {$0.id == teacherArray[sender.tag].id}) {
          selectedTeachersArray.remove(at: index)
        }else {
          selectedTeachersArray.append(teacherArray[sender.tag])
        }
      }
      
    }else{
      let users = userArray.filter({$0.detail.lowercased().contains("-\(selectedUserType.stringValue.lowercased())")})
      
      if let index = selectedUsersArray.firstIndex(where: {$0.id == users[sender.tag].id}) {
        selectedUsersArray.remove(at: index)
      }
      else {
        selectedUsersArray.append(users[sender.tag])
      }
    }
    tblStudent.reloadData()
  }
}


extension StudentListVC{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if ClassList == true {
      return classArray.count
      
    }else if fromMessages {
      return userArray.filter({$0.detail.lowercased().contains("-\(selectedUserType.stringValue.lowercased())")}).count
      
    }else if fromWeeklyMenu{
      
      if checkStudentList{
        return studentArray.count
      }else{
        return teacherArray.count
      }
      
    }else {
      return userArray.filter({$0.detail.lowercased().contains("-\(selectedUserType.stringValue.lowercased())")}).count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "studentListCell", for: indexPath) as! studentListCell
    cell.checkBox.tag = indexPath.row
    
    if ClassList == true {
      cell.lblName.text = classArray[indexPath.row].className
      
    }else if fromMessages{
      
      let user = userArray.filter({$0.detail.lowercased().contains("-\(selectedUserType.stringValue.lowercased())")})[indexPath.row]
      let selectedUsers = selectedUsersArray.filter({$0.detail.lowercased().contains("-\(selectedUserType.stringValue.lowercased())")})
      
      cell.lblName.text = user.detail.replacingOccurrences(of: "-\(selectedUserType.stringValue.lowercased())", with: "")
      
      if selectedUsers.map({$0.id}).contains(user.id) {
        cell.checkBox.on = true
      }
      else {
        cell.checkBox.on = false
      }
    }else if fromWeeklyMenu {
      
      if checkStudentList{
        
        let student = studentArray[indexPath.row]
        
        cell.lblName.text = student.studentName
        
        if selectedStudentsArray.map({$0.id}).contains(student.id) {
          cell.checkBox.on = true
        }
        else {
          cell.checkBox.on = false
        }
        
      }else{
        
        let teacher = teacherArray[indexPath.row]
        
        cell.lblName.text = teacher.firstname
        
        if selectedTeachersArray.map({$0.id}).contains(teacher.id) {
          cell.checkBox.on = true
        }
        else {
          cell.checkBox.on = false
        }
      }
      
    }else {
      
      let user = userArray.filter({$0.detail.lowercased().contains("-\(selectedUserType.stringValue.lowercased())")})[indexPath.row]
      let selectedUsers = selectedUsersArray.filter({$0.detail.lowercased().contains("-\(selectedUserType.stringValue.lowercased())")})
      
      cell.lblName.text = user.detail.replacingOccurrences(of: "-\(selectedUserType.stringValue.lowercased())", with: "")
      
      if selectedUsers.map({$0.id}).contains(user.id) {
        cell.checkBox.on = true
      }
      else {
        cell.checkBox.on = false
      }
    }
    
    cell.checkBox.addTarget(self, action: #selector(selectChild(_:)), for: .valueChanged)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return UITableView.automaticDimension
  }
  
}

//MARK:- ComposeMessage Delegate Methodes

extension StudentListVC: composeMessageDelegate{
  
  func getTeacherListSuccessfull(teacherList: [TeacherListData]) {
    self.teacherArray = teacherList
    tblStudent.reloadData()
  }
  
  
  func getStudentListSuccessfull(studentList: [Student]) {
    self.studentArray = studentList
    tblStudent.reloadData()
  }
  
  func messageUserListSuccessfull(messageData: [MessageUserData]?){
    
    if let _messageData = messageData{
      userArray = _messageData
    }
    tblStudent.reloadData()
  }
  
  func failure(message: String) {
    userArray.removeAll()
    studentArray.removeAll()
    teacherArray.removeAll()
    tblStudent.reloadData()
  }
}


