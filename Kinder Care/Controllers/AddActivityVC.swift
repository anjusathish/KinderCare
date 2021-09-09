//
//  AddActivityVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 29/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import DropDown

class AddActivityVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var stepperView: UIView!
    
    @IBOutlet weak var tblActivities: UITableView!
    @IBOutlet weak var vwTop: UIView!
    
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    
    var activityType : ActivityType!
    var arrayAttachementImage:[URL] = []
    
    var isEdit:Bool = false
    
    var textviewDescription = "-"
    var textFieldStartTime = ""
    var chooseStartTime: Date?
    var textFieldEndTime = ""
    var diaperChange: Int = 1
    var getBathRoomList: [CategoryListDatum]?
    var selectedBathRoomTypeID: Int = 0
    var selectedBathRoomName: String = ""
     
    var imagePicker = UIImagePickerController()
    var selectedImage : UIImage?
    var sanitizer:Int!
    var temperature:String!
    var selectedDate:Date?
    var fromDate:String?
    lazy var viewModel : DailyActivityViewModel   =  {
        return DailyActivityViewModel()
    }()
    
    public var viewNapDailyActivityDetails:DailyActivityDetail?
    public var selectedStudentsArray : [Student] = []
    public var classID : Int?
    public var sectionID : Int?
    
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sanitizer = 1
        
        titleString = "ACTIVITY DETAIL"
        
        imagePicker.delegate = self
        
        tblActivities.tableFooterView = UIView()
        tblActivities.tableHeaderView = vwTop
        tblActivities.register(UINib(nibName: "AddBathroomCell", bundle: nil), forCellReuseIdentifier: "AddBathroomCell")
        tblActivities.register(UINib(nibName: "AddDescriptionCell", bundle: nil), forCellReuseIdentifier: "AddDescriptionCell")
        tblActivities.register(UINib(nibName: "AddNapActivityCell", bundle: nil), forCellReuseIdentifier: "AddNapActivityCell")
        tblActivities.register(UINib(nibName: "AddAttachmentCell", bundle: nil), forCellReuseIdentifier: "AddAttachmentCell")
        tblActivities.register(UINib(nibName: "ActivityTableCell", bundle: nil), forCellReuseIdentifier: "ActivityTableCell")
        
        viewModel.delegate = self
        viewModel.getActivityBathRoomList()
        
        
        if let _arrayAttachmentImage = viewNapDailyActivityDetails?.attachments?.map({$0.thumb}){
            
            for _attachmentImage in _arrayAttachmentImage {
                
                if let fileUrl = URL(string: _attachmentImage!){
                    arrayAttachementImage.append(fileUrl)
                    tblActivities.reloadData()
                }
            }
        }
    }
    
    
    //MARK:-:- Button Action
    @IBAction func cancelAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(sender: UIButton){
        
        switch activityType {
            
        case .bathRoom:
            
            if selectedBathRoomTypeID == 0 {
                self.displayServerError(withMessage: "Please Select BathRoomType")
            }
                
            else if textFieldStartTime.isEmpty {
                
                self.displayServerError(withMessage: "Please Select Start Time")
                
            }else if textviewDescription.isEmpty {
                
                self.displayServerError(withMessage: "Please Enter Description")
                
            }else{
                
                if let _bathRoomActivityDetails = viewNapDailyActivityDetails{
                    
                    let request = UpdateDailyActivityRequest(state: "1", type: "bathroom", class_id: classID!, section_id: sectionID!, start_time: textFieldStartTime, end_time: textFieldEndTime, description: textviewDescription, students: selectedStudentsArray.map({$0.id}), studentName: selectedStudentsArray.map({$0.studentName}), bathroom_type_id: selectedBathRoomTypeID, diaper_change: diaperChange,classroom_category_id: "",classroom_milestone_id: 0, title: "", attachments: arrayAttachementImage,date:fromDate ?? "")
                    
                    let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"BathroomDailyActivityVC") as! BathroomDailyActivityVC
                    vc.activityType = .bathRoom
                    vc.bathRoomType = selectedBathRoomName
                    vc.updateBathRoomRequest = request
                    vc.viewDailyActivityDetails = _bathRoomActivityDetails
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                let request = AddBathRoomActivityRequest(type: "bathroom", class_id: classID!, section_id: sectionID!, start_time: textFieldStartTime, end_time: textFieldEndTime, description: textviewDescription, bathroomTypeID: selectedBathRoomTypeID, disperChange: diaperChange, students: selectedStudentsArray.map({$0.id}), studentName: selectedStudentsArray.map({$0.studentName}),date:fromDate ?? "")
                
                let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"BathroomDailyActivityVC") as! BathroomDailyActivityVC
                vc.activityType = .bathRoom
                vc.bathRoomType = selectedBathRoomName
                vc.addBathRoomRequest = request
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case .incident:
            
            if textFieldStartTime.isEmpty {
                
                self.displayServerError(withMessage: "Please Select StartDate")
                
            }else if textFieldEndTime.isEmpty {
                
                self.displayServerError(withMessage: "Please Select EndDate")
                
            }
//            else if arrayAttachementImage.count == 0{
//                displayServerError(withMessage: "Please Add Attachement Photos")
//            }
            else if textviewDescription.isEmpty {
                
                self.displayServerError(withMessage: "Please Enter Description")
                
            }else{
                
                if let _medicineActivityDetails = viewNapDailyActivityDetails {
                    
                    let request = UpdateDailyActivityRequest(state: "1", type: "incident", class_id: classID!, section_id: sectionID!, start_time: textFieldStartTime, end_time: textFieldEndTime, description: textviewDescription, students: selectedStudentsArray.map({$0.id}), studentName: selectedStudentsArray.map({$0.studentName}), bathroom_type_id: 0, diaper_change: 0,classroom_category_id: "",classroom_milestone_id: 0, title: "", attachments: arrayAttachementImage,date:fromDate ?? "")
                    
                    
                    let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"IncidentDailyActivityVC") as! IncidentDailyActivityVC
                    vc.activityType = .incident
                    vc.updateIncidentRequest = request
                    vc.viewDailyActivityDetails = _medicineActivityDetails
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    
                    let request = AddIncidentActivityRequest(type: "incident", class_id: classID!, section_id: sectionID!, start_time: textFieldStartTime, end_time: textFieldEndTime, description: textviewDescription, students: selectedStudentsArray.map({$0.id}), attachments: arrayAttachementImage, studentName: selectedStudentsArray.map({$0.studentName}),date:fromDate ?? "")
                    
                    let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"IncidentDailyActivityVC") as! IncidentDailyActivityVC
                    vc.activityType = .incident
                    vc.addIncidentRequest = request
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                
            }
        case .nap:
            
            if textFieldStartTime.isEmpty {
                
                self.displayServerError(withMessage: "Please Select StartDate")
                
            }else if textFieldEndTime.isEmpty {
                
                self.displayServerError(withMessage: "Please Select EndDate")
                
            }
            //else if textviewDescription.isEmpty {
                
              //  self.displayServerError(withMessage: "Please Enter Description")
                //}
              else{
                
                if let _napActivityDetails = viewNapDailyActivityDetails{
                    
                    let request = UpdateDailyActivityRequest(state: "1", type: "nap", class_id: classID!, section_id: sectionID!, start_time: textFieldStartTime, end_time: textFieldEndTime, description: textviewDescription, students: selectedStudentsArray.map({$0.id}), studentName: selectedStudentsArray.map({$0.studentName}), bathroom_type_id: 0, diaper_change: 0,classroom_category_id: "",classroom_milestone_id: 0, title: "", attachments: arrayAttachementImage,date:fromDate ?? "")
                    
                    let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"NapActivityVC") as! NapActivityVC
                    vc.activityType = .nap
                    vc.updateNapActivityRequest = request
                    vc.viewDailyActivityDetails = _napActivityDetails
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    
                    let request = AddNapActivityRequest(type: "nap", class_id: classID!, section_id: sectionID!, start_time: textFieldStartTime, end_time: textFieldEndTime, description: textviewDescription, students: selectedStudentsArray.map({$0.id}), studentName: selectedStudentsArray.map({$0.studentName}),date: fromDate ?? "")
                    
                    let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"NapActivityVC") as! NapActivityVC
                    vc.activityType = .nap
                    vc.addNapRequest = request
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        case .classroom:
            let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"ClassRoomDailyActivityVC") as! ClassRoomDailyActivityVC
            vc.activityType = .classroom
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .medicine:
            
            if textFieldStartTime.isEmpty {
                
                self.displayServerError(withMessage: "Please Select StartTime")
                
            }
