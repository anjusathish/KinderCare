//
//  CommonDashboard.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 21/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit


class CommonDashboardVC: BaseViewController {
  
  @IBOutlet weak var schoolStackView: UIStackView!
  @IBOutlet weak var schoolView: UIView!
  @IBOutlet weak var schoolDropdown: ChildDropDown!
  @IBOutlet var baseView: UIView!
  @IBOutlet var dashboardCollectionView: UICollectionView!
  @IBOutlet var viewBithday: UIView!
  
  let superadminTitlesArray = ["No. of Admin Users","No. of Teachers","No. of Support Staffs","No. of Students"]
  let superadminCellTitlesArray = ["Admins","Teachers","Staffs","Students"]
  let headingTitlesArray = ["No. of Class Rooms", "No. of Students", "No. of working days", "No. of days leave taken"]
  let cellTitlesArray = ["Class", "Students", "Days", "Leave"]
  let sectionHeader = ["Overview","Attendance Stats"]
  let arrayOverview = ["No. of Class Rooms", "No. of Students", "No. of Teachers", "No. of Support Staff"]
  let arrayAttendance = ["No. of Students Present", "No. of Students Absent", "No. of Staffs Present", "No. of Staffs Absent"]
  let arrayCellTitleOverview = ["Class Rooms", "Students", "Teachers", "Staffs"]
  let arrayCellTitleAttendance = ["Students", "Students", "Teachers", "Teachers"]
  
  var dashBoardInfo : DashboardCount?
  var adminDashBoardInfo: AdminDashboardData?
  private var teacherDashBoardInfo: TeacherDashboardData?
  var arrayAdminDashBoardData: [AdminDashboardData]?
  var arrayHeadingTitleAdmin = [[String]]()
  var arrayCellTitleAdmin = [[String]]()
  var schoolListArray  = [SchoolListData]()
  let window = UIApplication.shared.windows.first
  let dispatchGroup = DispatchGroup()
  var userType: UserType?
  var selectedSchoolID:Int?
  
  lazy var viewModel : schoolListViewModel = {
    return schoolListViewModel()
  }()
  
  //MARK:- ViewController LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.delegate = self
    configureUserTypeSetUP()
    titleString = "DASHBOARD"
    self.view.bringSubviewToFront(schoolStackView)
    
    arrayHeadingTitleAdmin.append(arrayOverview)
    arrayHeadingTitleAdmin.append(arrayAttendance)
    arrayCellTitleAdmin.append(arrayCellTitleOverview)
    arrayCellTitleAdmin.append(arrayCellTitleAttendance)
    
    self.dashboardCollectionView.register(UINib(nibName: "DashboardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DashboardCollectionViewCell")
    self.dashboardCollectionView.register(UINib.init(nibName: "DashboardHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DashboardHeaderView")
    
  }
  
  func configureUserTypeSetUP(){
    
    
    userType = UserType(rawValue: UserManager.shared.currentUser!.userType)
    
    if userType == UserType.admin{
      
      viewBithday.isHidden = true
      schoolView.isHidden = true
      
    //  dispatchGroup.enter()
      
      if let schoolId  = UserManager.shared.currentUser?.school_id {
        self.selectedSchoolID = schoolId
      }
      viewModel.adminDashboard()
      
//      dispatchGroup.notify(queue: .main, execute: {
//        MBProgressHUD.hide(for: self.window!, animated: true)
//      })
      
    }else if userType == UserType.superadmin{
    //  dispatchGroup.enter()
      viewModel.schoolList()
      
      topBarHeight = 100
      viewBithday.isHidden = true
      schoolView.isHidden = false
      setupSchoolDropdown()
      schoolDropdown.headerTitle = "Select School Branch"
     // schoolDropdown.footerTitle = ""
      
      
    }else if userType == UserType.teacher{
      
      if let schoolId  = UserManager.shared.currentUser?.school_id {
        SharedPreferenceManager.shared.getClassNameList(schoolId: "\(schoolId)")
      }
      schoolView.isHidden = true
      viewBithday.isHidden = false
     //dispatchGroup.enter()
      
      if let birthDate = UserProfile.shared.currentUser?.dateOfBirth{
       
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: date)
       
        if currentDate == birthDate{
          viewBithday.isHidden = false
        }else{
          viewBithday.isHidden = true
        }

      }
      
      viewModel.getTeacherDashboard()
      
//      dispatchGroup.notify(queue: .main, execute: {
//        MBProgressHUD.hide(for: self.window!, animated: true)
//      })
//
      //  if let schoolId = self.selectedSchoolID{
      
      
      //  }
    }
      
    else {
      //  viewBit as UserTypehday.isHidden = false
      schoolView.isHidden = true
    }
  }
  
