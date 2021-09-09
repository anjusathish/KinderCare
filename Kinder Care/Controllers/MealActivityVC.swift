//
//  ActivityVC.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 26/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class MealActivityVC: BaseViewController {
    
    @IBOutlet var activityTableView: UITableView!
    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    
    @IBOutlet weak var sendCancelView: CTView!
    var activityId:Int?
    var state:Int?
    var activityType: ActivityType?
    var activityDetail:DailyActivityDetail?
    var delegate:refreshDailyActivityDelegate?
    var fromDate:String?
    lazy var viewModel : DailyActivityViewModel   =  {
        return DailyActivityViewModel()
    }()
    
    
    var selectedMenuItems : [Menu] = []
    var selectedDate : Date!
    var classId : [Int]!
    var selectedUsers : [MessageUserData] = []
    var courseTypeArray = [CourseType]()
    var menuItemsArray = [MenuItem]()
    
    public var selectedStudentsArray : [Student] = []
    public var startDate: String = ""
    public var endDate: String = ""
    public var txtviewDescription: String = ""
    public var classID : Int?
    public var sectionID : Int?
    public var selectedMenuItemsID: String?
    
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        if let _activityId = activityId {
            titleString = (activityType?.rawValue)?.uppercased() ?? ""
            viewModel.viewDailyActivity(activity_id: _activityId)
        }
        else {
            titleString = "PREVIEW"
        }
        
        configureUI()
        
        self.activityTableView.register(UINib(nibName: "ActivityPreviewHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ActivityPreviewHeaderView")
        self.activityTableView.register(UINib(nibName: "ActivitySelectedStudentTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivitySelectedStudentTableViewCell")
        self.activityTableView.register(UINib(nibName: "SelectedStudentsTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectedStudentsTableViewCell")
        self.activityTableView.register(UINib(nibName: "MealTableViewCell", bundle: nil), forCellReuseIdentifier: "MealTableViewCell")
        self.activityTableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
        
    }
    //MARK:- Button Action
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        if let activityID = activityDetail?.id{
            
            viewModel.activityUpdate(id: "\(activityID)", state: "0")
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }  }
    @IBAction func sendBtnAction(_ sender: Any) {
        
        if let activityID = activityDetail?.id {
            
            viewModel.activityUpdate(id: "\(activityID)", state: "1")
            
        }
        else{
            
            let selectedID = selectedMenuItems.map({$0.item})
            print(selectedID)
            
            let request = AddMealActivityRequest(type: "meal", class_id: classID ?? 0, section_id: sectionID ?? 0, start_time: startDate, end_time: endDate, description: txtviewDescription, students: selectedStudentsArray.map({$0.id}), studentName: selectedStudentsArray.map({$0.studentName}), meals: (selectedID.first ?? ["0"]),date: fromDate ?? "" )
            
            viewModel.addMealActivity(at: request)
        }
    }
    
    func configureUI() {
        if  let userType = UserManager.shared.currentUser?.userType {
            if let _type = UserType(rawValue:userType ) {
                switch  _type  {
                case .admin :
                    
                    /*    let editTopBtn = UIButton(frame: CGRect(x: self.view.frame.width - (16 + 65), y: 15 + safeAreaHeight, width: 70, height: 30))
                     editTopBtn.setTitle("Edit", for: .normal)
                     editTopBtn.setImage(UIImage(named: "EditWhite"), for: .normal)
                     editTopBtn.backgroundColor = UIColor.clear
                     editTopBtn.tag = 3
                     editTopBtn.addTarget(self, action: #selector(editBtnAction(button:)), for: .touchUpInside)*/
                    
                    if  activityId != nil {
                        sendBtn.setTitle("Send", for: .normal)
                        cancelBtn.backgroundColor = UIColor(hex: 0xF5563E, alpha: 1.0)
                    }
                    else
                    {
                        sendBtn.setTitle("Reject", for: .normal)
                    }
                    
                    if state == 1 {
                       sendCancelView.isHidden = true
                    }
                    else if state == 0 {
                       sendCancelView.isHidden = true
                    }else{
                       sendCancelView.isHidden = false
                       }
                    
                case .teacher:
                    if let _activityId = activityId {
                        
                        sendBtn.isHidden = true
                        cancelBtn.isHidden = true
                    }
                    else {
                        sendBtn.isHidden = false
                        cancelBtn.isHidden = false
                    }
                    if state == 1 {
                       sendCancelView.isHidden = true
                    }
                    else if state == 0 {
                       sendCancelView.isHidden = true
                    }else{
                       sendCancelView.isHidden = false
                       }
                    
                default :
                    cancelBtn.setTitle("Cancel", for: .normal)
                    break
                }
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @objc   func editBtnAction(button : UIButton) {
        
        if button.tag == 1 {
            //      let vc = UIStoryboard.AddActivityStoryboard().instantiateViewController(withIdentifier:"StudentListVC") as! StudentListVC
            //      vc.modalPresentationStyle = .overCurrentContext
            //      self.navigationController?.present(vc, animated: true, completion: nil)
            
            
            let story = UIStoryboard(name: "AddActivity", bundle: nil)
            let studentListVC = story.instantiateViewController(withIdentifier: "StudentListVC") as! StudentListVC // abdul
            studentListVC.delegate = self
            studentListVC.userTypeArray = [.student]
            studentListVC.classID = classID
            studentListVC.sectionID = sectionID
            
            
            
            studentListVC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(studentListVC, animated: true, completion: nil)
            
            //      let story = UIStoryboard(name: "AddActivity", bundle: nil)
            //           let nextVC = story.instantiateViewController(withIdentifier: "SelectStudentVC") as! SelectStudentVC
            //      nextVC.activityType = ActivityType(rawValue: "Meal")
            //           self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else if button.tag == 3 {
            let story = UIStoryboard(name: "AddActivity", bundle: nil)
            let nextVC = story.instantiateViewController(withIdentifier: "SelectStudentVC") as! SelectStudentVC
            nextVC.activityType = activityType
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else
        {
//            let vc = UIStoryboard.AddActivityStoryboard().instantiateViewController(withIdentifier:"AddMealVC") as! AddMealVC
//            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

//MARK:- TableView

extension MealActivityVC :UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            if let studentsCount = activityDetail?.students?.count{
                
                return 1
                
            }else{
                return 1
            }
            
        }else if section == 1{
            
            if let mealsCount = activityDetail?.meals?.count{
                
                return mealsCount
                
            }else{
                return selectedMenuItems.count
            }
            
            // return selectedMenuItems.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0 :
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedStudentsTableViewCell", for: indexPath) as! SelectedStudentsTableViewCell
            cell.selectionStyle = .none
            
            
            if activityId != nil {
                cell.activityTypeView.isHidden = true
            }
            else
            {
                cell.activityTypeView.isHidden = false
                if let activityData = activityType?.rawValue {
                    cell.activityTypeLabel.text = activityData + "Activity"
                }
                else {
                    cell.activityTypeLabel.text = ""
                }
                
            }
            
            if  let userType = UserManager.shared.currentUser?.userType {
                if let _type = UserType(rawValue:userType ) {
                    switch  _type  {
                    case .admin :
                        cell.editBtn.isHidden = true
                    default :
                        cell.editBtn.isHidden = false
                        cell.editBtn.tag = 1
                        cell.editBtn.addTarget(self, action: #selector(editBtnAction(button:)), for: .touchUpInside)
                    }
                }
            }
            if let studentsName = activityDetail?.students{
                
                cell.selectedUsers = studentsName.map({$0.studentName})
                
            }else{
                
                cell.selectedUsers = selectedStudentsArray.map({$0.studentName})
            }
            
            cell.collectionViewHeight.constant = cell.selectedStuCollectionView.collectionViewLayout.collectionViewContentSize.height
            cell.selectedStuCollectionView.reloadData()
            
            return cell
            
        case 1 :
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as! MealTableViewCell
            
            if let mealsData = activityDetail?.meals {
                cell.foodTypeLbl.text = mealsData[indexPath.row].courseTypeName
                let itemLabel = UILabel()
                itemLabel.font = UIFont.systemFont(ofSize: 15)
                itemLabel.text = mealsData[indexPath.row].foodName
                cell.foodItemStackView.addArrangedSubview(itemLabel)
                
            }else{
                
                let menu = selectedMenuItems[indexPath.row]
                
                if let index = courseTypeArray.firstIndex(where: {"\($0.id)" == menu.courseType}) {
                    cell.foodTypeLbl.text = courseTypeArray[index].name
                }
                
                for item in cell.foodItemStackView.subviews {
                    item.removeFromSuperview()
                }
             // if let menuItem = menu.item {
                
                for item in menu.item {
                  let itemLabel = UILabel()
                  itemLabel.font = UIFont.systemFont(ofSize: 15)
                  
                  if let index = menuItemsArray.filter({"\($0.courseType)" == menu.courseType}).firstIndex(where: {"\($0.id)" == item}) {
                    itemLabel.text = menuItemsArray[index].foodDetails
                  }
                  
                  cell.foodItemStackView.addArrangedSubview(itemLabel)
                }
            //  }
            }
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
            
            if let _viewDailyActivity = activityDetail {
                cell.descriptionLabel.text = _viewDailyActivity.dataDescription
            }else{
                cell.descriptionLabel.text = txtviewDescription
            }
            
            cell.selectionStyle = .none
            
            return cell
            
        default:return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && activityId == nil {
            
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ActivityPreviewHeaderView") as! ActivityPreviewHeaderView
            headerView.statusView.isHidden = true
            return headerView
        }
        else
        {
            return nil
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && activityId == nil {
            return 62
        }
        else {
            return 0
        }
    }
    
}
extension MealActivityVC : DailyActivityDelegate {
    func activityUpdateSuccess(activity: EditPhotoActivityEmptyResponse) {
        self.displayServerSuccess(withMessage: "Updated Successfully")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DailyActivityVC") as! DailyActivityVC
        self.delegate?.refreshDailyActivity()
        self.navigationController?.popViewController(animated: true)
        
    }
    func bathRoomList(at bathRoomList: [CategoryListDatum]) {
        
    }
    
    func classRoomMilestoneList(at CategoryList: [CategoryListDatum]) {
        
    }
    func classRoomCategoryList(at CategoryList: [CategoryListDatum]) {
        
    }
    
    func addDailyActivityPhotoResponse(at editActivityResponse: AddDailyAtivityPhotoResponse) {
        
        self.displayServerSuccess(withMessage: "Add Meal Activity Successfully")
        if let viewController = navigationController?.viewControllers.first(where: {$0 is ActivityListVC}) {
            navigationController?.popToViewController(viewController, animated: true)
        }
    }
    
    func editPhotEditActivityResponse(at editActivityResponse: EditPhotoActivityEmptyResponse) {
        
    }
    
    func getListDailyActivity(at dailyActivityList: [DailyActivity]) {
        
    }
    
    func viewDailyActivitySuccessfull(dailyActivityDetails: DailyActivityDetail) {
        activityDetail = dailyActivityDetails
        activityTableView.reloadData()
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
    }
    
    
}

extension MealActivityVC:sendSelectedEmailDelegate{
  
  func selectedTeachers(students: [TeacherListData], users: [MessageUserData]) {
    
  }
    
    func selectedStudents(students: [Student], users: [MessageUserData]) {
        selectedStudentsArray.append(contentsOf: students)
        activityTableView.reloadData()
    }
    
    func classNameList(classData: [ClassModel], classId: Int) {
        
    }

    func selectedUsers(users: [MessageUserData]) {
        
    }
}
