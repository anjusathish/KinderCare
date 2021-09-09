//
//  AddClassRoomVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 02/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import DropDown

class AddClassRoomVC: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
  lazy var viewModel : DailyActivityViewModel   =  {
    return DailyActivityViewModel()
  }()
  
  let dispatchGroup = DispatchGroup()
  let window = UIApplication.shared.windows.first
  
  @IBOutlet weak var textFieldTitle: CTTextField!
  @IBOutlet weak var textFieldCategory: CTTextField!
  @IBOutlet weak var textFieldMilestone: CTTextField!
  
  @IBOutlet weak var textfieldStartTime: CTTextField!
  @IBOutlet weak var textfieldEndTime: CTTextField!
  @IBOutlet weak var buttonAddAttachment: UIButton!
  @IBOutlet weak var textViewDescription: UITextView!
    
    @IBOutlet weak var dateTxtFld: CTTextField!
    
  @IBOutlet weak var tableviewAttachementImage: UITableView!{
    didSet{
      tableviewAttachementImage.register(UINib(nibName: "ActivityTableCell", bundle: nil), forCellReuseIdentifier: "ActivityTableCell")
    }
  }
  
  var startTime: String = ""
  var endTime: String = ""
  var arrayAttachementImage:[URL] = []
   var chooseStartTime: Date?
  var arrayCategoryList: [CategoryListDatum]?
  var arrayMilestoneList: [CategoryListDatum]?
  var catgoryID: Int?
  var milestonID: Int?
  var catgoryName: String = ""
  var milestonName: String = ""
  var addClassRoomActivityRequest: AddClassRoomActivityRequest?
  var fromDate:String?
  var imagePicker = UIImagePickerController()
  var selectedImage : UIImage?
  var selectedDate:Date?
  public var selectedStudentsArray : [Student] = []
  public var classID : Int?
  public var sectionID : Int?
  
  //MARK:- ViewController LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    titleString = "Activity Detail"
    viewModel.delegate = self
    imagePicker.delegate = self
    callAPI()
  }
  
  func callAPI(){
    
    dispatchGroup.enter()
    viewModel.getClassRoomCategoryList()
    
    dispatchGroup.enter()
    viewModel.getClassroomMilestoneList()
    
    dispatchGroup.notify(queue: .main) {
      MBProgressHUD.hide(for: self.window!, animated: true)
    }
    
  }
  
  //MARK:- Button Action
  @IBAction func nextAction( _sender: UIButton){
    
    if textFieldTitle.text!.isEmpty{
      
      self.displayServerError(withMessage: "Please Enter Title")
      
    }
    
//    else if catgoryID == nil{
//      self.displayServerError(withMessage: "Please Select Category")
//
//    }
        
    else if textViewDescription.text.isEmpty{
      
      self.displayServerError(withMessage: "Please Enter Description")
      
    }
        
    else if textFieldMilestone.text!.isEmpty {

      self.displayServerError(withMessage: "Please Enter Milestone")

    }
    else if startTime.isEmpty{
      
      self.displayServerError(withMessage: "Please Select StartTime")
      
    }else if endTime.isEmpty{
      
      self.displayServerError(withMessage: "Please Select EndTime")
      
    }
        
//    else if arrayAttachementImage.count == 0{
//
//      self.displayServerError(withMessage: "Please Select Atleast one Attachement Image")
//
//    }
        
    else{
        if arrayAttachementImage.count == 0 {
           // let url = URL(string: "https://via.placeholder.com/300/09f/fff.png")
            
            let reqest = AddClassRoomActivityRequest(type: "classroom", class_id: classID!, section_id: sectionID!, start_time: startTime, end_time: endTime, description: textViewDescription.text, students: selectedStudentsArray.map({$0.id}), attachments: arrayAttachementImage, classroom_category_id: self.textFieldCategory.text ?? "", classroom_milestone_id: textFieldMilestone.text ?? "", title: textFieldTitle.text!,classroomCategoryName: catgoryName,classroomMilestoneName: milestonName, studentName: selectedStudentsArray.map({$0.studentName}),date: fromDate ?? "")

            let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"ClassRoomDailyActivityVC") as! ClassRoomDailyActivityVC
            vc.activityType = ActivityType.classroom
            vc.addClassRoomRequest = reqest
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
        let reqest = AddClassRoomActivityRequest(type: "classroom", class_id: classID!, section_id: sectionID!, start_time: startTime, end_time: endTime, description: textViewDescription.text, students: selectedStudentsArray.map({$0.id}), attachments: arrayAttachementImage, classroom_category_id: self.textFieldCategory.text ?? "", classroom_milestone_id: textFieldMilestone.text ?? "", title: textFieldTitle.text!,classroomCategoryName: catgoryName,classroomMilestoneName: milestonName, studentName: selectedStudentsArray.map({$0.studentName}),date: fromDate ?? "")

            let vc = UIStoryboard.DailyActivityStoryboard().instantiateViewController(withIdentifier:"ClassRoomDailyActivityVC") as! ClassRoomDailyActivityVC
            vc.activityType = ActivityType.classroom
            vc.addClassRoomRequest = reqest
            self.navigationController?.pushViewController(vc, animated: true)
        }
      
     
      
      
      
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
      tableviewAttachementImage.reloadData()
      
    }else{
      
      if let pickedImage = info[.imageURL] as? URL {
        arrayAttachementImage.append(pickedImage)
        tableviewAttachementImage.reloadData()
      }
    }
    picker.dismiss(animated: true, completion: nil)
    
    
  }
  
  
  @IBAction func cancelAction( _sender: UIButton){
    self.navigationController?.popViewController(animated: true)
  }
  
  func showDropDown(sender : UITextField, content : [String]) {
    
    let dropDown = DropDown()
    dropDown.direction = .any
    dropDown.anchorView = sender
    dropDown.dismissMode = .automatic
    dropDown.dataSource = content
    
    dropDown.selectionAction = { (index: Int, item: String) in
      
      sender.text = item
      
      if sender == self.textFieldCategory {
        
        if let _catgoryID = self.arrayCategoryList?[index].id,let _catgoryName = self.arrayCategoryList?[index].name{
          self.catgoryID = _catgoryID
          self.catgoryName = _catgoryName
        }
        
      }else{
        
        if let _milestonID = self.arrayMilestoneList?[index].id, let _milestonName = self.arrayMilestoneList?[index].name{
          self.milestonID = _milestonID
          self.milestonName = _milestonName
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
  
  @objc func removeSelectedImage(_ sender: UIButton){
    
    arrayAttachementImage.remove(at: sender.tag)
    tableviewAttachementImage.reloadData()
  }
}

//MARK:- UITextFieldDelegate Methodes
extension AddClassRoomVC: UITextFieldDelegate{
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    if textField == textFieldCategory{
      
      if let _arrayCategoryList = arrayCategoryList?.map({$0.name}){
        
        showDropDown(sender: textField, content: _arrayCategoryList)
      }
      return false
      
    }
//    else if textField == textFieldMilestone{
//
//      if let _arrayMilestoneList = arrayMilestoneList?.map({$0.name}){
//
//        showDropDown(sender: textField, content: _arrayMilestoneList)
//      }
//      return false
//
//    }
    else if textField == textfieldStartTime{
      
      let vc = UIStoryboard.attendanceStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
      
      vc.mode = .time
      
      vc.dismissBlock = { dataObj in
        self.chooseStartTime = dataObj
        textField.text = dataObj.getasString(inFormat: "hh:mm a")
        self.startTime = dataObj.getasString(inFormat: "HH:mm")
      }
      present(controllerInSelf: vc)
      return false
      
    }else if textField == textfieldEndTime{
      
      let vc = UIStoryboard.attendanceStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
      
      vc.mode = .time
          vc.minimumDate = chooseStartTime?.addingTimeInterval(60)
      
      vc.dismissBlock = { dataObj in
        textField.text = dataObj.getasString(inFormat: "hh:mm a")
        self.endTime = dataObj.getasString(inFormat: "HH:mm")
        }
        present(controllerInSelf: vc)
        return false
    }
        
    else if textField == dateTxtFld{
        let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
        
        picker.dismissBlock = { date in
            self.selectedDate = date
            //self.fromDateSelected = date
            textField.text = date.asString(withFormat: "dd-MM-yyyy")
            self.fromDate = date.asString(withFormat: "yyyy-MM-dd")
            
        }
        return false
        
    }
    
    return true
  }
}

extension AddClassRoomVC: DailyActivityDelegate{
    func activityUpdateSuccess(activity: EditPhotoActivityEmptyResponse) {
        
    }
  func bathRoomList(at bathRoomList: [CategoryListDatum]) {
  }
  
  func classRoomMilestoneList(at CategoryList: [CategoryListDatum]) {
    dispatchGroup.leave()
    arrayMilestoneList = CategoryList
  }
  
  func getListDailyActivity(at dailyActivityList: [DailyActivity]) {
    
  }
  
  func viewDailyActivitySuccessfull(dailyActivityDetails: DailyActivityDetail) {
    
  }
  
  func editPhotEditActivityResponse(at editActivityResponse: EditPhotoActivityEmptyResponse) {
    
  }
  
  func addDailyActivityPhotoResponse(at editActivityResponse: AddDailyAtivityPhotoResponse) {
    
  }
  
  func classRoomCategoryList(at CategoryList: [CategoryListDatum]) {
    dispatchGroup.leave()
    arrayCategoryList = CategoryList
  }
  func failure(message: String) {
    
  }
}

//MARK:- UITableViewDataSource,UITableViewDelegate Methodes

extension AddClassRoomVC: UITableViewDataSource,UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableCell") as! ActivityTableCell
    cell.collActivity.delegate = self
    cell.collActivity.dataSource = self
    cell.lblActivity.isHidden = true
    cell.collActivity.reloadData()
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleUploadAttachement(_:)))
    cell.viewAddMoreImage.addGestureRecognizer(tap)
    
    if arrayAttachementImage.count == 0{
      cell.emptyLabel.isHidden = false
    }else{
      cell.emptyLabel.isHidden = true
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.frame.size.height/2 + 10
  }
  
}

//MARK:- UICollectionViewDataSource,UICollectionViewDelegate Methodes

extension AddClassRoomVC: UICollectionViewDataSource,UICollectionViewDelegate {
  
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
  
//  @objc func removeSelectedImage(_ sender: UIButton){
//
//    arrayAttachementImage.remove(at: sender.tag)
//    tableviewAttachementImage.reloadData()
//  }
  
  
}
//MARK:- Collection View FlowLayout
extension AddClassRoomVC: UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    
    let dimension:CGFloat = collectionView.frame.size.width / 2
    return CGSize(width: dimension, height: collectionView.frame.size.height)
    
  }
}