  func setupSchoolDropdown(){
    
     let schoolid = UserDefaults.standard.integer(forKey: "sc")
    
    
    
    schoolDropdown.titleArray = schoolListArray.map({$0.schoolName})
    
    schoolDropdown.subtitleArray = schoolListArray.map({$0.location})
    schoolDropdown.selectionAction = { (index : Int) in
      self.selectedSchoolID = self.schoolListArray[index].id
        
        UserDefaults.standard.set(self.selectedSchoolID, forKey: "sc")
        
     // UserDefaults.standard.integer(forKey: "sc")
      if let instituteId = UserManager.shared.currentUser?.instituteID, let school_id =  self.selectedSchoolID{
        
        self.viewModel.dashboardCount(institute_id: "\(instituteId)", school_id: school_id)
        }
        
    }
    let school_id =  UserDefaults.standard.integer(forKey: "sc")
    
    if school_id > 1{
        
        viewModel.dashboardCount(institute_id: "\(UserManager.shared.currentUser?.instituteID)", school_id: school_id)
    }
        
    else if let instituteId = UserManager.shared.currentUser?.instituteID, let school_id =  self.selectedSchoolID{
        
        viewModel.dashboardCount(institute_id: "\(instituteId)", school_id: school_id)
    }
    

    if schoolListArray.count > 0 {
        if schoolid != 0{
        let index = schoolListArray.firstIndex(where: {$0.id == schoolid})
        schoolDropdown.selectedIndex = index
        
        DispatchQueue.main.async {
            self.schoolDropdown.nameLabel.text = self.schoolListArray[index ?? 0].schoolName
            self.schoolDropdown.section.text = self.schoolListArray[index ?? 0].location
            print(self.schoolListArray[index ?? 0].id)
        }
        }
    }
    




  }
}

// MARK: - Collection View

