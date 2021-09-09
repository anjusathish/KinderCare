//
//  ReportsViewController.swift
//  Kinder Care
//
//  Created by CIPL0681 on 29/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import AAFloatingButton
import DZNEmptyDataSet

class ReportsViewController: BaseViewController {
    
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var reportsTable: UITableView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var labelAbsent: UILabel!
    @IBOutlet weak var labelPresent: UILabel!
    @IBOutlet weak var labelStudent: UILabel!
    
    @IBOutlet weak var lblWorkingTop: UILabel!
    @IBOutlet weak var btnAttachment: AAFloatingButton!
    @IBOutlet weak var segmentControlReport: CTSegmentControl!
    @IBOutlet weak var labelFilter: UILabel!
    @IBOutlet weak var childDropdown: ChildDropDown!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var calenderView: CTDayCalender!
    var schoolListArray = [SchoolListData]()
    var schoolID:Int?
    
    var reportsArray = [ReportAttendance]()
    var classNameListArray = [ClassModel]()
    var sectionListArray = [Section]()
    var delegate:reportsTableViewDelegate?
    
    var failureMessage:String?
    
    var selectedUserType:UserType = .student
    var selectedClass : ClassModel?
    var selectedSection : Section?
    var fromDate:String?
    var toDate:String?
    var resetFromDate:String?
     var resetToDate:String?
    var checkReset:Bool? = false
    lazy var viewModel : ReportViewModel = {
        return ReportViewModel()
    }()
    
    public var selectedStudentsArray : [Student] = []
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        topBarHeight = 100
        titleString = "REPORTS"
        viewModel.delegate = self
        
        let schoolidDat = UserDefaults.standard.integer(forKey: "sc")
        if  schoolidDat > 0 {
             self.schoolID = schoolidDat
            if let schoolData = UserManager.shared.schoolList{
            schoolListArray =  schoolData
            }}
        
        else if let schoolData = UserManager.shared.schoolList {
            schoolListArray = schoolData
            self.schoolID = schoolListArray.map({$0.id}).first
        }
        
        reportsTable.emptyDataSetDelegate = self
        reportsTable.emptyDataSetSource = self
        
        reportsTable.tableFooterView = UIView()
        reportsTable.separatorColor = UIColor.clear
        checkSalaryTap()
        reportsTable.register(UINib(nibName: "ReportsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportsTableViewCell")
        
        btnAttachment.onClick {
            print("btn attchment")
        }
        
        self.setUpUIConfigure()
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        let startOfMonth = Calendar.current.date(from: comp)!
        
      var comps2 = DateComponents()
      comps2.month = 1
      comps2.day = -1
      let endOfMonth = Calendar.current.date(byAdding: comps2, to: startOfMonth)
      print(dateFormatter.string(from: endOfMonth!))
        
        fromDate = dateFormatter.string(from: startOfMonth)
        toDate = dateFormatter.string(from: date)
        resetFromDate = dateFormatter.string(from: startOfMonth)
               resetToDate = dateFormatter.string(from: date)
        
    }
    
