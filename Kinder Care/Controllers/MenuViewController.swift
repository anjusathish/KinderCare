//
//  MenuViewController.swift
//  Kinder Care
//
//  Created by CIPL0681 on 08/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var slidemenuTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var adminLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var menuItemsArr = [String]()
    var menuImgArr = [String]()
    
    var vc : UIViewController!
    
    var profileFirstName : String?
    var profileLastName : String?
    var profileImage : UIImage?
    
    
    var selectedIndex = 0
    
    lazy var viewModel : ProfileViewModel   =  {
        return ProfileViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slidemenuTableView.register(UINib(nibName: "SlideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SlideMenuTableViewCell")
        
        self.mainView.backgroundColor = UIColor.clear
        self.slidemenuTableView.backgroundColor = UIColor.clear
        
        self.slideMenu()
        
        
        // viewModel.delegate = self
        
        //Get Profile Details
        //       if let _userid = UserManager.shared.currentUser?.userID {
        //                 viewModel.getProfileData(userID: String(_userid))
        //             }
        self.profileName()
        slidemenuTableView.reloadData()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        headerView.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    { self.sideMenuViewController.setContentViewController(UIStoryboard.profileStoryboard().instantiateViewController(withIdentifier: "ProfileVC"), animated: true)
        self.sideMenuViewController.hideViewController()
    }
    
    func slideMenu(){
        
        if  let userType = UserManager.shared.currentUser?.userType {
            if let _type = UserType(rawValue:userType ) {
                
                switch _type {
                case .parent:
                    menuItemsArr = ["Dashboard","Family Information","Payment","Messages","Leave Application","Weekly Menu","Calendar","Change Password","Assigned Teacher","Logout"]
                    
                    menuImgArr = ["dashboard","Familyinfo","payment","message","leaveapplication","weeklymenu","calendaricon","changepassword","Familyinfo","logout"]
                    break
                    
                case .teacher:
                    menuItemsArr = ["Dashboard","Attendance","Messages","Leave Application ","Leave Approval","Weekly Menu","Comp off Application","Daily Activity","Add Health","Logout"]
                    
                    menuImgArr = ["dashboard","attendance","message","leaveapplication","leaveapproval","weeklymenu","leaveapplication","dailyactivity","Familyinfo","logout"]
                    break
                    
                case .admin:
                    menuItemsArr = ["Dashboard","Reports","Attendance","Messages","Enrollment Enquiry","Pickup Person Approval","Leave Application","Leave Approval","Comp off Application","Comp off Approval","Weekly Menu","Daily Activity","Logout"]
                    
                    menuImgArr = ["dashboard","report","attendance","message","enrolement","pickupperson","leaveapplication","leaveapproval","leaveapplication","leaveapproval","weeklymenu","dailyactivity","logout"]
                    break
                    
                case .superadmin:
                    menuItemsArr = ["Dashboard","Reports","Attendance","Messages","Enrollment Enquiry","Pickup Person Approval","Leave Approval","Comp off Approval","Logout"]
                    
                    menuImgArr = ["dashboard","report","attendance","message","enrolement","pickupperson","leaveapproval","leaveapproval","logout"]
                    break
                    
                default:
                    break
                }
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        profileName()
    }
    func profileName(){
        if let userName = UserManager.shared.currentUser?.name {
            nameLabel.text = userName
        }
        if let userTypeName = UserManager.shared.currentUser?.userTypeName {
            adminLabel.text = userTypeName
        }
        if let img = UserManager.shared.currentUser?.profile{
            if let urlString = img.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
                if let url = URL(string: urlString) {
                    profileImageView.sd_setImage(with: url)
                }
            }
            
        }
        //profileImageView
        if  let userType = UserManager.shared.currentUser?.userType {
            if let _type = UserType(rawValue:userType ) {
                switch _type {
                case .parent,.teacher,.admin:
                    break
                    
                case .superadmin:
                    //  nameLabel.text = "Chris Hemsworth"
                    /*    if  let img = UserManager.shared.currentUser?.profile{
                     
                     let url = URL(string: img)
                     if let data = try? Data(contentsOf: url!)
                     {
                     profileImage = UIImage(data: data)
                     profileImageView.image = profileImage
                     }
                     
                     }*/
                    break
                default:
                    break
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.masksToBounds = false
        profileImageView.clipsToBounds = true
        
    }
    
    private func alert(){
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Logout ?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {
            action in
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: {
            action in
            
            UserManager.shared.deleteActiveUser()
            
            let viewController = UIStoryboard.onBoardingStoryboard().instantiateViewController(withIdentifier: "LoginVC")
            let navController = UINavigationController(rootViewController: viewController)
            navController.isNavigationBarHidden = true
            UserDefaults.standard.set(0, forKey: "sc")
            UIApplication.shared.windows.first?.rootViewController = navController
            
        }))
        self.present(alert, animated: true, completion: nil)
        
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

extension MenuViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItemsArr.count
    }
    
    /*  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return UITableView.automaticDimension
     }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlideMenuTableViewCell", for: indexPath) as! SlideMenuTableViewCell
        
        cell.labelMenu.text = menuItemsArr[indexPath.row]
        
        if menuItemsArr[indexPath.row] == "Messages"{
            cell.labelCount.isHidden = true
            cell.labelCount.layer.cornerRadius = cell.labelCount.frame.height/2
            cell.labelCount.layer.masksToBounds = false
            cell.labelCount.clipsToBounds = true
            cell.trailingLabelCount.constant = 60.0
        }else{
            cell.labelCount.isHidden = true
        }
        let menuIcon = menuImgArr[indexPath.row]
        cell.imgMenu.image = UIImage.init(named: menuIcon)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        if selectedIndex == indexPath.row{
            cell.labelMenu.textColor = UIColor.white
            cell.imgMenu.tintColor = UIColor.white
        }else{
            cell.labelMenu.textColor = UIColor(red:0.75, green:0.71, blue:0.95, alpha:1.0)
            cell.imgMenu.tintColor = UIColor(red:0.75, green:0.71, blue:0.95, alpha:1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.row
        self.slidemenuTableView.reloadData()
        
        if  let userType = UserManager.shared.currentUser?.userType {
            if let _type = UserType(rawValue:userType ) {
                
                
                
                switch _type {
                case .parent:
                    self.parentModule()
                    break
                    
                case .teacher:
                    self.teacherModule()
                    break
                    
                case .admin:
                    self.adminModule()
                    break
                    
                case .superadmin:
                    self.superadminModule()
                    break
                    
                default:
                    break
                }
            }
        }
        
    }
    
    func parentModule(){
        
        switch (selectedIndex) {
        case 0:
            
            vc = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "DashboardVC")
            
        case 1:
            
            vc = UIStoryboard.FamilyInformationStoryboard().instantiateViewController(withIdentifier: "FamilyInformationVC")
            
        case 2:
            
            vc = UIStoryboard.paymentStoryboard().instantiateViewController(withIdentifier: "PaymentListVC")
            
        case 3:
            
            vc = UIStoryboard.messageStoryboard().instantiateViewController(withIdentifier: "MessageListVC")
            
        case 4:
            
            vc = UIStoryboard.leaveStoryboard().instantiateViewController(withIdentifier: "LeaveListVC")
            
        case 5:
            
            vc = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "WeeklyMenuVC")
            
        case 6:
            
            vc = UIStoryboard.calendarStoryboard().instantiateViewController(withIdentifier: "CalendarVC")
            
        case 7:
            
            vc = UIStoryboard.profileStoryboard().instantiateViewController(withIdentifier: "ChangePasswordVC")
        case 8:
             vc = UIStoryboard.FamilyInformationStoryboard().instantiateViewController(withIdentifier: "AssignedTeacherViewController")
            
            
        case 9:
            vc = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "DashboardVC")
            self.alert()
            break
            
        default:
            break
            
        }
        
        self.sideMenuViewController.setContentViewController(vc, animated: true)
        self.sideMenuViewController.hideViewController()
    }
    
    func teacherModule(){
        
        switch (selectedIndex) {
        case 0:
            
            vc = UIStoryboard.commonDashboardStoryboard().instantiateViewController(withIdentifier: "CommonDashboardVC")
            
        case 1:
            
            vc = UIStoryboard.attendanceStoryboard().instantiateViewController(withIdentifier: "AttendanceVC")
            
        case 2:
            
            vc = UIStoryboard.messageStoryboard().instantiateViewController(withIdentifier: "MessageListVC")
            
        case 3:
            
            vc = UIStoryboard.leaveStoryboard().instantiateViewController(withIdentifier: "LeaveListVC")
            
        case 4:
            
            vc = UIStoryboard.leaveStoryboard().instantiateViewController(withIdentifier: "LeaveApprovalVC")
        case 5:
            
            vc = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "WeeklyMenuVC")
            
        case 6:
            
            vc = UIStoryboard.compOffStoryboard().instantiateViewController(withIdentifier: "CompOffListVC")
            
        case 7:
            
            vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier: "DailyActivityVC")
            
        case 8:
            vc = UIStoryboard.profileStoryboard().instantiateViewController(withIdentifier: "HealthStatusListViewController")
            
        case 9:
            vc = UIStoryboard.commonDashboardStoryboard().instantiateViewController(withIdentifier: "CommonDashboardVC")
            self.alert()
            break
            
        default:
            break
            
        }
        
        self.sideMenuViewController.setContentViewController(vc, animated: true)
        self.sideMenuViewController.hideViewController()
        
    }
    
    func adminModule(){
        
        switch (selectedIndex) {
        case 0:
            
            vc = UIStoryboard.commonDashboardStoryboard().instantiateViewController(withIdentifier: "CommonDashboardVC")
            
        case 1:
            
            vc = UIStoryboard.reportsStoryboard().instantiateViewController(withIdentifier: "ReportsViewController")
            
        case 2:
            
            vc = UIStoryboard.attendanceStoryboard().instantiateViewController(withIdentifier: "AttendanceVC")
            
        case 3:
            
            vc = UIStoryboard.messageStoryboard().instantiateViewController(withIdentifier: "MessageListVC")
            
        case 4:
            
            vc = UIStoryboard.enrolmentEnquiryStoryboard().instantiateViewController(withIdentifier: "EnrolmentEnquiryViewController")
        case 5:
            
            vc = UIStoryboard.FamilyInformationStoryboard().instantiateViewController(withIdentifier: "PickUpPersonApprovalViewController")
            
        case 6:
            
            vc = UIStoryboard.leaveStoryboard().instantiateViewController(withIdentifier: "LeaveListVC")
            
        case 7:
            
            vc = UIStoryboard.leaveStoryboard().instantiateViewController(withIdentifier: "LeaveApprovalVC")
          
        case 8:
            
          vc = UIStoryboard.compOffStoryboard().instantiateViewController(withIdentifier: "CompOffListVC")
            
        case 9:
            
          vc = UIStoryboard.compOffStoryboard().instantiateViewController(withIdentifier: "CompOffApprovalVC")
          
        case 10:
            
            vc = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "WeeklyMenuVC")
            
        case 11:
            
            vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier: "DailyActivityVC")
            
        case 12:
            vc = UIStoryboard.commonDashboardStoryboard().instantiateViewController(withIdentifier: "CommonDashboardVC")
            self.alert()
            break
            
        default:
            break
            
        }
        
        self.sideMenuViewController.setContentViewController(vc, animated: true)
        self.sideMenuViewController.hideViewController()
        
    }
    
    func superadminModule(){
        
        switch (selectedIndex) {
        case 0:
            
            vc = UIStoryboard.commonDashboardStoryboard().instantiateViewController(withIdentifier: "CommonDashboardVC")
            
        case 1:
            
            vc = UIStoryboard.reportsStoryboard().instantiateViewController(withIdentifier: "ReportsViewController")
            
        case 2:
            
            vc = UIStoryboard.attendanceStoryboard().instantiateViewController(withIdentifier: "AttendanceVC")
            
        case 3:
            
            vc = UIStoryboard.messageStoryboard().instantiateViewController(withIdentifier: "MessageListVC")
            
        case 4:
            
            vc = UIStoryboard.enrolmentEnquiryStoryboard().instantiateViewController(withIdentifier: "EnrolmentEnquiryViewController")
        case 5:
            
            vc = UIStoryboard.FamilyInformationStoryboard().instantiateViewController(withIdentifier: "PickUpPersonApprovalViewController")
            
        case 6:
            vc = UIStoryboard.leaveStoryboard().instantiateViewController(withIdentifier: "LeaveApprovalVC")
          
        case 7:
            
          vc = UIStoryboard.compOffStoryboard().instantiateViewController(withIdentifier: "CompOffApprovalVC")
            
        case 8:
            vc = UIStoryboard.commonDashboardStoryboard().instantiateViewController(withIdentifier: "CommonDashboardVC")
            self.alert()
            break
            
        default:
            break
            
        }
        
        self.sideMenuViewController.setContentViewController(vc, animated: true)
        self.sideMenuViewController.hideViewController()
        
    }
    
}

extension MenuViewController : profileDelegate {
    func healthViewSuccess(viewHealth: [viewHealth]) {
        
    }
    
    func editProfileData(message: String) {
        
    }
    
    func changePasswordSuccessfully(message: String) {
        
    }
    
    func healthStatusListSuccess(listHealth: [ListHelath]) {
        
    }
    
    func healthAddSuccuess(message:String) {
        
    }
    
    func healthDeleteSuccess(message: String) {
        
    }
    
    
    
    func getProfileData(profileData: ProfileData) {
        if let fname = profileData.firstname{
            profileFirstName = fname
        }
        if  let lname = profileData.lastname {
            profileLastName = lname
        }
        
        
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
    }
    
    
}