extension CommonDashboardVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    if userType == UserType.admin{
      return sectionHeader.count
    }else{
      return 1
    }
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if userType == UserType.admin{
      return arrayHeadingTitleAdmin[section].count
    }else if userType == UserType.teacher {
      return headingTitlesArray.count
    }
    else{
      return 4
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCollectionViewCell", for: indexPath) as! DashboardCollectionViewCell
    
    if userType == UserType.admin {
      
      cell.headingLbl.text = arrayHeadingTitleAdmin[indexPath.section][indexPath.row]
      cell.InnerTitleLbl.text = arrayCellTitleAdmin[indexPath.section][indexPath.row]
      
      if indexPath.section == 0 {
        
        switch indexPath.row {
          
        case 0:
          
          if let classRoomCount = adminDashBoardInfo?.totalClassRoomCount{
            cell.countLbl.text = "\(classRoomCount)"
          }else{
            cell.countLbl.text = "0"
          }
        case 1:
          
          if let studentCount = adminDashBoardInfo?.totalStudentCount{
            cell.countLbl.text = "\(studentCount)"
          }else{
            cell.countLbl.text = "0"
          }
          
        case 2:
          
          if let staffCount = adminDashBoardInfo?.totalStaffCount{
            cell.countLbl.text = "\(staffCount)"
          }else{
            cell.countLbl.text = "0"
          }
          
        case 3:
          
          if let suportStaffCount = adminDashBoardInfo?.totalSuportStaffCount{
            cell.countLbl.text = "\(suportStaffCount)"
          }else{
            cell.countLbl.text = "0"
          }
          
        default: break
          
        }
        
      }else{
        
        switch indexPath.row {
          
        case 0:
          
          if let studentPresentCount = adminDashBoardInfo?.studentPresentCount{
            cell.countLbl.text = "\(studentPresentCount)"
          }else{
            cell.countLbl.text = "0"
          }
        case 1:
          
          if let studentAbsentCount = adminDashBoardInfo?.studentAbsentCount{
            cell.countLbl.text = "\(studentAbsentCount)"
          }else{
            cell.countLbl.text = "0"
          }
          
        case 2:
          
          if let teacherPresentCount = adminDashBoardInfo?.teacherPresentCount{
            cell.countLbl.text = "\(teacherPresentCount)"
          }else{
            cell.countLbl.text = "0"
          }
          
        case 3:
          
          if let teacherAbsentCount = adminDashBoardInfo?.teacherAbsentCount{
            cell.countLbl.text = "\(teacherAbsentCount)"
          }else{
            cell.countLbl.text = "0"
          }
          
        default: break
          
        }
      }
      
    }else if userType == UserType.teacher{
      
      cell.headingLbl.text = headingTitlesArray[indexPath.row]
      cell.InnerTitleLbl.text = cellTitlesArray[indexPath.row]
      
      switch indexPath.row {
      case 0:
        if let noOfClassrooms = teacherDashBoardInfo?.noOfClassrooms {
          cell.countLbl.text = "\(noOfClassrooms)"
        }
        else
        {
          cell.countLbl.text = "0"
        }
      case 1:
        if let noOfStudents = teacherDashBoardInfo?.noOfStudents {
          cell.countLbl.text = "\(noOfStudents)"
        }
        else
        {
          cell.countLbl.text = "0"
        }
      case 2:
        if let noOfWorkingDays = teacherDashBoardInfo?.noOfWorkingDays {
          cell.countLbl.text = "\(noOfWorkingDays)"
        }
        else
        {
          cell.countLbl.text = "0"
        }
        
      case 3:
        if let noOfLeaveDays = teacherDashBoardInfo?.noOfLeaveDays  {
          cell.countLbl.text = "\(noOfLeaveDays)" // name changed later
        }
        else
        {
          cell.countLbl.text = "0"
        }
        
      default :
        break
      }
      
    }
    else{
      cell.InnerTitleLbl.text = superadminCellTitlesArray[indexPath.row]
      cell.headingLbl.text = superadminTitlesArray[indexPath.row]
      
      
      switch indexPath.row {
      case 0:
        if let admin = dashBoardInfo?.adminsCount {
          cell.countLbl.text = String(admin)
        }
        else
        {
          cell.countLbl.text = "0"
        }
      case 1:
        if let teacher = dashBoardInfo?.teacher {
          cell.countLbl.text = String(teacher)
        }
        else
        {
          cell.countLbl.text = "0"
        }
      case 2:
        if let SStaff = dashBoardInfo?.supportStaff {
          cell.countLbl.text = String(SStaff)
        }
        else
        {
          cell.countLbl.text = "0"
        }
        
      case 3:
        if let branches = dashBoardInfo?.student  {
          cell.countLbl.text = String(branches) // name changed later
        }
        else
        {
          cell.countLbl.text = "0"
        }
        
      default :
        break
      }
    }
    
    cell.countLbl.textColor = UIColor(hex:0x008DF9 , alpha: 1.0)
    if indexPath.row == 0
    {
      cell.progressCircularView.progressColors = [UIColor(hex:0x53C2FB , alpha: 1.0),UIColor(hex:0xA183F8 , alpha: 1.0),UIColor(hex:0x53C2FB , alpha: 1.0)]
      cell.countLbl.textColor = UIColor(hex:0xA183F8 , alpha: 1.0)
      cell.progressCircularView.trackColor = UIColor(hex:0xE2F4FE , alpha: 1.0)
    }
    else if indexPath.row == 1
    {
      cell.progressCircularView.progressColors = [UIColor(hex:0xA8CD4A, alpha: 1.0),UIColor(hex:0x00A74A , alpha: 1.0),UIColor(hex:0xA8CD4A, alpha: 1.0)]
      cell.countLbl.textColor = UIColor(hex:0x00A74A , alpha: 1.0)
      cell.progressCircularView.trackColor = UIColor(hex:0xF2F6D7 , alpha: 1.0)
    }
    else if indexPath.row == 2
    {
      cell.progressCircularView.progressColors = [UIColor(hex:0x00C8DF , alpha: 1.0),UIColor(hex:0x0058A1 , alpha: 1.0),UIColor(hex:0x00C8DF , alpha: 1.0)]
      cell.countLbl.textColor = UIColor(hex:0x0058A1 , alpha: 1.0)
      cell.progressCircularView.trackColor = UIColor(hex:0xC9F4F9 , alpha: 1.0)
    }
    else
    {
      cell.progressCircularView.progressColors = [UIColor(hex:0xFFB03D , alpha: 1.0),UIColor(hex:0xFF4027 , alpha: 1.0),UIColor(hex:0xFFB03D , alpha: 1.0)]
      cell.countLbl.textColor = UIColor(hex:0xFF4027 , alpha: 1.0)
      cell.progressCircularView.trackColor = UIColor(hex:0xFAD4E4 , alpha: 1.0)
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
    flowayout?.headerReferenceSize = CGSize(width: 0,height: 55)
    let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
    let size:CGFloat = (dashboardCollectionView.frame.size.width - space) / 2.0
    return CGSize(width: size, height: 222)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DashboardHeaderView", for: indexPath) as! DashboardHeaderView
    header.labelHeader.text = sectionHeader[indexPath.section] as String
    return header
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
    if userType == UserType.admin{
      return CGSize(width: 0, height: 45)
    }else{
      return CGSize(width: 0, height: 0)
    }
  }
}

