//
//  AddMealVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 02/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import DropDown

class AddMealVC: BaseViewController{
  
  @IBOutlet var addMealTableView: UITableView!
  @IBOutlet var txtStartDate: CTTextField!
  @IBOutlet var txtEndDate: CTTextField!
  @IBOutlet weak var txtviewDescription: UITextView!
   @IBOutlet var dateTxtFld: CTTextField!
  
  var customPickerObj : CustomPicker!
  var courseTypeArray = [CourseType]()
  var menuItemsArray = [MenuItem]()
  public var selectedStudentsArray : [Student] = []
  
  private var classId : Int?
  private var selectedUsers : [MessageUserData] = []
  
  var selectedMenuItems: [Menu] = []
  var selectedMenuItemsID:String = ""
  var selectedDate : Date?
  var chooseStartTime: Date?
    var fromDate:String?
  lazy var viewModel : WeeklyMenuViewModel = {
    return WeeklyMenuViewModel()
  }()
  
  public var classID : Int?
  public var sectionID : Int?
  
  private var startTime: String?
  private var endTime: String?
  private var textviewDescription: String?
  var fromDateSelected: Date?

  //MARK:- ViewController Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleString = "ADD MEAL ACTIVITY"
    
    viewModel.delegate = self
    viewModel.courseTypeList()
    
    addMealTableView.register(UINib(nibName: "AddMealActivityCell", bundle: nil), forCellReuseIdentifier: "AddMealActivityCell")
    addMealTableView.register(UINib(nibName: "AddMealHeaderCell", bundle: nil), forCellReuseIdentifier: "AddMealHeaderCell")
    
    let footerView = Component(frame: .zero)
    footerView.configure(text: "+ Add More")
    let tap = UITapGestureRecognizer(target: self, action: #selector(addMoreAction(gesture:)))
    footerView.label.addGestureRecognizer(tap)
    addMealTableView.tableFooterView = footerView
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    updateHeaderViewHeight(for: addMealTableView.tableFooterView)
  }
  
  func updateHeaderViewHeight(for header: UIView?) {
    guard let header = header else { return }
    header.frame.size.height = 80
  }
  
  func addNewCourseType() {
    
    guard let courseTypeId = courseTypeArray.first?.id else {
      return
    }
    
    if let itemId = menuItemsArray.first?.id {
      selectedMenuItems.append(Menu(date: "", courseType: "\(courseTypeId)", item: ["\(itemId)"],items: [""]))
    }
    else {
      selectedMenuItems.append(Menu(date: "", courseType: "\(courseTypeId)", item: [""], items: [""]))
    }
    print(selectedMenuItems)
    
    addMealTableView.reloadData()
  }
  
  func modifyCourseType(forCourse id : String) {
    
    
    if let index = selectedMenuItems.firstIndex(where: {$0.courseType == id}) {
      
      if let menusForCourse = menuItemsArray.filter({"\($0.courseType)" == id}).first {
        selectedMenuItems[index].item = ["\(menusForCourse.id)"]
      }
      else {
        selectedMenuItems[index].item = [""]
      }
    }
    
    addMealTableView.reloadData()
  }
  