    func checkSalaryTap(){
        
        if let settingsValue  = UserManager.shared.currentUser?.permissions?.viewSalary {
            if settingsValue == 0{
               // let userType = UserManager.shared.currentUser?.userType
               // let _type = UserType(rawValue:userType!)
                segmentControlReport.segmentTitles = "Attendance"
            }
            else if settingsValue == 1{
                let userType = UserManager.shared.currentUser?.userType
                let _type = UserType(rawValue:userType!)
                segmentControlReport.segmentTitles = _type!.reportTitles
                
            }
            
        }
    }
    
    
    func setUpUIConfigure() {
        
        if  let userType = UserManager.shared.currentUser?.userType {
            if let _type = UserType(rawValue:userType ) {
                
                
                switch  _type {
                case .admin:
                    childDropdown.isHidden = true
                    topConstraint.constant = -60
                    self.view.bringSubviewToFront(segmentView)
                    if let schoolID = UserManager.shared.currentUser?.school_id {
                        viewModel.classNameList(schoolId: "\(schoolID)")
                        self.schoolID = schoolID
                    }
                    
                case .superadmin:
                    
                    topBarHeight = 100
                    childDropdown.isHidden = false
                    self.setupSchoolDropdown()
                    childDropdown.headerTitle = "Select School Branch"
                   // childDropdown.footerTitle = ""
                    
                    if let schoolID = self.schoolID {
                        viewModel.classNameList(schoolId: "\(schoolID)")
                    }
                    
                    break
                    
                default:
                    break
                }
            }
        }
        
        
    }
    
    
    func getWorkingDays() {
        
        if let schoolID = self.schoolID, let classId = selectedClass?.id, let section = selectedSection?.id,let fromDate = fromDate,let toDate = toDate {
            self.viewModel.reportAttendance(usertype_id: selectedUserType.rawValue, fromdate: fromDate, todate: toDate, school_id: schoolID, className: classId, section: section)
        }
    }
    
    func setupSchoolDropdown(){
        
        let schoolid = UserDefaults.standard.integer(forKey: "sc")
        self.view.bringSubviewToFront(childDropdown)
        
        childDropdown.titleArray = schoolListArray.map({$0.schoolName})
        childDropdown.subtitleArray = schoolListArray.map({$0.location})
        childDropdown.selectionAction = { (index : Int) in
            self.schoolID = self.schoolListArray[index].id
            UserDefaults.standard.set(self.schoolID, forKey: "sc")
            if let _schoolId = self.schoolID {
                SharedPreferenceManager.shared.getClassNameList(schoolId: "\(_schoolId)")
            }
            
            self.getWorkingDays()
        }
        
        if schoolListArray.count > 0 {
             if schoolid != 0 {
            let index = schoolListArray.firstIndex(where: {$0.id == schoolid})
            childDropdown.selectedIndex = index
            
            DispatchQueue.main.async {
                self.childDropdown.nameLabel.text = self.schoolListArray[index ?? 0].schoolName
                self.childDropdown.section.text = self.schoolListArray[index ?? 0].location
            }
            }
        }
        
    }
    
