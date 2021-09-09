//
//  DailyActivityVC.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 25/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import DropDown
enum ApprovalStatusForActivity : Int{
    case pending = 2
    case approved = 1
    case rejected = 0
    
    
    var statusString : String {
        switch self {
        case .pending: return "Pending"
        case .approved: return "Approved"
        case .rejected: return "Rejected"
        }
    }
    
    var statusColor : UIColor {
        switch self {
        case .pending: return .pendingColor
        case .approved: return .approvedColor
        case .rejected: return .rejectColor
        }
    }
}


enum ActivityType : String {
  
  case meal = "Meal"
  case nap = "Nap"
  case classroom = "Classroom"
  case incident = "Incident"
  case medicine = "Medicine"
  case photo = "Photo"
  case video = "Video"
  case bathRoom = "Bathroom"
}

enum DailyActivityType : String {
  
  case meal = "meal"
  case nap = "nap"
  case classroom = "Classroom"
  case incident = "Incident"
  case medicine = "Medicine"
  case photo = "photo"
  case video = "video"
  case bathRoom = "Bathroom"
}

class DailyActivityVC: BaseViewController {
  
  @IBOutlet weak var calendarView: CTDayCalender!
  @IBOutlet var dailyActivityTableView: UITableView!
  @IBOutlet var sectionTxt: CTTextField!
  @IBOutlet var classTxt: CTTextField!
  @IBOutlet var buttonAddActivity: UIButton!
  
  var classArray = [ClassModel]()
  var sectionArray = [Section]()
  var classID :Int?
  var sectionID:Int?
  var currentPageNo = 1
  
  var dailyActivityArray:[DailyActivity] = []
  
  lazy var viewModel : DailyActivityViewModel   =  {
    return DailyActivityViewModel()
  }()
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleString = "DAILY ACTIVITY"
    
    dailyActivityTableView.backgroundColor = UIColor.clear
    
    self.dailyActivityTableView.register(UINib(nibName: "DailyActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyActivityTableViewCell")
    
    viewModel.delegate = self
    
    if  let userType = UserManager.shared.currentUser?.userType {
    
      if let _type = UserType(rawValue:userType ) {
        
        switch _type {
          
        case .teacher: buttonAddActivity.isHidden = false
        
        case .parent: buttonAddActivity.isHidden = true
          
        case .admin: buttonAddActivity.isHidden = true
          
        case .superadmin: buttonAddActivity.isHidden = true
          
        case .all: buttonAddActivity.isHidden = true
          
        case .student: buttonAddActivity.isHidden = true
          
        }
        
      }
    }
    
  //  getDailyActivityList()
    
    getClassAndSectionValues()
  }
    
    override func viewWillAppear(_ animated: Bool) {
        getDailyActivityList()
    }
    
  
  func getClassAndSectionValues()
  {
    self.classArray = SharedPreferenceManager.shared.classNameListArray
    self.sectionArray = SharedPreferenceManager.shared.sectionArray
  }
  
  func getDailyActivityList(){
    
    if let _classId = self.classID, let sectionId = self.sectionID {
      viewModel.getDailyActivityList(class_id:"\(_classId)" , section_id: "\(sectionId)" , pages: "1", fromDate:self.calendarView.date.getasString(inFormat: "yyyy-MM-dd") , toDate: self.calendarView.date.getasString(inFormat: "yyyy-MM-dd"))
    }
    else
    {
      viewModel.getDailyActivityList(class_id:"" , section_id: "" , pages: "1", fromDate:self.calendarView.date.getasString(inFormat: "yyyy-MM-dd") , toDate: self.calendarView.date.getasString(inFormat: "yyyy-MM-dd"))
    }
  }
  
  //MARK:- Button Action
  @IBAction func addActivityBtnAction(_ sender: Any) {
    let vc = UIStoryboard.AddActivityStoryboard().instantiateViewController(withIdentifier:"ActivityListVC") as! ActivityListVC
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func calendarViewValueChangedAction(_ sender: Any) {
    getDailyActivityList()
  }
  
  // MARK: - Show DropDown
  
  func showDropDown(sender : UITextField, content : [String]) {
    
    let dropDown = DropDown()
    dropDown.direction = .any
    dropDown.anchorView = sender
    dropDown.dismissMode = .automatic
    dropDown.dataSource = content
    
    dropDown.selectionAction = { (index: Int, item: String) in
      sender.text = item
      
      if sender == self.sectionTxt {
        
        self.sectionID = self.sectionArray[index].id
        self.getDailyActivityList()
      }
      else {
        self.classID = self.classArray[index].id
        if let schoolId = UserManager.shared.currentUser?.school_id, let _classID =  self.classID {
          SharedPreferenceManager.shared.getSectionNameList(class_id: _classID, schoolId: "\(schoolId)")
        }
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
  
  
}
// MARK: - TextField
extension DailyActivityVC :UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    if textField == classTxt {
      
      showDropDown(sender: textField, content:classArray.map({$0.className}))
      
      return false
    }
    else{
      sectionArray = SharedPreferenceManager.shared.sectionArray
      showDropDown(sender: textField, content: sectionArray.map({$0.section}).compactMap({$0}))
      
      return false
    }
  }
}

// MARK: - TableView
extension DailyActivityVC : UITableViewDelegate,UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "DailyActivityTableViewCell", for: indexPath) as! DailyActivityTableViewCell
    cell.backgroundColor = UIColor.clear
    cell.selectionStyle = .none
    
