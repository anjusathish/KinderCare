//
//  AttendanceFilterVC.swift
//  Kinder Care
//
//  Created by CIPL0681 on 02/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol reportsTableViewDelegate{
    func reportAttendanceDelegate(userType:UserType,classModel:ClassModel,section:Section,fromDate:String,toDate:String,sectionArray:[Section])
}

class AttendanceFilterVC: BaseViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var fromDateTxtFld: CTTextField!
    @IBOutlet weak var toDateTxtFld: CTTextField!
    @IBOutlet weak var studentCheckBox: BEMCheckBox!
    @IBOutlet weak var teacherCheckBox: BEMCheckBox!
    @IBOutlet weak var adminCheckBox: BEMCheckBox!
    @IBOutlet weak var classFilterStackView: UIStackView!
    @IBOutlet weak var sectionFilterStackView: UIStackView!
    
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var classView: UIView!
    @IBOutlet weak var adminStackView: UIStackView!
    var classNameListArray : [ClassModel] = []
    var sectionArray = [Section]()
    var selectedClass: ClassModel!
    var selectedSection:Section!
    var delegate:reportsTableViewDelegate?
    var selectedUserType : UserType = .student
    var schoolID:Int?
    var fromDate:String?
    var toDate:String?
    var selectedDate:Date?
    var fromDateSelected: Date?
    
    lazy var viewModel : AttendanceListViewModel = {
        return AttendanceListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        if let _fromDate = fromDate,let _toDate = toDate{
            
            fromDateTxtFld.text = _fromDate.getDateAsStringWith(inFormat: "yyyy-MM-dd", outFormat: "dd-MM-yyyy")
            toDateTxtFld.text = _toDate.getDateAsStringWith(inFormat: "yyyy-MM-dd", outFormat: "dd-MM-yyyy")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            fromDateSelected = dateFormatter.date(from:_fromDate)!
            
            
        }
        
        studentCheckBox.tag = UserType.student.rawValue
        teacherCheckBox.tag = UserType.teacher.rawValue
        adminCheckBox.tag = UserType.admin.rawValue
        
        for item in [studentCheckBox,teacherCheckBox,adminCheckBox] {
            if item?.tag == selectedUserType.rawValue {
                item?.on = true
            }
            else {
                item?.on = false
            }
        }
        
        setupClass()
        setupSection()
        configureUI()
    }
    
    func configureUI(){
        
        if  let userType = UserManager.shared.currentUser?.userType {
            if let _type = UserType(rawValue:userType ) {
                
                
                switch  _type {
                    
                case .parent,.teacher,.all,.student,.superadmin:
                    break
                    
                case .admin:
                    adminStackView.isHidden = true
                }
            }
            
        }
    }
    
    @IBAction func studentCheckBoxAction(_ sender: Any) {
        teacherCheckBox.on  = false
        adminCheckBox.on = false
        selectedUserType = .student
        classFilterStackView.isHidden = false
        sectionFilterStackView.isHidden = false
        classView.isHidden = false
        sectionView.isHidden = false
    }
    
    @IBAction func teacherCheckBoxAction(_ sender: Any) {
        studentCheckBox.on  = false
        adminCheckBox.on = false
        selectedUserType = .teacher
        classFilterStackView.isHidden = true
        sectionFilterStackView.isHidden = true
        classView.isHidden = true
        sectionView.isHidden = true
    }
    
    @IBAction func adminCheckBoxAction(_ sender: Any) {
        
        teacherCheckBox.on  = false
        studentCheckBox.on = false
        selectedUserType = .admin
        classFilterStackView.isHidden = true
        sectionFilterStackView.isHidden = true
        classView.isHidden = true
        sectionView.isHidden = true
        
    }
    
    func setupClass() {
        
        for item in classFilterStackView.subviews {
            item.removeFromSuperview()
        }
        
        for x in 0...classNameListArray.count - 1 {
            let item  = classNameListArray[x]
            let stack = UIStackView()
            stack.axis = .horizontal
            
            let classlabel = createLabel()
            classlabel.text = item.className
            
            let checkBox = createCheckBox()
            checkBox.addTarget(self, action: #selector(classRoomAction(sender:)), for: .valueChanged)
            checkBox.tag = x
            
            if selectedClass.id == item.id{
                checkBox.on = true
            }
            else {
                checkBox.on = false
            }
            
            stack.addArrangedSubview(classlabel)
            stack.addArrangedSubview(checkBox)
            classFilterStackView.addArrangedSubview(stack)
        }
    }
    
    func setupSection() {
        
        for item in sectionFilterStackView.subviews {
            item.removeFromSuperview()
        }
        
        for x in 0...sectionArray.count - 1{
            let item  = sectionArray[x]
            let stack = UIStackView()
            stack.axis = .horizontal
            
            let classlabel = createLabel()
            classlabel.text = item.section
            
            let checkBox = createCheckBox()
            checkBox.addTarget(self, action: #selector(sectionRoomAction(sender:)), for: .valueChanged)
            checkBox.tag = x
            
            if selectedSection.id == item.id{
                checkBox.on = true
            }
            else {
                checkBox.on = false
            }
            
            stack.addArrangedSubview(classlabel)
            stack.addArrangedSubview(checkBox)
            sectionFilterStackView.addArrangedSubview(stack)
        }
    }
    
    func createLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .ctDarkGray
        return label
    }
    
    func createCheckBox() -> BEMCheckBox {
        let checkBox = BEMCheckBox(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        checkBox.onTintColor = UIColor.ctBlue
        checkBox.onCheckColor = UIColor.clear
        
        return checkBox
    }
    
    override func viewDidLayoutSubviews() {
        contentView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    @objc func classRoomAction(sender:BEMCheckBox){
        for case let item as UIStackView in classFilterStackView.subviews {
            
            for case let checkbox as BEMCheckBox in item.subviews {
                checkbox.on = false
            }
        }
        
        sender.on = true
        selectedClass = classNameListArray[sender.tag]
        if let schoolId = self.schoolID {
            viewModel.sectionList(school_id: schoolId, class_id: selectedClass.id ?? 0)
        }
        
    }
    
    @objc func sectionRoomAction(sender:BEMCheckBox){
        
        for case let item as UIStackView in sectionFilterStackView.subviews {
            
            for case let checkbox as BEMCheckBox in item.subviews {
                checkbox.on = false
            }
        }
        
        sender.on = true
        selectedSection = sectionArray[sender.tag]
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyAction(_ sender: UIButton) {
        
        if let fromDate = fromDate,let toDate = toDate {
            
            self.dismiss(animated: true, completion: {
                self.delegate?.reportAttendanceDelegate(userType: self.selectedUserType, classModel: self.selectedClass, section:self.selectedSection, fromDate: fromDate, toDate: toDate, sectionArray: self.sectionArray)
            })
        }
        else{
            displayServerError(withMessage: "Please Select Types")
        }
    }
    
    
    
}

extension AttendanceFilterVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == fromDateTxtFld   {
            
            let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
            toDateTxtFld.text = ""
            picker.dismissBlock = { date in
                self.selectedDate = date
                self.fromDateSelected = date
                self.fromDateTxtFld.text = date.asString(withFormat: "dd-MM-yyyy")
                self.fromDate = date.asString(withFormat: "yyyy-MM-dd")
            }
            return false
        }
        
        if textField == toDateTxtFld   {
            
            let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
            picker.timePicker.minimumDate = fromDateSelected
            
            picker.dismissBlock = { date in
                self.selectedDate = date
                self.toDateTxtFld.text = date.asString(withFormat: "dd-MM-yyyy")
                self.toDate = date.asString(withFormat: "yyyy-MM-dd")
            }
            return false
        }
        
        return true
    }
}

extension AttendanceFilterVC:AttendanceListDelegate{
    func getAttendanceListSuccess(attendanceList: [Attendance], forUserType: Int) {
        
    }
    
    func updateAttendanceListSuccess() {
        
    }
    
    
    func gettingAttendanceListFailure(message: String) {
        
    }
    
    func getAttendanceListSuccess(attendanceList: [Attendance]) {
        
    }
    
    func getClassNameListSuccess(classList: [ClassModel]) {
        
    }
    
    func getSectionNameListSuccess(sectionList: [Section]) {
        print(sectionList)
        sectionArray = sectionList
        selectedSection = sectionArray.first!
        
        
        self.setupSection()
    }
    
    func addStudentAttendanceList() {
        
    }
    
    
    
    func failure(message: String) {
        displayServerError(withMessage: message)
    }
}
