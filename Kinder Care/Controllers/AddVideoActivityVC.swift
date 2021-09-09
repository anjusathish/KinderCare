//
//  AddMealActivityVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 28/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import AVFoundation

class AddVideoActivityVC: BaseViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
  @IBOutlet weak var tblActivities: UITableView!{
    didSet{
      
      tblActivities.register(UINib(nibName: "ActivityTableCell", bundle: nil), forCellReuseIdentifier: "ActivityTableCell")
      tblActivities.register(UINib(nibName: "AddCommonActivityCell", bundle: nil), forCellReuseIdentifier: "AddCommonActivityCell")
      tblActivities.register(UINib(nibName: "AddDescriptionCell", bundle: nil), forCellReuseIdentifier: "AddDescriptionCell")
    }
  }
  
  @IBOutlet weak var vwTop: UIView!
  
  var imagePicker = UIImagePickerController()
  var selectedImage : UIImage?
  
  var activityDetail:DailyActivityDetail?
  
  var arrIndexpath = [IndexPath]()
  
  var selectedUsers:[MessageUserData] = []
  var fromDate:String?
  lazy var viewModel : DailyActivityViewModel   =  {
    
    return DailyActivityViewModel()
    
  }()
  
  var arrayAttachementImage:[URL] = []
  
  public var activityType = ""
  var selectedDate:Date?
  var textviewDescription = ""
  var selectedClassID : Int?
  var selectedSectionID : Int?
  private var selectedClassModel: ClassModel?
  private var selectedSectionModel: Section?
  
  public var selectedStudentsArray : [Student] = []
  
  
  
  //MARK:- ViewController lifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if activityType == "photo" {
      
      titleString = "Activity Photos"
      
    }else{
      titleString = "Activity Videos"
    }
    
    tblActivities.tableFooterView = UIView()
    
    viewModel.delegate = self
    imagePicker.delegate = self
    
    if let _arrayAttachmentImage = activityDetail?.attachments?.map({$0.thumb}){
      
      for _attachmentImage in _arrayAttachmentImage {
        
        if let fileUrl = URL(string: _attachmentImage!){
          arrayAttachementImage.append(fileUrl)
        }
      }
    }
  }
  
  //MARK:-:- Button Action
  @IBAction func cancelAction(sender: UIButton){
    
    self.navigationController?.popViewController(animated: true)
    
  }
  
  @IBAction func send(sender: UIButton){
    
    if let photoDailyActiviyDetails = activityDetail{
      
      viewModel.updatePhotoDailyActivity(state: "1", type: photoDailyActiviyDetails.type, classID: photoDailyActiviyDetails.classID, sectionID: photoDailyActiviyDetails.sectionID, description: photoDailyActiviyDetails.dataDescription, studentID: selectedStudentsArray.map({$0.id}), attachmet: arrayAttachementImage, activity_id: photoDailyActiviyDetails.id)
      
    }else{
      // selectedUsers.map({$0.id})
      
      if arrayAttachementImage.count > 0 {
        
        guard let _classID = selectedClassID, let _sectionID = selectedSectionID else {
          return displayError(withMessage: .selectClassAndSection)
        }
        
        if textviewDescription.isEmpty{
          
          displayServerError(withMessage: "Please Enter description")
          
        }
        else if selectedStudentsArray.count == 0{
          
          displayServerError(withMessage: "Please Select Students")
          
        }
        else if fromDate!.isEmpty{
          displayServerError(withMessage: "Please Select Date")
        }
        else{
          
          viewModel.addDailyActivity(type:activityType , classID: _classID, sectionID: _sectionID, description: textviewDescription, studentID: selectedStudentsArray.map({$0.id}) , attachmet: arrayAttachementImage, date: fromDate ?? "")
        }
        
      }else{
        displayServerError(withMessage: "Please Add Attachement Videos")
      }
    }
  }
  
  
  @objc func removeSelectedImage(_ sender: UIButton){
    
    if let index = activityDetail?.attachments!.firstIndex(where: {$0.file == activityDetail?.attachments![sender.tag].file}){
      
      activityDetail?.attachments?.remove(at: index)
      
    }else{
      arrayAttachementImage.remove(at: sender.tag)
    }
    
    tblActivities.reloadData()
  }
  
  //MARK:- Choose Image
  @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
    
    if activityType == "photo" {
      
      let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
      
      alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
        self.openCamera()
      }))
      
      alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
        self.openGallary()
      }))
      
      alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
      
      self.present(alert, animated: true, completion: nil)
      
    }else{
      
      imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
      imagePicker.allowsEditing = true
      imagePicker.mediaTypes = ["public.movie"]
      self.present(imagePicker, animated: true, completion: nil)
      
    }
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
    
    if activityType == "photo" {
      
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
      self.dismiss(animated: true, completion: nil)
      
    }else{
      
      var videoData:Data!
      guard let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
      print(mediaURL)
      
      let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mp4")
      
      compressVideo(inputURL: mediaURL , outputURL: compressedURL) { (exportSession) in
        guard let session = exportSession else {
          return
        }
        switch session.status {
        case .unknown: break
        case .waiting: break
        case .exporting: break
        case .completed:
          
          DispatchQueue.main.async {
            let filePath  =  compressedURL.relativePath
            let fileUrl = URL(fileURLWithPath: filePath)
            self.arrayAttachementImage.append(fileUrl)
            print(self.arrayAttachementImage)
            self.tblActivities.reloadData()
          }
          
          
        case .failed: break
        case .cancelled: break
        @unknown default: break
          
        }
      }
      self.dismiss(animated: true, completion: nil)
    }
    
    self.dismiss(animated: true, completion: nil)
    
  }
  
  func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
    let urlAsset = AVURLAsset(url: inputURL, options: nil)
    guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetLowQuality) else {
      handler(nil)
      
      return
    }
    
    exportSession.outputURL = outputURL
    exportSession.outputFileType = AVFileType.mp4
    exportSession.shouldOptimizeForNetworkUse = true
    exportSession.exportAsynchronously { () -> Void in
      handler(exportSession)
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.dismiss(animated: true, completion: {
    })
  }
  
}