    let activity = dailyActivityArray[indexPath.row]
    
    cell.dateLbl.text = activity.createdAt.getDateAsStringWith(inFormat: "yyyy-MM-dd HH:mm:ss", outFormat: "MM/dd/yyyy")
    cell.classSectionLbl.text = activity.className + " " + activity.classSection + " Section"
    
    if let state = dailyActivityArray[indexPath.row].state, let status = ApprovalStatusForActivity(rawValue: state) {
      
      cell.statusBtn.setTitle(status.statusString, for: .normal)
      cell.statusBtn.backgroundColor = status.statusColor
    }
    else{
        
    }
    
    cell.activityLbl.text = activity.type
    
    if let _activityType = cell.activityLbl.text, let activityType = ActivityType(rawValue: _activityType) {
      
      cell.activityImgView.image = UIImage(named: activityType.rawValue)
      
      // Load More
      /*      if listDailyActivity[indexPath.row].id == listDailyActivity.last?.id && indexPath.row == listDailyActivity.count - 1 {
       
       self.currentPageNo += 1
       getDailyActivityList()
       
       }*/
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dailyActivityArray.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let activityType = ActivityType(rawValue: dailyActivityArray[indexPath.row].type.firstUppercased)
        
    if let type = activityType {
      
      switch type  {
        
      case .meal :
        let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"MealActivityVC") as! MealActivityVC
        vc.activityId = dailyActivityArray[indexPath.row].id
        vc.state = dailyActivityArray[indexPath.row].state
        vc.activityType = type
          vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
      case .classroom :
        let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"ClassRoomDailyActivityVC") as! ClassRoomDailyActivityVC
        vc.activityId = dailyActivityArray[indexPath.row].id
         vc.state = dailyActivityArray[indexPath.row].state
        vc.activityType = type
         vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
      case .nap :
        let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"NapActivityVC") as! NapActivityVC
        vc.activityId = dailyActivityArray[indexPath.row].id
        vc.activityType = type
        vc.state = dailyActivityArray[indexPath.row].state
         vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
      case .incident :
        let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"IncidentDailyActivityVC") as! IncidentDailyActivityVC
        vc.activityId = dailyActivityArray[indexPath.row].id
        vc.state = dailyActivityArray[indexPath.row].state
         vc.activityType = type
         vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
      case .medicine :
        let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"MedicineDailyActivityVC") as! MedicineDailyActivityVC
        vc.activityId = dailyActivityArray[indexPath.row].id
       vc.state = dailyActivityArray[indexPath.row].state
        vc.activityType = type
         vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
        
      case .photo:
        let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"PhotoDailyActivityVC") as! PhotoDailyActivityVC
        vc.activityId = dailyActivityArray[indexPath.row].id
        vc.state = dailyActivityArray[indexPath.row].state
          vc.activityType = type
         vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
        
      case .video:
        let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"PhotoDailyActivityVC") as! PhotoDailyActivityVC
        vc.activityId = dailyActivityArray[indexPath.row].id
        vc.state = dailyActivityArray[indexPath.row].state
        vc.activityType = type
         vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
      case .bathRoom:
        let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"BathroomDailyActivityVC") as! BathroomDailyActivityVC
        vc.activityId = dailyActivityArray[indexPath.row].id
        vc.state = dailyActivityArray[indexPath.row].state
          vc.activityType = type
        vc.delegate = self
       
        
        self.navigationController?.pushViewController(vc, animated: true)
      }
    }
  }
}

//MARK:- DailyActivityDelegate Methodes

extension DailyActivityVC: DailyActivityDelegate{
    func activityUpdateSuccess(activity: EditPhotoActivityEmptyResponse) {
        
    }
  func bathRoomList(at bathRoomList: [CategoryListDatum]) {
    
  }
  
  func classRoomMilestoneList(at CategoryList: [CategoryListDatum]) {
    
  }
  func classRoomCategoryList(at CategoryList: [CategoryListDatum]) {
    
  }
  
  func addDailyActivityPhotoResponse(at editActivityResponse: AddDailyAtivityPhotoResponse) {
    
  }
  
  func editPhotEditActivityResponse(at editActivityResponse: EditPhotoActivityEmptyResponse) {
    
  }
  
  
  func viewDailyActivitySuccessfull(dailyActivityDetails: DailyActivityDetail) {
    
  }
  
  func getListDailyActivity(at dailyActivityList: [DailyActivity]) {
    
    dailyActivityArray = dailyActivityList
    dailyActivityTableView.reloadData()
  }
  
  func failure(message: String) {
    
  }
}

extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
extension DailyActivityVC:refreshDailyActivityDelegate{
    func refreshDailyActivity() {
        self.getDailyActivityList()
    }
    
    
}
