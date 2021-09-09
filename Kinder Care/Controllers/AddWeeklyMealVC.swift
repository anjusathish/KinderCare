//
//  AddWeeklyMealVC.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 13/01/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit
import DropDown

class Component: UIView {
  
  let label = UILabel(frame: .zero)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
      label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
      label.topAnchor.constraint(equalTo: topAnchor),
      label.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
  
  func configure(text: String) {
    
    let textRange = NSMakeRange(0, text.count)
    label.textAlignment = .center
    label.isUserInteractionEnabled = true
    let attributedText = NSMutableAttributedString(string: text)
    attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
    attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.ctYellow, range: textRange)
    label.attributedText = attributedText
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - AddWeeklyMenuRequest
struct AddWeeklyMenuRequest: Codable {
  let schoolID: String
  let date: String
  let data: [Menu]
  let classID:[String]
  let studentID, teacherID: [String]
  
  enum CodingKeys: String, CodingKey {
    case schoolID = "school_id"
    case data
    case date
    case classID = "class_id"
    case studentID = "student_id"
    case teacherID = "teacher_id"
  }
}

// MARK: - Datum
struct SelectedMenu: Codable {
  let date: String
  var courseDetail: [Menu]
  
  enum CodingKeys: String, CodingKey {
    case date
    case courseDetail = "course_detail"
  }
}

// MARK: - CourseDetail
struct CourseDetail: Codable {
  let courseType, item: String?
  
  enum CodingKeys: String, CodingKey {
    case courseType = "course_type"
    case item
  }
}


// MARK: - AddMenuRequest
struct AddMenuRequest: Codable {
  let schoolID, date: String
  let data: [Menu]
  let classID: String
  let studentID, teacherID: [String]
  
  enum CodingKeys: String, CodingKey {
    case schoolID = "school_id"
    case date, data
    case classID = "class_id"
    case studentID = "student_id"
    case teacherID = "teacher_id"
  }
}

// MARK: - Datum
struct Menu: Codable {
  let date: String
  var courseType: String
  var item: [String]
  let items: [String]
  
  enum CodingKeys: String, CodingKey {
    case date
    case courseType = "course_type"
    case item
    case items
  }
}

class AddWeeklyMealVC: BaseViewController {
  
  @IBOutlet var addMealTableView: UITableView!
  @IBOutlet var txtDateofBirth: CTTextField!
  @IBOutlet weak var calendarView: CTDayCalender!
  
  var customPickerObj : CustomPicker!
  var courseTypeArray = [CourseType]()
  var menuItemsArray = [MenuItem]()
  
  private var classId : Int?
  private var selectedUsers : [MessageUserData] = []
  
  var selectedMenuItems : [Menu] = []
  var savaSelectedMenuItems: [Menu] = []
  var addSelectedMenuItemes: [CourseDetail] = []
  var selectedDate : Date?
  
  lazy var viewModel : WeeklyMenuViewModel = {
    return WeeklyMenuViewModel()
  }()
  
  var currentDate = ""
  var weeklyMenuItems: [WeeklyMenuItem] = []
  var arrayMenuItems: [Int] = []
  var editWeeklyMenuData:[DatumDish] = []
  
  let dispatchGroup = DispatchGroup()
  let window = UIApplication.shared.windows.first
  
  //MARK:- ViewController Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleString = "ADD WEEKLY MENU"
    
    viewModel.delegate = self
    viewModel.courseTypeList()
      
    addMealTableView.register(UINib(nibName: "AddMealActivityCell", bundle: nil), forCellReuseIdentifier: "AddMealActivityCell")
    addMealTableView.register(UINib(nibName: "AddMealHeaderCell", bundle: nil), forCellReuseIdentifier: "AddMealHeaderCell")
    
    let footerView = Component(frame: .zero)
    footerView.configure(text: "+ Add More")
    let tap = UITapGestureRecognizer(target: self, action: #selector(addMoreAction(gesture:)))
    footerView.label.addGestureRecognizer(tap)
    addMealTableView.tableFooterView = footerView
    
    txtDateofBirth.text = Date().asString(withFormat: "dd MMMM yyyy")
    selectedDate = Date()
     txtDateofBirth.delegate = self
    txtDateofBirth.delegate = self
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    if let editDate = dateFormatter.date(from: editWeeklyMenuData.first?.date ?? ""){
      calendarView.date = editDate
      currentDate = self.calendarView.date.getasString(inFormat: "yyyy-MM-dd")
      print(currentDate)
     
    }else{
      currentDate = self.calendarView.date.getasString(inFormat: "yyyy-MM-dd")
      print(currentDate)
      
    }
    
    //  savaSelectedMenuItems.removeAll()
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    updateHeaderViewHeight(for: addMealTableView.tableFooterView)
  }
  