//MARK:- CommonDashboardVC Delegate Methodes
extension CommonDashboardVC:schoolListDelegate {
    func childNameList(schoolList: [ChildName]) {
       // childNameArray = schoolList
    }
    
    func permission(data: PermissionsData) {
        //viewModel.childNameList()
        print("bshbdn")
      // dispatchGroup.leave()
    }
    
  
  func getTeacherDashboardData(at teacherDashboardData: [TeacherDashboardData]) {
    //dispatchGroup.leave()
    teacherDashBoardInfo = teacherDashboardData.first
     //dispatchGroup.enter()
    viewModel.permissionData()
    self.dashboardCollectionView.reloadData()
    
  }
  
  
  func getAdminDashboardData(at adminDashboardData: [AdminDashboardData]) {
    
   // dispatchGroup.leave()
    adminDashBoardInfo = adminDashboardData.first
    arrayAdminDashBoardData = adminDashboardData
    
    if let schoolId = self.selectedSchoolID {
      SharedPreferenceManager.shared.getClassNameList(schoolId: "\(schoolId)")
    }
    // dispatchGroup.enter()
     viewModel.permissionData()
    //viewModel.childNameList()
    self.dashboardCollectionView.reloadData()
  }
  
  func schoolList(schoolList: [SchoolListData]) {
   // dispatchGroup.leave()
    schoolListArray = schoolList
    if let schoolid = schoolListArray.first?.id{
        self.selectedSchoolID = schoolid
    }
    if userType == UserType.superadmin{
      self.setupSchoolDropdown()
    }
    
    
  }
  
  func dashboardCount(dashboard: DashboardCount?) {
    
    dashBoardInfo = dashboard
    if let schoolId = self.selectedSchoolID {
      SharedPreferenceManager.shared.getClassNameList(schoolId: "\(schoolId)")
    }
    viewModel.childNameList()
    self.dashboardCollectionView.reloadData()
  }
  func failure(message: String) {
   // dispatchGroup.leave()
    if let schoolId = self.selectedSchoolID {
      SharedPreferenceManager.shared.getClassNameList(schoolId: "\(schoolId)")
    }
    displayServerError(withMessage: message)
  }
}