  func showDropDown(sender : UITextField, content : [String]) {
    
    let dropDown = DropDown()
    dropDown.direction = .any
    dropDown.anchorView = sender
    dropDown.dismissMode = .automatic
    dropDown.dataSource = content
    
    dropDown.selectionAction = { (index: Int, item: String) in
      sender.text = item
      
      if let cell = sender.superview?.superview as? AddMealHeaderCell, sender == cell.txtMeal {
        
        guard let indexPath = self.addMealTableView.indexPath(for: cell) else { return }
        
        let courseTypeArray = self.courseTypeArray.filter({!self.selectedMenuItems.map({$0.courseType}).contains("\($0.id)")})
        
        self.selectedMenuItems[indexPath.section].courseType = "\(courseTypeArray[index].id)"
        
        guard let schoolId = UserManager.shared.currentUser?.school_id else { return }
        self.viewModel.getMenuItems(forCourse: "\(courseTypeArray[index].id)", forSchool: "\(schoolId)")
      }
      else if let cell = sender.superview?.superview?.superview as? AddMealActivityCell, sender == cell.txtMeal {
        
        guard let indexPath = self.addMealTableView.indexPath(for: cell) else { return }
        
        self.selectedMenuItems[indexPath.section].item[indexPath.row-1] = "\(self.menuItemsArray.filter({"\($0.courseType)" == self.selectedMenuItems[indexPath.section].courseType})[index].id)"
        
        let _selectedMenuItemsID = "\(self.menuItemsArray.filter({"\($0.courseType)" == self.selectedMenuItems[indexPath.section].courseType})[index].id)"
        self.selectedMenuItemsID = _selectedMenuItemsID
//        let sID = Int(self.selectedMenuItemsID)
     //   menuItemsArray.a
               
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
  
  //MARK:- Button Action
  
  @objc func addMoreAction(gesture : UITapGestureRecognizer) {
    
    let courseTypeArray = self.courseTypeArray.filter({!selectedMenuItems.map({$0.courseType}).contains("\($0.id)")})
    
    guard let courseTypeId = courseTypeArray.first?.id else {
      displayError(withMessage: .coursesAdded)
      return
    }
    
    if let itemId = menuItemsArray.filter({"\($0.courseType)" == "\(courseTypeId)"}).first?.id {
      selectedMenuItems.append(Menu(date: "", courseType: "\(courseTypeId)", item: ["\(itemId)"], items: [""]))
    }
    else {
      selectedMenuItems.append(Menu(date: "", courseType: "\(courseTypeId)", item: [""], items: [""]))
    }
    
    guard let schoolId = UserManager.shared.currentUser?.school_id else { return }
    self.viewModel.getMenuItems(forCourse: "\(courseTypeId)", forSchool: "\(schoolId)")
    
    addMealTableView.reloadData()
  }
  
  @IBAction func nextBtnAction(_ sender: Any) {
    
     guard let _fromDate = self.fromDate else {
      return displayError(withMessage: .selectDate)
    }
    
    guard let _textviewDescription = textviewDescription else {
         return displayError(withMessage: .description)
       }
    
    let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"MealActivityVC") as! MealActivityVC
    //vc.activityType = ActivityType(rawValue: "Meal")
    vc.selectedMenuItems = selectedMenuItems
    vc.courseTypeArray = courseTypeArray
    vc.menuItemsArray = menuItemsArray
    vc.selectedStudentsArray = selectedStudentsArray
    vc.startDate = startTime ?? "00:00"
    vc.endDate = endTime ?? "00:00"
    vc.txtviewDescription = _textviewDescription
    vc.classID = classID
    vc.sectionID = sectionID
    vc.fromDate = _fromDate
    vc.selectedMenuItemsID = selectedMenuItemsID
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func backBtnAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func dismissKeyboard() {
    self.view.endEditing(true)
  }
}


extension AddMealVC : UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return selectedMenuItems.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedMenuItems[section].item.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let courseCell:AddMealHeaderCell = tableView.dequeueReusableCell(withIdentifier: "AddMealHeaderCell") as! AddMealHeaderCell
    courseCell.isFirstRow = false
    courseCell.isLastRow = false
    courseCell.txtMeal.delegate = self
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "AddMealActivityCell", for: indexPath) as! AddMealActivityCell
    cell.isFirstRow = false
    cell.isLastRow = false
    cell.btnAdd.isHidden = true
    cell.txtMeal.delegate = self
    cell.btnAdd.addTarget(self, action: #selector(addNewField(sender:)), for: .touchUpInside)
    cell.btnRemove.addTarget(self, action: #selector(removeField(sender:)), for: .touchUpInside)
    
    if indexPath.row == 0 {
      courseCell.isFirstRow = true
      
      if self.courseTypeArray.filter({!selectedMenuItems.map({$0.courseType}).contains("\($0.id)")}).isEmpty {
        courseCell.txtMeal.rightImage = nil
      }
      else {
        courseCell.txtMeal.rightImage = UIImage(named: "downArrow")
      }
      
      if let index = courseTypeArray.firstIndex(where: {"\($0.id)" == selectedMenuItems[indexPath.section].courseType}) {
        courseCell.txtMeal.text = courseTypeArray[index].name  //idu ila
      }
      
      return courseCell
    }
    else {
        
        let itemId = selectedMenuItems[indexPath.section].item[indexPath.row-1]
            print("ItemID \(itemId)" )
            
            let filteredMenuItems = menuItemsArray.filter({"\($0.courseType)" == selectedMenuItems[indexPath.section].courseType})
              
            if let itemIndex = filteredMenuItems.firstIndex(where: {"\($0.id)" == itemId}) {
              
              cell.txtMeal.text = filteredMenuItems[itemIndex].foodDetails
            }
            else {
              cell.txtMeal.text = "Select Meal"
            }
            
            if indexPath.row == selectedMenuItems[indexPath.section].item.count {
              cell.isLastRow = true
              cell.btnAdd.isHidden = false
            }
      
//      let itemId = selectedMenuItems[indexPath.section].item[indexPath.row-1]
//
//      if let index = menuItemsArray.filter({"\($0.courseType)" == selectedMenuItems[indexPath.section].courseType}).firstIndex(where: {"\($0.id)" == itemId}) {
//        cell.txtMeal.text = menuItemsArray[index].foodDetails //while getting old data
//        selectedMenuItemsID = "\(menuItemsArray[index].id)"
//      }
//      else {
//        cell.txtMeal.text = "Select Meal"
//      }
//
//      if indexPath.row == selectedMenuItems[indexPath.section].item.count {
//        cell.isLastRow = true
//        cell.btnAdd.isHidden = false
//       // selectedMenuItemsID.remove(at: indexPath.row)
//      }
      
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    if section == 0 {
      return 40
    }
    else {
      return 20
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: 20)))
    view.backgroundColor = .white
    
    let label = UILabel(frame: view.frame)
    label.frame.origin.x = 15
    label.frame.origin.y = 15
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = .black
    
    if section == 0 {
      label.text = "Course and Items"
    }
    
    view.addSubview(label)
    
    return view
  }
  
  @objc func addNewField(sender: UIButton){
    
    if let cell = sender.superview?.superview?.superview?.superview?.superview as? AddMealActivityCell, let indexpath = addMealTableView.indexPath(for: cell) {
      
      if let lastItem = selectedMenuItems[indexpath.section].item.last, lastItem.isEmpty {
        displayError(withMessage: .selectMeal)
        return
      }
      
      selectedMenuItems[indexpath.section].item.append("")
      addMealTableView.reloadData()
    }
  }
  
  @objc func removeField(sender: UIButton){
    
    if let cell = sender.superview?.superview?.superview?.superview?.superview as? AddMealActivityCell, let indexpath = addMealTableView.indexPath(for: cell) {
      selectedMenuItems[indexpath.section].item.remove(at: indexpath.row - 1)
      
      if selectedMenuItems[indexpath.section].item.isEmpty {
        selectedMenuItems.remove(at: indexpath.section)
      }
      
      addMealTableView.reloadData()
    }
  }
}

extension AddMealVC :UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    if let cell = textField.superview?.superview as? AddMealHeaderCell {
      showDropDown(sender: cell.txtMeal, content: courseTypeArray.filter({!selectedMenuItems.map({$0.courseType}).contains("\($0.id)")}).map({$0.name}))
      return false
    }
    else if let cell = textField.superview?.superview?.superview as? AddMealActivityCell, let indexPath = addMealTableView.indexPath(for: cell) {
      showDropDown(sender: cell.txtMeal, content: menuItemsArray.filter({"\($0.courseType)" == selectedMenuItems[indexPath.section].courseType}).map({$0.foodDetails}))
      return false
      
    }else if textField == dateTxtFld{
        
        let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
        
        picker.dismissBlock = { date in
            self.selectedDate = date
            //self.fromDateSelected = date
            textField.text = date.asString(withFormat: "dd-MM-yyyy")
            self.fromDate = date.asString(withFormat: "yyyy-MM-dd")
            
        }
        return false
    }
    else if textField == txtStartDate{
        
        let vc = UIStoryboard.attendanceStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
            
            vc.mode = .time
            //vc.minimumDate = chooseStartTime?.addingTimeInterval(60)
           // textFieldEndTime = textField.text!
            vc.dismissBlock = { dataObj in
                textField.text = dataObj.getasString(inFormat: "hh:mm a")
                self.startTime = dataObj.getasString(inFormat: "HH:mm")
            }
            present(controllerInSelf: vc)
        return false
        
    }
    else if textField == txtEndDate{
        let vc = UIStoryboard.attendanceStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
            
            vc.mode = .time
            vc.minimumDate = chooseStartTime?.addingTimeInterval(60)
           // textFieldEndTime = textField.text!
            vc.dismissBlock = { dataObj in
                textField.text = dataObj.getasString(inFormat: "hh:mm a")
                self.endTime = dataObj.getasString(inFormat: "HH:mm")
            }
            present(controllerInSelf: vc)
        return false
        

    }
    return true
  }
}
extension AddMealVC: UITextViewDelegate{
  func textViewDidEndEditing(_ textView: UITextView) {
    textviewDescription = textView.text
  }
}
extension AddMealVC:WeeklyMenuDelegate{
  
  func menuItemsListSuccess(items: [MenuItem], forCourse id: String) {
    
    for item in items {
      if !self.menuItemsArray.map({$0.id}).contains(item.id) {
        self.menuItemsArray.append(item)
      }
    }
    
    if selectedMenuItems.isEmpty {
      addNewCourseType()
    }
    else {
      modifyCourseType(forCourse: id)
    }
  }
  
  func courseTypeListSuccess(courseType: [CourseType]) {
    courseTypeArray = courseType
    
    guard let courseId = courseTypeArray.first?.id, let schoolId = UserManager.shared.currentUser?.school_id else { return }
    
    viewModel.getMenuItems(forCourse: "\(courseId)", forSchool: "\(schoolId)")
  }
  
  func failure(message: String) {
    displayServerError(withMessage: message)
  }
  
}

extension AddMealVC : EditSelectedMenuDelegate {
  
  func selectedUsers(forClass classId: Int, users: [MessageUserData]) {
    self.classId = classId
    self.selectedUsers = users
  }
}