    func setupFilterlabel(){
        if  selectedUserType.stringValue  == "Admin" {
            if let _fromDate = fromDate,let _toDate = toDate {
            
            let str = "Filter : User -  \(selectedUserType.stringValue)  / From Date - \(_fromDate) / To Date - \(_toDate)"
                      
                      let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: str)
                      attributedString.setColorForStr(textToFind: "User", color: UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0))
                      attributedString.setColorForStr(textToFind: "Filter :", color: UIColor(red:0.95, green:0.61, blue:0.07, alpha:1.0))
                      attributedString.setColorForStr(textToFind: "Class", color: UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0))
                      attributedString.setColorForStr(textToFind: "Section", color: UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0))
                      attributedString.setColorForStr(textToFind: "From Date", color: UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0))
                      attributedString.setColorForStr(textToFind: "To Date", color: UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0))
                      attributedString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .regular)], range: NSMakeRange(0, attributedString.length))
                      
                      self.labelFilter.isHidden = false
                      self.labelFilter.attributedText = attributedString
            
        }
        }
        
        
        else if let className = selectedClass?.className, let section = selectedSection?.section {
            
            let _toDate = toDate!.getDateAsStringWith(inFormat: "yyyy-MM-dd", outFormat: "dd-MM-yyyy")
            let _fromDate = fromDate!.getDateAsStringWith(inFormat: "yyyy-MM-dd", outFormat: "dd-MM-yyyy")
            
            let str = "Filter : User -  \(selectedUserType.stringValue) / Class - \(className) / Section - \(section) / From Date - \(_fromDate) / To Date - \(_toDate)"
            
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: str)
            attributedString.setColorForStr(textToFind: "User", color: UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0))
            attributedString.setColorForStr(textToFind: "Filter :", color: UIColor(red:0.95, green:0.61, blue:0.07, alpha:1.0))
            attributedString.setColorForStr(textToFind: "Class", color: UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0))
            attributedString.setColorForStr(textToFind: "Section", color: UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0))
            attributedString.setColorForStr(textToFind: "From Date", color: UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0))
            attributedString.setColorForStr(textToFind: "To Date", color: UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0))
            attributedString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .regular)], range: NSMakeRange(0, attributedString.length))
            
            self.labelFilter.isHidden = false
            self.labelFilter.attributedText = attributedString
        }
    }
    
    override func viewDidLayoutSubviews() {
        btnFilter.layer.cornerRadius = 20
        filterView.layer.cornerRadius = 5
        headerView.roundCorners([.topLeft, .topRight], radius: 10)
        shadowView.dropShadow()
    }
    
    
    @IBAction func segmentValueChanged(_ sender: CTSegmentControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            labelAbsent.text = "Absent Days"
            labelPresent.text = "Present Days"
            labelStudent.text = "Student Name"
             lblWorkingTop.isHidden = false
            if let schoolID = self.schoolID {
                viewModel.classNameList(schoolId: "\(schoolID)")
            }
            
        case 1:
            labelAbsent.text =  "Salary"
            labelPresent.text = "Staff Type"
            labelStudent.text = "Staff Name"
            lblWorkingTop.isHidden = true
            
                
            let Createdate = fromDate!.getDateAsStringWith(inFormat: "yyyy-MM-dd", outFormat: "dd-MM-yyyy")
            
            
            let str = "Filter : Staff Type - Teacher / From Date - \(Createdate) / To Date - \(Date().getasString(inFormat: "dd-MM-yyyy"))/ "
            
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: str)
            attributedString.setColorForStr(textToFind: "Staff Type", color: UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0))
            attributedString.setColorForStr(textToFind: "Filter :", color: UIColor(red:0.95, green:0.61, blue:0.07, alpha:1.0))
            attributedString.setColorForStr(textToFind: "date", color: UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0))
            attributedString.setColorForStr(textToFind: "Section", color: UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0))
            attributedString.setColorForStr(textToFind: "From Date", color: UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0))
            attributedString.setColorForStr(textToFind: "To Date", color: UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.0))
            attributedString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .regular)], range: NSMakeRange(0, attributedString.length))
            
            self.labelFilter.attributedText = attributedString
            
            if let schoolID = schoolID {
                
                viewModel.salaryFilter(usertype_id: UserType.teacher.rawValue, fromdate: Date().getasString(inFormat: "yyyy-MM-dd"), todate: Date().getasString(inFormat: "yyyy-MM-dd"), school_id: schoolID)
                
            }
            
        default: break
        }
        
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard.reportsStoryboard()
        
        switch segmentControlReport.selectedSegmentIndex {
            
        case 0:
            let attendanceVC = storyBoard.instantiateViewController(withIdentifier: "AttendanceFilterVC") as! AttendanceFilterVC
            attendanceVC.delegate = self
            attendanceVC.classNameListArray = classNameListArray
            attendanceVC.sectionArray = sectionListArray
            attendanceVC.selectedSection = selectedSection
            attendanceVC.selectedClass = selectedClass
            attendanceVC.selectedUserType = selectedUserType
            attendanceVC.schoolID = self.schoolID
            attendanceVC.fromDate = fromDate
            attendanceVC.toDate = toDate
            attendanceVC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(attendanceVC, animated: true, completion: nil)
        case 1:
            let salaryVC = storyBoard.instantiateViewController(withIdentifier: "SalaryFilterVC") as! SalaryFilterVC
            salaryVC.delegate = self
            salaryVC.fromDate = fromDate
            salaryVC.toDate = toDate
            salaryVC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(salaryVC, animated: true, completion: nil)
        default: break
        }
        
        
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        if let schoolID = schoolID, let sectionId = selectedSection?.id, let classId = selectedClass?.id {
            
            viewModel.reportAttendance(usertype_id: 6, fromdate: resetFromDate ?? "" , todate: resetToDate ?? "", school_id: schoolID, className: classId, section: sectionId)
        }
        resetFromDate = fromDate
        resetToDate = toDate
        selectedUserType = UserType.student
        setupFilterlabel()
        checkReset = true
    }
    
    
    @IBAction func downloadBtn(_ sender: Any) {
        
        switch segmentControlReport.selectedSegmentIndex {
            
            case 0:
            if let schoolID = self.schoolID, let classId = selectedClass?.id, let section = selectedSection?.id {
                self.viewModel.studentExport(usertype_id: 6, fromdate: Date().getasString(inFormat: "yyyy-MM-dd"), todate: Date().getasString(inFormat: "yyyy-MM-dd"), school_id: schoolID, classId: classId, section: section)
            }
        case 1:
            if let schoolID = self.schoolID {
                
                self.viewModel.salaryExport(user_type: 4, fromdate: Date().getasString(inFormat: "yyyy-MM-dd"), todate: Date().getasString(inFormat: "yyyy-MM-dd"), school_id: schoolID)
                       }
            
            
        default: break
            
        }
        
        
    }
    
    
}

