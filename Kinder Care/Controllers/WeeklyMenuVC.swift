//
//  WeeklyMenuVC.swift
//  Kinder Care
//
//  Created by CIPL0681 on 12/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import DropDown
import DZNEmptyDataSet

class WeeklyMenuVC: BaseViewController {
  
  @IBOutlet weak var childDropDown: ChildDropDown!
  @IBOutlet weak var menuTableView: UITableView!
  @IBOutlet weak var calendarView: CTDayWeekCalender!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var editBtn: UIButton!
  @IBOutlet weak var topStackView: UIStackView!
  @IBOutlet weak var classTF: CTTextField!
  @IBOutlet weak var dateLabel: UILabel!
  var childNameArray = [ChildName]()
  var childNameID:Int?
  
  lazy var viewModel : ListWeeklyMenuViewModel = {
    return ListWeeklyMenuViewModel()
  }()
  
  var dishes : [Dish] = []
  var weeklyMenuDetails: [WeeklyMenuItem] = []
  var editWeeklyMenuData: [DatumDish] = []
  var classId : Int?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    topBarHeight = 100
    self.titleString = "WEEKLY MENU"
    
    if let childName = UserManager.shared.childNameList {
      childNameArray = childName
      self.childNameID = childNameArray.map({$0.id}).first
    }
    
    configureUI()
    
    classTF.text = SharedPreferenceManager.shared.classNameListArray.first?.className
    dateLabel.text = calendarView.date.asString(withFormat: "MMM dd, EEE") + " Menu"
    print(calendarView.dateString)
    viewModel.delegate = self
    
    classId = SharedPreferenceManager.shared.classNameListArray.first?.id
    