  func updateHeaderViewHeight(for header: UIView?) {
    guard let header = header else { return }
    header.frame.size.height = 80
  }
  
  override func viewWillAppear(_ animated: Bool) {
    print(selectedMenuItems.count)
  }
  
  func addNewCourseType() {
    
    guard let courseTypeId = courseTypeArray.first?.id else {
      return
    }
    
    if weeklyMenuItems.count > 0 {
      print(weeklyMenuItems)
      
      for weekMenuItem in weeklyMenuItems {
        
        if let menuItems = weekMenuItem.items {
          
          if let coureType = weekMenuItem.courseType {
            
            if let index = self.selectedMenuItems.firstIndex(where: {$0.courseType == "\(coureType)"}) {
              
              arrayMenuItems.append(menuItems)
              print(arrayMenuItems)
              selectedMenuItems[index].item = arrayMenuItems.map{String($0)}
              savaSelectedMenuItems[index].item = arrayMenuItems.map{String($0)}
              print(selectedMenuItems)
              addMealTableView.reloadData()
              
            }else{
              arrayMenuItems.removeAll()
              arrayMenuItems.append(menuItems)
              print(arrayMenuItems)
              
              
              self.selectedMenuItems.append(Menu(date: currentDate, courseType: "\(coureType)", item: arrayMenuItems.map{String($0)}, items: [""]))
              self.savaSelectedMenuItems.append(Menu(date: currentDate, courseType: "\(coureType)", item: arrayMenuItems.map{String($0)}, items: [""]))
              print(self.selectedMenuItems)
              
              MBProgressHUD.showAdded(to: self.window!, animated: true)
              dispatchGroup.enter()
              
              guard let schoolId = UserManager.shared.currentUser?.school_id else { return }
              self.viewModel.getMenuItems(forCourse: "\(coureType)", forSchool: "\(schoolId)")
              print("CallAPI")

              dispatchGroup.notify(queue: .main) {
                
                MBProgressHUD.hide(for: self.window!, animated: true)
              }
              
              addMealTableView.reloadData()
              
            }
          }
        }
      }
      
    }else{
      
      if let itemId = menuItemsArray.first?.id {
        selectedMenuItems.append(Menu(date: currentDate, courseType: "\(courseTypeId)", item: ["\(itemId)"], items: [""]))
        savaSelectedMenuItems.append(Menu(date: currentDate, courseType: "\(courseTypeId)", item: ["\(itemId)"], items: [""]))
        print(savaSelectedMenuItems)
      }
      else {
        selectedMenuItems.append(Menu(date: currentDate, courseType: "\(courseTypeId)", item: [""], items: [""]))
        savaSelectedMenuItems.append(Menu(date: currentDate, courseType: "\(courseTypeId)", item: [""], items: [""]))
        print(savaSelectedMenuItems)
        print(selectedMenuItems)
      }
    }
    
    addMealTableView.reloadData()
  }
  
  func modifyCourseType(forCourse id : String) {
    
    let getDateArray = self.savaSelectedMenuItems.filter({$0.date == self.currentDate})
    
    if let selectedIndex = getDateArray.firstIndex(where: {$0.courseType == id}) {
      
      if let index = selectedMenuItems.firstIndex(where: {$0.courseType == id}) {
        
        if let menusForCourse = menuItemsArray.filter({"\($0.courseType)" == id}).first {
          
          selectedMenuItems[index].item = ["\(menusForCourse.id)"]
          print(selectedMenuItems)
          
          savaSelectedMenuItems[selectedIndex].item = ["\(menusForCourse.id)"]
          print(savaSelectedMenuItems)
        }
        else {
          selectedMenuItems[index].item = [""]
          savaSelectedMenuItems[selectedIndex].item = [""]
          
          print(selectedMenuItems)
          print(savaSelectedMenuItems)
        }
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
        print(self.selectedMenuItems)
        
        var getDateArray = self.savaSelectedMenuItems.filter({$0.date == self.currentDate})
        getDateArray[indexPath.section].courseType = "\(courseTypeArray[index].id)"
        
        print(getDateArray)
        print(self.savaSelectedMenuItems)
        
        self.savaSelectedMenuItems.removeLast()
        print(self.savaSelectedMenuItems)
        
        self.savaSelectedMenuItems.append(getDateArray.last!)
        print(self.savaSelectedMenuItems)
        
        self.dispatchGroup.enter()
        guard let schoolId = UserManager.shared.currentUser?.school_id else { return }
        
        self.viewModel.getMenuItems(forCourse: "\(courseTypeArray[index].id)", forSchool: "\(schoolId)")
        
        
      }else if let cell = sender.superview?.superview?.superview as? AddMealActivityCell, sender == cell.txtMeal {
        
        guard let indexPath = self.addMealTableView.indexPath(for: cell) else { return }
        
        self.selectedMenuItems[indexPath.section].item[indexPath.row-1] = "\(self.menuItemsArray.filter({"\($0.courseType)" == self.selectedMenuItems[indexPath.section].courseType})[index].id)"
        
        
        var getMenuIemArray = self.savaSelectedMenuItems.filter({$0.date == self.currentDate})
        getMenuIemArray[indexPath.section].item[indexPath.row-1] = "\(self.menuItemsArray.filter({"\($0.courseType)" == getMenuIemArray[indexPath.section].courseType})[index].id)"
        
        print(getMenuIemArray)
        self.savaSelectedMenuItems.removeLast()
        
        self.savaSelectedMenuItems.append(getMenuIemArray.last!)
        print(self.savaSelectedMenuItems)
        
//        self.savaSelectedMenuItems[indexPath.section].item[indexPath.row-1] = "\(self.menuItemsArray.filter({"\($0.courseType)" == self.savaSelectedMenuItems[indexPath.section].courseType})[index].id)"
        
        print(self.savaSelectedMenuItems)
        
      }
    }
    
    dropDown.width = sender.frame.width
    dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
    dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
    
    
    if let visibleDropdown = DropDown.VisibleDropDown {
      
      visibleDropdown.dataSource = content
      
    }else {
      
      dropDown.show()
    }
  }
  