//            else if textFieldEndTime.isEmpty {
//
//                self.displayServerError(withMessage: "Please Select EndTime")
//
//            }
            else if textviewDescription.isEmpty {
                
                self.displayServerError(withMessage: "Please Enter Description")
                
            }
//            else if temperature!.isEmpty {
//                self.displayServerError(withMessage: "Please Enter Temperture")
//            }
            else{
                
                if let _medicineActivityDetails = viewNapDailyActivityDetails{
                    
                    let request = UpdateDailyActivityRequest(state: "1", type: "medicine", class_id: classID!, section_id: sectionID!, start_time: textFieldStartTime, end_time: textFieldEndTime, description: textviewDescription, students: selectedStudentsArray.map({$0.id}), studentName: selectedStudentsArray.map({$0.studentName}), bathroom_type_id: 0, diaper_change: 0,classroom_category_id: "",classroom_milestone_id: 0, title: "", attachments: arrayAttachementImage,date:fromDate ?? "")
                    
                    let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"MedicineDailyActivityVC") as! MedicineDailyActivityVC
                    vc.updateMediniceRequest = request
                    vc.activityType = .medicine
                    vc.viewDailyActivityDetails = _medicineActivityDetails
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else if temperature == "" {
                    
                    displayServerSuccess(withMessage: "Please Enter Temperture")
                }
                else {
                    if let sanitizerData = sanitizer,let tempertureData = temperature {
                        
                    
                        let request = AddMedicineActivityRequest(type: "medicine", class_id: classID!, section_id: sectionID!, start_time: textFieldStartTime, end_time: "00:00", description: textviewDescription, students: selectedStudentsArray.map({$0.id}), studentName: selectedStudentsArray.map({$0.studentName}),sanitizer:sanitizerData,temperature:tempertureData,date: fromDate ?? "")
                    
                    let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"MedicineDailyActivityVC") as! MedicineDailyActivityVC
                    vc.addMediniceRequest = request
                    vc.activityType = .medicine
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    }else
                    {
                        displayServerSuccess(withMessage: "Please Enter Temperture")
                    }
                    
            }}
            
        case .photo,.video,.meal:
            
            break
            
        default : break
        }
        
    }
    
    func showDropDown(sender : UITextField, content : [String]) {
        
        let dropDown = DropDown()
        dropDown.direction = .any
        dropDown.anchorView = sender
        dropDown.dismissMode = .automatic
        dropDown.dataSource = content
        
        dropDown.selectionAction = { (index: Int, item: String) in
            sender.text = item
            if let _bathRoomID = self.getBathRoomList?[index].id,let bathRoomName = self.getBathRoomList?[index].name {
                
                self.selectedBathRoomTypeID = _bathRoomID
                self.selectedBathRoomName = bathRoomName
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
    
    
    @objc func handleUploadAttachement(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func buttonPressYes(_ sender: UIButton){
        diaperChange = 1
        tblActivities.reloadData()
    }
    
    @objc func buttonPressNo(_ sender: UIButton){
        diaperChange = 0
        tblActivities.reloadData()
    }
    
    //MARK:- Open Camera
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }else{
            
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- Open Gallary
    func openGallary(){
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if (picker.sourceType == UIImagePickerController.SourceType.camera) {
            
            if let image = info[.originalImage] as? UIImage {
                
                selectedImage = image
            }
            
            let imgName = UUID().uuidString
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName)
            
            let data = selectedImage!.jpegData(compressionQuality: 0.3)! as NSData
            data.write(toFile: localPath, atomically: true)
            let photoURL = URL.init(fileURLWithPath: localPath)
            arrayAttachementImage.append(photoURL)
            tblActivities.reloadData()
            
        }else{
            
            if let pickedImage = info[.imageURL] as? URL {
                arrayAttachementImage.append(pickedImage)
                tblActivities.reloadData()
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
        tblActivities.reloadData()
        
    }
}

extension AddActivityVC{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if activityType == ActivityType.incident {
            return 3
        }else{
            return 2
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            switch  activityType {
                
            case .meal:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommonActivityCell", for: indexPath) as! AddCommonActivityCell
                cell.dateView.isHidden = false
                return cell
                
            case .nap:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNapActivityCell", for: indexPath) as! AddNapActivityCell
                cell.selectionStyle = .none
                cell.txtStartTime.delegate = self
                cell.txtEndTime.delegate = self
                cell.txtEndTime.tag = 1
                cell.txtStartTime.tag = 0
                cell.txtDate.tag = 4
                cell.txtDate.delegate = self
                if let _napActivityDetails = viewNapDailyActivityDetails{
                    
                    cell.txtStartTime.text = _napActivityDetails.startTime
                    cell.txtEndTime.text = _napActivityDetails.endTime
                    textFieldStartTime = _napActivityDetails.startTime ?? ""
                    textFieldEndTime  = _napActivityDetails.endTime ?? ""
                    textviewDescription = _napActivityDetails.dataDescription
                }
                
                return cell
                
            case .classroom:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNapActivityCell", for: indexPath) as! AddNapActivityCell
                cell.lblName.text = "\(activityType!.rawValue) Activity"
                cell.selectionStyle = .none
                return cell
                
            case .incident:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNapActivityCell", for: indexPath) as! AddNapActivityCell
                cell.lblName.text = "\(activityType!.rawValue) Activity"
                cell.txtEndTime.isHidden = true
                cell.lblEndTime.isHidden = true
                cell.lblTime.text = "Time"
                cell.selectionStyle = .none
                cell.txtStartTime.delegate = self
                cell.txtEndTime.delegate = self
                cell.txtDate.delegate = self
                cell.txtEndTime.tag = 1
                cell.txtStartTime.tag = 0
                cell.txtStartTime.tag = 0
                cell.txtDate.tag = 4
                textFieldEndTime = "00:00"
                if let _incidentActivityDetails = viewNapDailyActivityDetails{
                    
                    cell.txtStartTime.text = _incidentActivityDetails.startTime
                    cell.txtEndTime.text = _incidentActivityDetails.endTime
                    textFieldStartTime = _incidentActivityDetails.startTime ?? ""
                    textFieldEndTime  = _incidentActivityDetails.endTime ?? ""
                    textviewDescription = _incidentActivityDetails.dataDescription
                }
                
                
                return cell
                
            case .medicine:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNapActivityCell", for: indexPath) as! AddNapActivityCell
                cell.lblName.text = "\(activityType!.rawValue) Activity"
                cell.lblTime.text = "Time"
                cell.lblEndTime.isHidden = true
                cell.txtEndTime.isHidden = true
                
                cell.txtStartTime.tag = 0
                cell.txtDate.tag = 4
                cell.txtDate.delegate = self
                cell.txtStartTime.delegate = self
                cell.txtEndTime.delegate = self
                cell.txtEndTime.tag = 1
                cell.txtStartTime.tag = 0
                cell.selectionStyle = .none
                cell.lblSanitizer.isHidden = false
                cell.lblTemperture.isHidden = false
                cell.btnNo.isHidden = false
                cell.btnYes.isHidden = false
                cell.btnNo.tag = 0
                cell.btnYes.tag = 1
                cell.txtTemperature.isHidden = false
                temperature =  cell.txtTemperature.text
                cell.txtTemperature.delegate = self
                cell.btnYes.addTarget(self, action: #selector(self.yesBtn), for: .touchUpInside)
                cell.btnNo.addTarget(self, action: #selector(self.noBtn), for: .touchUpInside)
                
                if let _medicineActivityDetails = viewNapDailyActivityDetails{
                    
                    cell.txtStartTime.text = _medicineActivityDetails.startTime
                    cell.txtEndTime.text = _medicineActivityDetails.endTime
                    textFieldStartTime = _medicineActivityDetails.startTime ?? ""
                    textFieldEndTime  = _medicineActivityDetails.endTime ?? ""
                    textviewDescription = _medicineActivityDetails.dataDescription
                }
                if sanitizer == 0{
                    
                         
                         cell.btnYes.setImage(UIImage(named: "unSelectFilter"), for: .normal)
                         cell.btnNo.setImage(UIImage(named: "selectFilter"), for: .normal)
                }
                else{
                    
                    cell.btnNo.setImage(UIImage(named: "unSelectFilter"), for: .normal)
                    cell.btnYes.setImage(UIImage(named: "selectFilter"), for: .normal)
                    
                }
                
                
                return cell
                
            case .bathRoom:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddBathroomCell", for: indexPath) as! AddBathroomCell
                cell.selectionStyle = .none
                cell.txtStartTime.delegate = self
                cell.txtStartTime.tag = 0
                cell.txtEndTime.delegate = self
                cell.txtEndTime.tag = 1
                cell.txtType.delegate = self
                cell.txtType.tag = 2
                cell.dateTxtFld.delegate = self
                cell.dateTxtFld.tag = 4
                cell.buttonNo.addTarget(self, action: #selector(buttonPressNo(_:)), for: .touchUpInside)
                cell.buttonYes.addTarget(self, action: #selector(buttonPressYes(_:)), for: .touchUpInside)
                
                if let _bathRoomActivityDetails = viewNapDailyActivityDetails{
                    
                    cell.txtStartTime.text = _bathRoomActivityDetails.startTime
                    cell.txtEndTime.text = _bathRoomActivityDetails.endTime
                    cell.txtType.text = _bathRoomActivityDetails.bathroomTypeName
                    diaperChange = _bathRoomActivityDetails.diaperChange!
                    selectedBathRoomTypeID = _bathRoomActivityDetails.bathroomTypeID!
                    selectedBathRoomName = _bathRoomActivityDetails.bathroomTypeName!
                    
                    textFieldStartTime = _bathRoomActivityDetails.startTime ?? ""
                    textFieldEndTime  = _bathRoomActivityDetails.endTime ?? ""
                    textviewDescription = _bathRoomActivityDetails.dataDescription
                }
                
                if diaperChange == 1 {
                    cell.buttonYes.setImage(UIImage(named: "selectFilter"), for: .normal)
                    cell.buttonNo.setImage(UIImage(named: "unSelectFilter"), for: .normal)
                }else{
                    cell.buttonYes.setImage(UIImage(named: "unSelectFilter"), for: .normal)
                    cell.buttonNo.setImage(UIImage(named: "selectFilter"), for: .normal)
                }
                
                
                
                return cell
                
            default :
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddNapActivityCell", for: indexPath) as! AddNapActivityCell
                cell.selectionStyle = .none
                return cell
            }
        case 1 :
            switch activityType {
                
            case .incident:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableCell") as! ActivityTableCell
                cell.collActivity.delegate = self
                cell.collActivity.dataSource = self
                cell.lblActivity.isHidden = true
                cell.collActivity.reloadData()
                
                
                if arrayAttachementImage.count == 0{
                    cell.emptyLabel.isHidden = false
                }else{
                    cell.emptyLabel.isHidden = true
                }
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleUploadAttachement(_:)))
                cell.viewAddMoreImage.addGestureRecognizer(tap)
                
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddDescriptionCell", for: indexPath) as! AddDescriptionCell
                cell.selectionStyle = .none
                cell.txtViewDescription.delegate = self
                if let _napActivityDetails = viewNapDailyActivityDetails{
                    cell.txtViewDescription.text = _napActivityDetails.dataDescription
                }
                return cell
            }
            
        case 2 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddDescriptionCell", for: indexPath) as! AddDescriptionCell
            cell.selectionStyle = .none
            cell.txtViewDescription.delegate = self
            
            if let _napActivityDetails = viewNapDailyActivityDetails{
                cell.txtViewDescription.text = _napActivityDetails.dataDescription
            }
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //    if indexPath.row == 0{
        //      return UITableView.automaticDimension
        //    }else{
        //      return UITableView.automaticDimension
        //    }
        
        if indexPath.section == 1 {
            switch  activityType {
                
            case .incident: return 100
            default: return UITableView.automaticDimension
                
            }
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    
    //  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //    return tableView.frame.size.height/2 + 10
    //  }
    
    @objc func yesBtn(_ sender: UIButton) {
        sanitizer = 1
        tblActivities.reloadData()
    }
    
    @objc func noBtn(_ sender: UIButton) {
        sanitizer = 0
        tblActivities.reloadData()
    }
}


extension AddActivityVC: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        temperature = textField.text
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 0 {
            
            let vc = UIStoryboard.attendanceStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
            vc.mode = .time
            vc.dismissBlock = { dataObj in
                
                self.chooseStartTime = dataObj
                textField.text = dataObj.getasString(inFormat: "hh:mm a")
                self.textFieldStartTime = dataObj.getasString(inFormat: "HH:mm")
            }
            
            present(controllerInSelf: vc)
            
        }else if textField.tag == 1{
            
            
            let vc = UIStoryboard.attendanceStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
            
            vc.mode = .time
            vc.minimumDate = chooseStartTime?.addingTimeInterval(60)
            textFieldEndTime = textField.text!
            vc.dismissBlock = { dataObj in
                textField.text = dataObj.getasString(inFormat: "hh:mm a")
                self.textFieldEndTime = dataObj.getasString(inFormat: "HH:mm")
            }
            present(controllerInSelf: vc)
            
        }
        else if textField.tag == 4 {
            let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
   
            picker.dismissBlock = { date in
                self.selectedDate = date
                //self.fromDateSelected = date
                textField.text = date.asString(withFormat: "dd-MM-yyyy")
                self.fromDate = date.asString(withFormat: "yyyy-MM-dd")
                
            }
            return false
            
        }
        
        else if textField.tag == 2 {
            
            if let bathRoomNameList = getBathRoomList?.map({$0.name}){
                
                showDropDown(sender: textField, content: bathRoomNameList)
                
            }
        }
        else{
            return true
        }
        
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.tag == 5 {
            temperature = textField.text
        }
       
    }
}

extension AddActivityVC: UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textviewDescription = textView.text
        
        
    }
    
    
}

extension AddActivityVC: DailyActivityDelegate{
    func activityUpdateSuccess(activity: EditPhotoActivityEmptyResponse) {
        
    }
    func bathRoomList(at bathRoomList: [CategoryListDatum]) {
        
        getBathRoomList = bathRoomList
    }
    
    
    func getListDailyActivity(at dailyActivityList: [DailyActivity]) {
        
    }
    
    func viewDailyActivitySuccessfull(dailyActivityDetails: DailyActivityDetail) {
        
    }
    
    func editPhotEditActivityResponse(at editActivityResponse: EditPhotoActivityEmptyResponse) {
        
    }
    
    func addDailyActivityPhotoResponse(at editActivityResponse: AddDailyAtivityPhotoResponse) {
        
    }
    
    func failure(message: String) {
        
    }
    
    func classRoomCategoryList(at CategoryList: [CategoryListDatum]) {
        
    }
    
    func classRoomMilestoneList(at CategoryList: [CategoryListDatum]) {
        
    }
    
    
}

//MARK:- UICollectionViewDataSource,UICollectionViewDelegate Methodes

extension AddActivityVC: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return arrayAttachementImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityImageCell", for: indexPath) as! ActivityImageCell
        
        cell.vwAddImage.isHidden = true
        cell.vwCancelCanecl.isHidden = false
        
        cell.imgVideo.sd_setImage(with: arrayAttachementImage[indexPath.row])
        
        cell.btnCancel.addTarget(self, action: #selector(removeSelectedImage(_:)), for: .touchUpInside)
        cell.btnCancel.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func removeSelectedImage(_ sender: UIButton){
        
        arrayAttachementImage.remove(at: sender.tag)
        tblActivities.reloadData()
    }
    
    
}
//MARK:- Collection View FlowLayout
extension AddActivityVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let dimension:CGFloat = collectionView.frame.size.width / 2
        return CGSize(width: dimension, height: collectionView.frame.size.height)
        
    }
}