extension ReportsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reportsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportsTableViewCell", for: indexPath) as! ReportsTableViewCell
        cell.shadowView .dropShadow()
        
        switch segmentControlReport.selectedSegmentIndex {
        case 0:
            cell.lblWorkingDays.isHidden = false
            cell.labelStudent.text = reportsArray[indexPath.row].name
            
            if let presentDays = reportsArray[indexPath.row].presentDays{
                cell.labelPresent.text = "\(presentDays)"
            }
            if let absentDays = reportsArray[indexPath.row].absentDays{
                cell.labelAbsent.text = "\(absentDays)"
            }
            if let workingDays = reportsArray[indexPath.row].workingDays{
                cell.lblWorkingDays.text = "\(workingDays)"
            }
            
            
        case 1:
            cell.lblWorkingDays.isHidden = true
            cell.labelStudent.text = reportsArray[indexPath.row].name
            cell.labelPresent.text = "\(reportsArray[indexPath.row].userType)"
            if let salary = reportsArray[indexPath.row].salary{
                cell.labelAbsent.text = "\(salary)"
            }
            
            
        default: break
        }
        
        
        
        if (indexPath.row % 2 == 0)
        {
            cell.contentView.backgroundColor = UIColor.white
        }
        else
        {
            cell.contentView.backgroundColor = colorForIndex(index: indexPath.row)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    func colorForIndex(index: Int) -> UIColor
    {
        let itemCount = reportsArray.count - 1
        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        
        return UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
    }
    
}

extension UIView {
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        
    }
    
}

extension NSMutableAttributedString {
    
    func setColorForStr(textToFind: String, color: UIColor) {
        
        let range = self.mutableString.range(of: textToFind, options:NSString.CompareOptions.caseInsensitive);
        if range.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range);
        }
        
    }
}

extension ReportsViewController:ReportDelegate {
    func studentReportSuccessful(data: ExportResponse) {
        
        let url = NSURL(string: data.data!)

        let urlRequest = NSURLRequest(url: url! as URL)

        NSURLConnection.sendAsynchronousRequest(urlRequest as URLRequest, queue: OperationQueue.main, completionHandler: {
             response, data, error in

             if error != nil {
                 print("There was an error")

             } else {
                self.displayServerSuccess(withMessage: "Downloaded Successfully")
                 print(data)
             }
         })
    }
    