  //MARK:- Button Action
  @IBAction func calendarViewValueChangedAction(_ sender: Any) {
    
    
  //  currentDate = self.calendarView.date.getasString(inFormat: "yyyy-MM-dd")
    
    let getCurrentCourseDetails = savaSelectedMenuItems.filter({$0.date == currentDate})
    print(getCurrentCourseDetails)
    
    if getCurrentCourseDetails.count > 0{
      
      selectedMenuItems = getCurrentCourseDetails
      addMealTableView.reloadData()
      
    }else{
      
      selectedMenuItems.removeAll()
      
      if selectedMenuItems.isEmpty {
        addNewCourseType()
      }
    }
    
 //   ""
    
  }
    
    @IBAction func DateSelection(ender: UIButton){
        let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
        picker.dismissBlock = { date in
            DispatchQueue.main.async {
                self.selectedDate = date
                self.calendarView.date = date
                self.txtDateofBirth.text = date.asString(withFormat: "dd MMMM yyyy")
                self.currentDate = date.getasString(inFormat: "yyyy-MM-dd")
                self.calendarViewValueChangedAction("")
            }
        }
    }
  
  @objc func addMoreAction(gesture : UITapGestureRecognizer) {
    
    let courseTypeArray = self.courseTypeArray.filter({!selectedMenuItems.map({$0.courseType}).contains("\($0.id)")})
    
    guard let courseTypeId = courseTypeArray.first?.id else {
      displayError(withMessage: .coursesAdded)
      return
    }
    
    if let selectedIndex = self.savaSelectedMenuItems.firstIndex(where: {$0.date == self.currentDate}) {
      
      if let itemId = menuItemsArray.filter({"\($0.courseType)" == "\(courseTypeId)"}).first?.id {
        
        selectedMenuItems.append(Menu(date: currentDate, courseType: "\(courseTypeId)", item: ["\(itemId)"], items: [""]))
        
        savaSelectedMenuItems.append(Menu(date: currentDate, courseType: "\(courseTypeId)", item: ["\(itemId)"], items: [""]))
        print(self.selectedMenuItems)
        
      }else{
        
        selectedMenuItems.append(Menu(date: currentDate, courseType: "\(courseTypeId)", item: [""], items: [""]))
        print(self.selectedMenuItems)
        
        savaSelectedMenuItems.append(Menu(date: currentDate, courseType: "\(courseTypeId)", item: [""], items: [""]))
        print(self.savaSelectedMenuItems)
        
      }
    }
    
    dispatchGroup.enter()
    guard let schoolId = UserManager.shared.currentUser?.school_id else { return }
    self.viewModel.getMenuItems(forCourse: "\(courseTypeId)", forSchool: "\(schoolId)")
    
    addMealTableView.reloadData()
  }
  
  @IBAction func saveBtnAction(_ sender: Any) {
    
    //    let courseMenuItems = selectedMenuItems
    //    let _selectedMenuItems = courseMenuItems
    //    let selectData = SelectedMenu(date: currentDate, courseDetail: _selectedMenuItems)
    //    savaSelectedMenuItems.append(selectData)
    // print(savaSelectedMenuItems)
  }
  
