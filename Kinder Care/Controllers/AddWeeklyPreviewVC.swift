  //
  //  AddWeeklyPreviewVC.swift
  //  Kinder Care
  //
  //  Created by Ragavi Rajendran on 14/01/20.
  //  Copyright © 2020 Athiban Ragunathan. All rights reserved.
  //
  
  import UIKit
  
  protocol EditSelectedMenuDelegate {
    func selectedUsers(forClass classId : Int, users : [MessageUserData])
  }
  
  class AddWeeklyPreviewVC: BaseViewController {
    
    @IBOutlet weak var previewTableView: UITableView!
    
    var selectedMenuItems : [Menu] = []
    var selectedDate : Date!
    var classId : Int!
    var selectedUsers : [MessageUserData] = []
    var selectedStudent : [Student] = []
    var selectedTeacher : [TeacherListData] = []
    var courseTypeArray = [CourseType]()
    var menuItemsArray = [MenuItem]()
    
    var savaSelectedMenuItems: [Menu]?
    
    var delegate : EditSelectedMenuDelegate?
    
    lazy var viewModel: AddWeeklyMenuViewModel = {
        return AddWeeklyMenuViewModel()
    }()
    var isEdit: Bool = false
    var weeklyMenuID: String = ""
    
    var strSelectedClasses = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleString = "ADD WEEKLY MENU"
        
        self.previewTableView.register(UINib(nibName: "AddWeeklyPreviewHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "AddWeeklyPreviewHeaderCell")
        self.previewTableView.register(UINib(nibName: "MealTableViewCell", bundle: nil), forCellReuseIdentifier: "MealTableViewCell")
        self.previewTableView.register(UINib(nibName: "SelectedStudentsTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectedStudentsTableViewCell")
        
        viewModel.delegate = self
        print(selectedMenuItems)
    }
    
    //MARK:- Button Action
    
    @objc func editMenuAction(sender : UIButton) {
        
        for item in self.navigationController?.viewControllers ?? [] {
            if item is AddWeeklyMealVC {
                self.navigationController?.popToViewController(item, animated: true)
                self.delegate?.selectedUsers(forClass: classId, users: selectedUsers)
                break
            }
        }
    }
    
    @objc func editUsersAction(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
        guard let _schoolId = UserManager.shared.currentUser?.school_id else {
            return
        }
        guard let mealData = savaSelectedMenuItems else{
            return
        }
        
        //viewModel.addMenu(forSchool: _schoolId, date: selectedDate.getasString(inFormat: "yyyy-MM-dd"), menu: selectedMenuItems, classId: classId, studentIds: selectedUsers.filter({$0.detail.lowercased().contains("-\(UserType.student.stringValue.lowercased())")}).map({"\($0.id)"}), teacherIds: selectedUsers.filter({$0.detail.lowercased().contains("-\(UserType.teacher.stringValue.lowercased())")}).map({"\($0.id)"}))
        
        if isEdit {
            let request = AddWeeklyMenuRequest(schoolID: "\(_schoolId)", date: mealData.first?.date ?? "", data: mealData, classID: ["\(classId ?? 0)"], studentID: selectedStudent.map({"\($0.id)"}), teacherID: selectedTeacher.map({"\($0.id)"}))
            viewModel.editWeeklyMenu(request: request, weeklyMenuID)
            
        }else{
            if let dateA = mealData.first?.date {
              
//                let request = AddWeeklyMenuRequest(schoolID: "\(_schoolId)", date: dateA, data: mealData, classID: ["\(classId ?? 0)"], studentID: selectedUsers.filter({$0.detail.lowercased().contains("-\(UserType.student.stringValue.lowercased())")}).map({"\($0.id)"}), teacherID: selectedUsers.filter({$0.detail.lowercased().contains("-\(UserType.teacher.stringValue.lowercased())")}).map({"\($0.id)"}))
//                viewModel.addMenu(request: request)
              
              let request = AddWeeklyMenuRequest(schoolID: "\(_schoolId)", date: dateA, data: mealData, classID: ["\(classId ?? 0)"], studentID: selectedStudent.map({"\($0.id)"}), teacherID: selectedTeacher.map({"\($0.id)"}))
              viewModel.addMenu(request: request)
              
              
            }
            
        }
        
        //      let request = AddWeeklyMenuRequest(schoolID: "\(_schoolId)", data: savaSelectedMenuItems, classID: "\(classId ?? 0)", studentID: selectedUsers.filter({$0.detail.lowercased().contains("-\(UserType.student.stringValue.lowercased())")}).map({"\($0.id)"}), teacherID: selectedUsers.filter({$0.detail.lowercased().contains("-\(UserType.teacher.stringValue.lowercased())")}).map({"\($0.id)"}))
        //      viewModel.addMenu(request: request)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
  }
  
  extension AddWeeklyPreviewVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return selectedMenuItems.count
        }
        else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as! MealTableViewCell
            
            let menu = selectedMenuItems[indexPath.row]
            
            if let index = courseTypeArray.firstIndex(where: {"\($0.id)" == menu.courseType}) {
                cell.foodTypeLbl.text = courseTypeArray[index].name
            }
            
            for item in cell.foodItemStackView.subviews {
                item.removeFromSuperview()
            }
            
            for item in menu.item {
                
                let itemLabel = UILabel()
                itemLabel.font = UIFont.systemFont(ofSize: 15)
                
                let filteredMenuItems = menuItemsArray.filter({"\($0.courseType)" == selectedMenuItems[indexPath.row].courseType})
                
                if let itemIndex = filteredMenuItems.firstIndex(where: {"\($0.id)" == item}) {
                    
                    itemLabel.text = filteredMenuItems[itemIndex].foodDetails
                }
                
                //                if let index = menuItemsArray.filter({"\($0.courseType)" == menu.courseType}).firstIndex(where: {"\($0.id)" == item}) {
                //                    itemLabel.text = menuItemsArray[index].foodDetails
                //                }
                
                cell.foodItemStackView.addArrangedSubview(itemLabel)
            }
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedStudentsTableViewCell", for: indexPath) as! SelectedStudentsTableViewCell
            cell.activityTypeView.isHidden = true
            
            if let attributedTitle =  cell.editBtn.attributedTitle(for: .normal) {
                let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
                mutableAttributedTitle.replaceCharacters(in: NSMakeRange(0, mutableAttributedTitle.length), with: "Edit")
                cell.editBtn.setAttributedTitle(mutableAttributedTitle, for: .normal)
            }
            
            if indexPath.row == 0 {
                cell.selectLbl.text = "Select Students"
                
//                let users = selectedUsers.filter({$0.detail.lowercased().contains("-\(UserType.student.stringValue.lowercased())")}).map({$0.detail.replacingOccurrences(of: "-\(UserType.student.stringValue.lowercased())", with: "")})
                
                if selectedStudent.count == 0{
                    cell.editBtn.isHidden = true
                    cell.selectedUsers = ["You have selected ll the students from the following classes \(self.strSelectedClasses)"]
                }else{
                   // cell.selectedUsers = selectedUsers.filter({$0.detail.lowercased().contains("-\(UserType.student.stringValue.lowercased())")}).map({$0.detail.replacingOccurrences(of: "-\(UserType.student.stringValue.lowercased())", with: "")})
                  cell.selectedUsers = selectedStudent.map({$0.studentName})
                }
                
            }
            else
            {
                cell.selectLbl.text = "Select Teachers"
             //   cell.selectedUsers = selectedUsers.filter({$0.detail.lowercased().contains("-\(UserType.teacher.stringValue.lowercased())")}).map({$0.detail.replacingOccurrences(of: "-\(UserType.teacher.stringValue.lowercased())", with: "")})
              cell.selectedUsers = selectedTeacher.map({$0.firstname})
            }
            
            cell.collectionViewHeight.constant = cell.selectedStuCollectionView.collectionViewLayout.collectionViewContentSize.height
            
            cell.editBtn.addTarget(self, action: #selector(editUsersAction(sender:)), for: .touchUpInside)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AddWeeklyPreviewHeaderCell") as! AddWeeklyPreviewHeaderCell
        headerView.editButton.addTarget(self, action: #selector(editMenuAction(sender:)), for: .touchUpInside)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 100
        }
        else
        {
            return 0
        }
    }
  }
  
  extension AddWeeklyPreviewVC : AddWeeklyMenuDelegate {
    
    func success(message: String) {
        for item in self.navigationController?.viewControllers ?? [] {
            if item is RootViewController {
                self.navigationController?.popToViewController(item, animated: true)
                break
            }
        }
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
    }
  }