    func salaryExportSuccessful(data: ExportResponse) {
        let url = NSURL(string: data.data!)

        let urlRequest = NSURLRequest(url: url! as URL)

        NSURLConnection.sendAsynchronousRequest(urlRequest as URLRequest, queue: OperationQueue.main, completionHandler: {
             response, data, error in

             if error != nil {
                 print("There was an error")

             } else {
                self.displayServerSuccess(withMessage: "Downloaded Successfully")
                 print(data)
             }
         })

    }
    
    func staffExportSuccessful(data: ExportResponse) {
        
        let url = NSURL(string: data.data!)

        let urlRequest = NSURLRequest(url: url! as URL)

        NSURLConnection.sendAsynchronousRequest(urlRequest as URLRequest, queue: OperationQueue.main, completionHandler: {
             response, data, error in

             if error != nil {
                 print("There was an error")

             } else {
                self.displayServerSuccess(withMessage: "Downloaded Successfully")
                 print(data)
             }
         })

        
    }
    
    
    func sectionSuccessful(list: [Section]) {
        
        sectionListArray = list
        selectedSection = list.first
        setupFilterlabel()
        if let schoolID = schoolID, let sectionId = selectedSection?.id, let classId = selectedClass?.id,let fromDate = fromDate {
            
            viewModel.reportAttendance(usertype_id: selectedUserType.rawValue, fromdate: fromDate, todate: Date().getasString(inFormat: "yyyy-MM-dd"), school_id: schoolID, className: classId, section: sectionId)
        }
    }
    
    func classNameSuccessful(classList: [ClassModel]) {
        
        classNameListArray = classList
        selectedClass = classList.first
        if let classid = classList.first?.id,let schoolId = self.schoolID{
            viewModel.sectionList(school_id: schoolId, class_id: classid)
        }
        
    }
    
    func salaryFilterSuccessfull(salaryFilter: ReportAttendanceResponse) {
        
        if let data = salaryFilter.data{
            reportsArray = data
        }
        
        if let message =  salaryFilter.message {
            reportsArray.removeAll()
            displayServerSuccess(withMessage: message)
            failureMessage = message
            self.reportsTable.reloadData()
            
        }
        
        self.reportsTable.reloadData()
    }
    
    func attendanceReportSuccessfull(attendance: ReportAttendanceResponse) {
        
        if let data = attendance.data{
            reportsArray = data
             self.reportsTable.reloadData()
        }
        if let message =  attendance.message {
            reportsArray.removeAll()
            displayServerSuccess(withMessage: message)
            failureMessage = message
            self.reportsTable.reloadData()
            
        }
        self.labelFilter.isHidden = false
        
        self.reportsTable.reloadData()
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
        failureMessage = message
        self.labelFilter.isHidden = false
        reportsArray.removeAll()
        self.reportsTable.reloadData()
    }
}

extension ReportsViewController:reportsTableViewDelegate{
    
    func reportAttendanceDelegate(userType: UserType, classModel: ClassModel, section: Section, fromDate: String, toDate: String, sectionArray: [Section]) {
        if checkReset == false {
        
        
        self.sectionListArray = sectionArray
        self.selectedUserType = userType
        self.selectedClass = classModel
        self.selectedSection = section
        self.fromDate = fromDate
        self.toDate = toDate
        
        }
        getWorkingDays()
        setupFilterlabel()
        
    }
    
}

extension ReportsViewController:salaryFilterTableViewDelegate {
    
    func salaryFilterTableView(UserType: Int, fromDate: String, toDate: String) {
        
        if let schoolID = schoolID {
            
            viewModel.salaryFilter(usertype_id: UserType, fromdate: fromDate, todate: toDate, school_id: schoolID)
            self.fromDate = fromDate
            self.toDate = toDate
            setupFilterlabel()
        }
    }
}

extension ReportsViewController : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var message = "No data available !"
        
        if let _failureMessage = failureMessage {
            message = _failureMessage
        }
        
        return message.formatErrorMessage()
    }
}