  @IBAction func nextBtnAction(_ sender: Any) {
    
    guard let _date = selectedDate else {
      return displayError(withMessage: .selectDate)
    }
    
    guard !selectedMenuItems.isEmpty else {
      return displayError(withMessage: .selectMenu)
    }
    
    if let index = selectedMenuItems.firstIndex(where: {!($0.item.filter({$0.isEmpty}).isEmpty)}), let courseIndex = courseTypeArray.firstIndex(where: {"\($0.id)" == selectedMenuItems[index].courseType}) {
      return displayServerError(withMessage: "Please select a meal for \(courseTypeArray[courseIndex].name)")
    }
    
    let storyBoard = UIStoryboard.AddWeeklyMenuStoryboard()
    let vc = storyBoard.instantiateViewController(withIdentifier: "AddWeeklySelectStudentsVC") as! AddWeeklySelectStudentsVC
    vc.selectedMenuItems = selectedMenuItems
    vc.selectedDate = _date
    vc.courseTypeArray = courseTypeArray
    vc.menuItemsArray = menuItemsArray
    vc.selectedUsers = selectedUsers
    vc.classId = classId
    vc.delegate = self
    vc.weeklyMenuID = "\(editWeeklyMenuData.first?.id ?? 0 )"
    if editWeeklyMenuData.count > 0 {
      vc.isEdit = true
    }else{
      vc.isEdit = false
    }
    vc.savaSelectedMenuItems = savaSelectedMenuItems
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func backBtnAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func dismissKeyboard() {
    self.view.endEditing(true)
  }
}

extension AddWeeklyMealVC : UITableViewDelegate, UITableViewDataSource {
  
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
        courseCell.txtMeal.text = courseTypeArray[index].name
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
      print(selectedMenuItems)
      
      savaSelectedMenuItems[indexpath.section].item.append("")
      print(savaSelectedMenuItems)
      
      addMealTableView.reloadData()
    }
  }
  
  @objc func removeField(sender: UIButton){
    
    if let cell = sender.superview?.superview?.superview?.superview?.superview as? AddMealActivityCell, let indexpath = addMealTableView.indexPath(for: cell) {
      
      selectedMenuItems[indexpath.section].item.remove(at: indexpath.row - 1)
      print(selectedMenuItems)
      
      savaSelectedMenuItems[indexpath.section].item.remove(at: indexpath.row - 1)
      print(savaSelectedMenuItems)
      
      if selectedMenuItems[indexpath.section].item.isEmpty {
        selectedMenuItems.remove(at: indexpath.section)
        print(selectedMenuItems)
        
        savaSelectedMenuItems.remove(at: indexpath.section)
        print(savaSelectedMenuItems)
        
      }
      
      addMealTableView.reloadData()
    }
  }
}

extension AddWeeklyMealVC :UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    if let cell = textField.superview?.superview as? AddMealHeaderCell {
      showDropDown(sender: cell.txtMeal, content: courseTypeArray.filter({!selectedMenuItems.map({$0.courseType}).contains("\($0.id)")}).map({$0.name}))
      return false
    }
    else if let cell = textField.superview?.superview?.superview as? AddMealActivityCell, let indexPath = addMealTableView.indexPath(for: cell) {
      showDropDown(sender: cell.txtMeal, content: menuItemsArray.filter({"\($0.courseType)" == selectedMenuItems[indexPath.section].courseType}).map({$0.foodDetails}))
      return false
    }
    else if textField == txtDateofBirth {
      let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
      picker.dismissBlock = { date in
        self.selectedDate = date
        self.txtDateofBirth.text = date.asString(withFormat: "dd MMMM yyyy")
      }
      return false
    }
    
    return true
  }
}

extension AddWeeklyMealVC:WeeklyMenuDelegate{
  
  func menuItemsListSuccess(items: [MenuItem], forCourse id: String) {
    
    for item in items {
      if !self.menuItemsArray.map({$0.id}).contains(item.id) {
        self.menuItemsArray.append(item)
        print("menuItemsArray\(self.menuItemsArray)")
      }
    }
    
    if selectedMenuItems.isEmpty {
      addNewCourseType()
    }
    else {
      modifyCourseType(forCourse: id)
    }
    addMealTableView.reloadData()
    
    MBProgressHUD.hide(for: self.window!, animated: true)
    dispatchGroup.leave()
  }
  
  func courseTypeListSuccess(courseType: [CourseType]) {
    courseTypeArray = courseType
    
    dispatchGroup.enter()
    guard let courseId = courseTypeArray.first?.id, let schoolId = UserManager.shared.currentUser?.school_id else { return }
    viewModel.getMenuItems(forCourse: "\(courseId)", forSchool: "\(schoolId)")
  }
  
  func failure(message: String) {
    displayServerError(withMessage: message)
  }
  
}

extension AddWeeklyMealVC : EditSelectedMenuDelegate {
  
  func selectedUsers(forClass classId: Int, users: [MessageUserData]) {
    self.classId = classId
    self.selectedUsers = users
  }
}