extension AddVideoActivityVC{
  
  @objc func selectStudent(sender: UIButton){
    
    guard let _classID = selectedClassID, let _sectionID = selectedSectionID else {
      return displayError(withMessage: .selectClassAndSection)
    }
    
    let story = UIStoryboard(name: "AddActivity", bundle: nil)
    let studentListVC = story.instantiateViewController(withIdentifier: "StudentListVC") as! StudentListVC // abdul
    studentListVC.delegate = self
    studentListVC.userTypeArray = [.student]
    studentListVC.classID = _classID
    studentListVC.sectionID = _sectionID
    if let schoolID = UserManager.shared.currentUser?.school_id {
      studentListVC.schoolID = schoolID
      
    }
    
    studentListVC.selectedStudentsArray = selectedStudentsArray
    studentListVC.modalPresentationStyle = .overCurrentContext
    self.navigationController?.present(studentListVC, animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == 0{
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommonActivityCell", for: indexPath) as! AddCommonActivityCell
      cell.dateView.isHidden = false
      cell.dateTxtFld.delegate = self
      cell.dateTxtFld.tag = 4
      cell.btnSelectStudent.addTarget(self, action: #selector(selectStudent), for: .touchUpInside)
      cell.activityPhotoDetails = activityDetail
      
      if let photoActivityDetails = activityDetail{
        cell.txtClass.text = photoActivityDetails.className
        cell.txtSection.text = photoActivityDetails.classSection
        
      }else{
        
        cell.txtClass.text = selectedClassModel?.className
        cell.txtSection.text = selectedSectionModel?.section
      }
      
      
      
      cell.lblActivityName.text = activityType + " Activity"
      //cell.delegate = self
      
      //cell.selectedUsers = selectedUsers.filter({$0.detail.lowercased().contains("-\(UserType.student.stringValue.lowercased())")}).map({$0.detail.replacingOccurrences(of: "-\(UserType.student.stringValue.lowercased())", with: "")})
      
      cell.collStudent.reloadData()
      
      cell.delegate = self
      cell.selectedUsers = selectedStudentsArray.map({$0.studentName})
      
      return cell
      
    }else{
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "AddDescriptionCell", for: indexPath) as! AddDescriptionCell
      cell.txtViewDescription.text = activityDetail?.dataDescription
      cell.txtViewDescription.tag = indexPath.row
      cell.txtViewDescription.delegate = self
      return cell
      
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView:ActivityTableCell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableCell") as! ActivityTableCell
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    headerView.viewAddMoreImage.addGestureRecognizer(tap)
    
    if arrayAttachementImage.count == 0{
      headerView.emptyLabel.isHidden = false
      headerView.emptyLabel.text = "Please Add " + activityType
      headerView.rightAddData.text =  "Please Add " + activityType
      
    }else{
      headerView.emptyLabel.isHidden = true
      headerView.emptyLabel.text = "Please Add " + activityType
      headerView.rightAddData.text =  "Please Add " + activityType
    }
    
    headerView.collActivity.delegate = self
    headerView.collActivity.dataSource = self
    headerView.lblActivity.isHidden = true
    return headerView
  }
  
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
    return tableView.frame.size.height/5 + 10
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0{
      return 250//UITableView.automaticDimension
    }else{
      return UITableView.automaticDimension
    }
  }
  
  @objc func addNewField(sender: UIButton){
    
    let position = sender.convert(CGPoint.zero, to: tblActivities)
    guard let index = self.tblActivities.indexPathForRow(at: position) else { return
    }
    arrIndexpath.append(index)
    tblActivities.reloadData()
  }
  
  @objc func removeField(sender: UIButton){
    let position = sender.convert(CGPoint.zero, to: tblActivities)
    let index = self.tblActivities.indexPathForRow(at: position)
    arrIndexpath.remove(at: index!.row)
    tblActivities.reloadData()
  }
}
extension AddVideoActivityVC:UITextFieldDelegate{
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    if textField.tag == 4 {
      let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
      
      picker.dismissBlock = { date in
        self.selectedDate = date
        textField.text = date.asString(withFormat: "dd-MM-yyyy")
        self.fromDate = date.asString(withFormat: "yyyy-MM-dd")
        
      }
      return false
      
    }
    return true
    
  }
}