    menuTableView.emptyDataSetSource = self
    menuTableView.emptyDataSetDelegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getWeeklyMenu(forDate: calendarView.date)
  }
  
  func configureUI(){
    
    let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 70))
    let todayBtn = UIButton.init(frame: CGRect.init(x: UIScreen.main.bounds.size.width/2-120, y: 20, width: 220, height: 50))
    todayBtn.setTitle("Go to Today's Menu", for: .normal)
    todayBtn.backgroundColor = UIColor.init(red: 242/255.0, green: 156/255.0, blue: 18/255.0, alpha: 1.0)
    todayBtn.addTarget(self, action: #selector(todayMenuButtonHandler(_:)), for: .touchUpInside)
    todayBtn.layer.cornerRadius = 25.0
    todayBtn.layer.masksToBounds = true
    todayBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    footerView.addSubview(todayBtn)
    
    menuTableView.separatorColor = UIColor.clear
    menuTableView.backgroundColor = UIColor.clear
    menuTableView.register(UINib(nibName: "MealTableViewCell", bundle: nil), forCellReuseIdentifier: "MealTableViewCell")
    
    if  let userType = UserManager.shared.currentUser?.userType {
      if let _type = UserType(rawValue:userType ) {
        
        switch  _type {
        case .parent:
          
          childDropDown.isHidden  = false
          self.childDropdownAction()
          menuTableView.tableFooterView = footerView
          addButton.isHidden = true
          editBtn.isHidden = true
          classTF.isHidden = true
          break
          
        case .teacher:
          
          childDropDown.isHidden  = true
          menuTableView.tableFooterView = footerView
          addButton.isHidden = true
          editBtn.isHidden = true
          classTF.isHidden = false
          break
          
        case .admin:
          childDropDown.isHidden  = true
          addButton.isHidden = false
          editBtn.isHidden = false
          classTF.isHidden = false
          
        default:
          break
        }
      }
    }
    
    self.view.bringSubviewToFront(topStackView)
    
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
      self.getWeeklyMenu(forDate: self.calendarView.date)
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
  
  func getWeeklyMenu(forDate date : Date) {
    
    guard let _classId = classId, let schoolId = UserManager.shared.currentUser?.school_id else {return}
    viewModel.getWeeklyMenu(date: date.asString(withFormat: "yyyy-MM-dd"), classId: "\(_classId)", schoolId: "\(schoolId)", user_id: childNameID ?? 0)
  }
  
  @IBAction func addWeeklyMenu(_ sender: Any) {
    
    let storyBoard = UIStoryboard.AddWeeklyMenuStoryboard()
    let composeVC = storyBoard.instantiateViewController(withIdentifier: "AddWeeklyMealVC") as! AddWeeklyMealVC
    self.navigationController?.pushViewController(composeVC, animated: true)
  }
  @IBAction func editWeeklyMenu(_ sender: Any) {
    
    let storyBoard = UIStoryboard.AddWeeklyMenuStoryboard()
    let vc = storyBoard.instantiateViewController(withIdentifier: "AddWeeklyMealVC") as! AddWeeklyMealVC
    vc.weeklyMenuItems = weeklyMenuDetails
    vc.editWeeklyMenuData = self.editWeeklyMenuData 
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func childDropdownAction(){
    self.view.bringSubviewToFront(childDropDown)
    
    childDropDown.titleArray = childNameArray.map({$0.name})
    childDropDown.subtitleArray = childNameArray.map({$0.className + " , " + $0.section + " Section"})
    if childNameArray.count > 1{
    childDropDown.selectionAction = { (index : Int) in
      print(index)
      
      // guard let _classId = self.classId, let schoolId = UserManager.shared.currentUser?.school_id else {return}
      // viewModel.getWeeklyMenu(date: date.asString(withFormat: "yyyy-MM-dd"), classId: "\(_classId)", schoolId: "\(schoolId)", user_id: childNameID ?? 0)
      
        }}
    else{
        childDropDown.isUserInteractionEnabled = false
    }
    
    
    childDropDown.addChildAction = { (sender : UIButton) in
      let vc = UIStoryboard.FamilyInformationStoryboard().instantiateViewController(withIdentifier:"AddChildVC") as! AddChildVC
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  @objc func todayMenuButtonHandler(_ sender: CTDayWeekCalender){ //paru da
    
    //calendsetDisplayDate
    getWeeklyMenu(forDate: Date())
    dateLabel.text = Date().asString(withFormat: "MMM dd, EEE") + " Menu"
    
    
  }
  
  @IBAction func gotomenuAction(_ sender: UIButton) {
  }
  
  @IBAction func calenderAction(_ sender: CTDayWeekCalender) {
    dateLabel.text = calendarView.date.asString(withFormat: "MMM dd, EEE") + " Menu"
    getWeeklyMenu(forDate: sender.date)
  }
}

extension WeeklyMenuVC: UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    if textField == classTF {
      showDropDown(sender: textField, content: SharedPreferenceManager.shared.classNameListArray.map({$0.className}))
      return false
    }
    
    return true
  }
}

extension WeeklyMenuVC: UITableViewDelegate, UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dishes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as! MealTableViewCell
    
    let dish = dishes[indexPath.row]
    
    cell.foodTypeLbl.text = dish.courseType
    
    for item in cell.foodItemStackView.subviews {
      item.removeFromSuperview()
    }
    
    for item in dish.items {
      let itemLabel = UILabel()
      itemLabel.font = UIFont.systemFont(ofSize: 15)
      itemLabel.text = item
      cell.foodItemStackView.addArrangedSubview(itemLabel)
    }
    
    return cell
  }
}

extension WeeklyMenuVC : ListWeeklyMenuDelegate {
  func listWeeklyMenu(items: [Dish], _ weeklyItem: [WeeklyMenuItem], _ editWeeklyMenuData: [DatumDish]) {
    dishes = items
    weeklyMenuDetails = weeklyItem
    self.editWeeklyMenuData = editWeeklyMenuData
    menuTableView.reloadData()
  }
  
  //  func listWeeklyMenu(items: [Dish], _ weeklyItem: [WeeklyMenuItem]) {
  //    dishes = items
  //    weeklyMenuDetails = weeklyItem
  //    menuTableView.reloadData()
  //  }
  
  
  //  func listWeeklyMenu(items: [Dish]) {
  //     dishes = items
  //       menuTableView.reloadData()
  //  }
  
  //  func listWeeklyMenu(items: [Menu]) {
  //    dishes = items
  //    menuTableView.reloadData()
  //  }
  
  
  //    func listWeeklyMenu(items: [Dish]) {
  //        dishes = items
  //        menuTableView.reloadData()
  //    }
  
  func failure(message: String) {
    dishes.removeAll()
    menuTableView.reloadData()
    displayServerError(withMessage: message)
  }
}

extension WeeklyMenuVC : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
  
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
    return NSAttributedString(string: "No Menu added.")
  }
}