//MARK:- UICollectionViewDataSource,UICollectionViewDelegate Methodes

extension AddVideoActivityVC: UICollectionViewDataSource,UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    
    //    if arrayAttachementImage.count == 0{
    //      //var emptyLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
    //      let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
    //      emptyLabel.text = "No Data"
    //      emptyLabel.textAlignment = NSTextAlignment.center
    //      self.tblActivities.backgroundView = emptyLabel
    //      self.tblActivities.separatorStyle = UITableViewCell.SeparatorStyle.none
    //      return 0
    //    } else {
    //      return arrayAttachementImage.count
    //    }
    
    
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
  
}

//MARK:- Collection View FlowLayout
extension AddVideoActivityVC: UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    
    let dimension:CGFloat = collectionView.frame.size.width / 2
    return CGSize(width: dimension, height: collectionView.frame.size.height)
    
  }
}

//MARK:- SelectedStudents Delegate Methodes

extension AddVideoActivityVC: sendSelectedEmailDelegate{
  
  func selectedTeachers(students: [TeacherListData], users: [MessageUserData]) {
    
  }
  
    func classNameList(classData: [ClassModel], classId: Int) {
        
    }
    
  func selectedStudents(students: [Student], users: [MessageUserData]) {
    selectedStudentsArray = students
    tblActivities.reloadData()
  }
 
  
  func selectedUsers(users: [MessageUserData]){
    
    selectedUsers.append(contentsOf: users)
    tblActivities.reloadData()
  }
}

//MARK:- DailyActivity Delegate Methodes

extension AddVideoActivityVC: DailyActivityDelegate{
  func activityUpdateSuccess(activity: EditPhotoActivityEmptyResponse) {
    
  }
  func bathRoomList(at bathRoomList: [CategoryListDatum]) {
    
  }
  
  
  func classRoomMilestoneList(at CategoryList: [CategoryListDatum]) {
    
  }
  
  func classRoomCategoryList(at CategoryList: [CategoryListDatum]) {
    
  }
  
  func addDailyActivityPhotoResponse(at editActivityResponse: AddDailyAtivityPhotoResponse) {
    
    self.displayServerError(withMessage: "The Media Activity is Added Succesfully")
    self.navigationController?.popViewController(animated: true)
    
  }
  
  func getListDailyActivity(at dailyActivityList: [DailyActivity]){
  }
  
  func viewDailyActivitySuccessfull(dailyActivityDetails: DailyActivityDetail){
  }
  
  func editPhotEditActivityResponse(at editActivityResponse: EditPhotoActivityEmptyResponse){
    self.displayServerError(withMessage: "The Media Activity is Added Succesfully")
  }
  
  func failure(message: String) {
    self.displayServerError(withMessage: message)
  }
  
}

//MARK:- UITextViewDelegate Methodes

extension AddVideoActivityVC: UITextViewDelegate{
  
  func textViewDidEndEditing(_ textView: UITextView) {
    textviewDescription = textView.text
    
  }
}

//MARK:- GetClassDelegate Methodes

extension AddVideoActivityVC: sendSelectedDetailsDelegate{
  
  func getSelectedDetails(classID: Int, sectionID: Int, _ classModel: ClassModel, _ sectionModel: Section) {
    selectedClassModel = classModel
    selectedSectionModel = sectionModel
    selectedClassID = classModel.id
    selectedSectionID = sectionModel.id
  }
}
