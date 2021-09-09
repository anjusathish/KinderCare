//
//  IncidentDailyActivityVC.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 29/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class IncidentDailyActivityVC: BaseViewController {
  
  @IBOutlet var activityTableView: UITableView!
  @IBOutlet var statusLbl: UILabel!
  
  @IBOutlet var sendBtn: UIButton!
  @IBOutlet var cancelBtn: UIButton!
    @IBOutlet weak var sendCancelView: CTView!
    var state:Int?
  var activityId:Int?
  var activityType: ActivityType!
  var viewDailyActivityDetails:DailyActivityDetail?
  public var addIncidentRequest: AddIncidentActivityRequest?
  public var updateIncidentRequest: UpdateDailyActivityRequest?
  var delegate:refreshDailyActivityDelegate?
    
  lazy var viewModel : DailyActivityViewModel   =  {
    return DailyActivityViewModel()
  }()
  
  //MARK:- ViewController LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.delegate = self
    
    if let _activityId = activityId {
      titleString = (activityType.rawValue).uppercased()
      viewModel.viewDailyActivity(activity_id: _activityId)
    }
    else {
      titleString = "PREVIEW"
    }
    
    configureUI()
    
    
    
    
    self.activityTableView.register(UINib(nibName: "ActivitySelectedStudentTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivitySelectedStudentTableViewCell")
    
    self.activityTableView.register(UINib(nibName: "ActivityPreviewHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ActivityPreviewHeaderView")
    
    self.activityTableView.register(UINib(nibName: "SelectedStudentsTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectedStudentsTableViewCell")
    
    self.activityTableView.register(UINib(nibName: "ActivityDetailsTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityDetailsTimeTableViewCell")
    
    self.activityTableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
    
    self.activityTableView.register(UINib(nibName: "AttachmentTableViewCell", bundle: nil), forCellReuseIdentifier: "AttachmentTableViewCell")
    
    
    
    
    
  }
  func configureUI() {
    if  let userType = UserManager.shared.currentUser?.userType {
      
      if let _type = UserType(rawValue:userType ) {
        switch  _type  {
        case .admin :
          
         if  activityId != nil {
           
           let editTopBtn = UIButton(frame: CGRect(x: self.view.frame.width - (16 + 65), y: 15 + safeAreaHeight, width: 70, height: 30))
           editTopBtn.setTitle("Edit", for: .normal)
           editTopBtn.setImage(UIImage(named: "EditWhite"), for: .normal)
           editTopBtn.backgroundColor = UIColor.clear
           editTopBtn.tag = 3
           editTopBtn.addTarget(self, action: #selector(editBtnAction(button:)), for: .touchUpInside)
           self.view.addSubview(editTopBtn)
           
           sendBtn.setTitle("Send", for: .normal)
           cancelBtn.setTitle("Reject", for: .normal)
           
         }else{
           sendBtn.setTitle("Save & Send", for: .normal)
            cancelBtn.setTitle("Cancel", for: .normal)
         }
         if state == 1 {
            sendCancelView.isHidden = true
         }
         else if state == 0 {
            sendCancelView.isHidden = true
         }else{
            sendCancelView.isHidden = false
            }
            
        case.teacher:
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
    //MARK:- Button Action
    func getSizeOfFile(urlString : String) -> String{
        do {
            let url = URL(string: urlString)
            let fileData = try Data(contentsOf: url as! URL)
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useKB]
            bcf.countStyle = .file
            let fileSizeString = bcf.string(fromByteCount: Int64(fileData.count))
            return fileSizeString
        } catch {
            print("Error: \(error)")
            return "\(error)"
        }
        
    }
    @objc   func attachmentViewAllBtnAction(_ sender: Any) {
        let vc = UIStoryboard.messageStoryboard().instantiateViewController(withIdentifier:"AttachmentsVC") as! AttachmentsVC
    if let attachments = self.viewDailyActivityDetails?.attachments {
      vc.attachmentsDetails = attachments
    }
    self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        if let activityID = viewDailyActivityDetails?.id{
            
            viewModel.activityUpdate(id: "\(activityID)", state: "0")
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }  }
    
    @IBAction func sendBtnAction(_ sender: Any) {
        
        if let _addIncidentRequest = addIncidentRequest{
            
            viewModel.addIncidentActivity(at: _addIncidentRequest)
        }else{
            
            if let activityID = viewDailyActivityDetails?.id{
                
                viewModel.activityUpdate(id: "\(activityID)", state: "1")
                
            }
    }
  }
  
  @objc   func editBtnAction(button : UIButton) {
    if button.tag == 1 {
      let vc = UIStoryboard.AddActivityStoryboard().instantiateViewController(withIdentifier:"StudentListVC") as! StudentListVC
      vc.modalPresentationStyle = .overCurrentContext
      self.navigationController?.present(vc, animated: true, completion: nil)
    }
    else if button.tag == 3 {
      let story = UIStoryboard(name: "AddActivity", bundle: nil)
      let nextVC = story.instantiateViewController(withIdentifier: "SelectStudentVC") as! SelectStudentVC
      nextVC.activityType = activityType
      nextVC.viewDailyActivityDetails = viewDailyActivityDetails
      self.navigationController?.pushViewController(nextVC, animated: true)
    }
    else
    {
      let vc = UIStoryboard.AddActivityStoryboard().instantiateViewController(withIdentifier:"AddActivityVC") as! AddActivityVC
      vc.activityType = activityType
      self.navigationController?.pushViewController(vc, animated: true)
      
    }
  }
  
  
}
//MARK:- TableView

extension IncidentDailyActivityVC :UITableViewDataSource,UITableViewDelegate
{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    }
    else if section == 1
    {
      return 1
    }
    else
    {
      return 1
    }
    
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.section {
      
    case 0:
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedStudentsTableViewCell", for: indexPath) as! SelectedStudentsTableViewCell
      cell.selectionStyle = .none
      
      
      if activityId != nil {
        cell.activityTypeView.isHidden = true
      }
      else
      {
        cell.activityTypeView.isHidden = false
        cell.activityTypeLabel.text = activityType.rawValue + "Activity"
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
      
      if let students = viewDailyActivityDetails?.students {
        cell.selectedUsers = students.map({$0.studentName})
      }else{
        if let arrayStudentName = addIncidentRequest?.studentName {
          
          cell.selectedUsers = arrayStudentName
        }
      }
      
      cell.collectionViewHeight.constant = cell.selectedStuCollectionView.collectionViewLayout.collectionViewContentSize.height
      cell.selectedStuCollectionView.reloadData()
      return cell
      
      
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityDetailsTimeTableViewCell", for: indexPath) as! ActivityDetailsTimeTableViewCell
      cell.selectionStyle = .none
      cell.endTime.isHidden = true
      cell.endTimeLabel.isHidden = true
      
      
      
      if let _viewDailyActivityDetails = viewDailyActivityDetails{
        cell.labelTime.text = _viewDailyActivityDetails.startTime
        cell.endTime.text = _viewDailyActivityDetails.endTime
        
      }else{
        cell.labelTime.text = addIncidentRequest?.start_time
        cell.endTime.text = addIncidentRequest?.end_time
      }
      
      cell.catergoryStackView.isHidden = true
      cell.editBtn.addTarget(self, action: #selector(editBtnAction(button:)), for: .touchUpInside)
      
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
      cell.selectionStyle = .none
      if let _viewDailyActivity = viewDailyActivityDetails {
        cell.descriptionLabel.text = _viewDailyActivity.dataDescription
      }else{
        cell.descriptionLabel.text = addIncidentRequest?.description
      }
      return cell
      
    case 3:
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentTableViewCell", for: indexPath) as! AttachmentTableViewCell
      cell.selectionStyle = .none
      
      if viewDailyActivityDetails?.attachments?.count == 0 {
        cell.attachmentView.isHidden = true
      }
      else if addIncidentRequest?.attachments.count == 0 {
         cell.attachmentView.isHidden = true
      }
      else{
         cell.attachmentView.isHidden = false
        
      }
      
      
      if  let count = viewDailyActivityDetails?.attachments?.count {
        cell.attachmentView.labelAttachment.text = "Attachments (" + "\(count)" + ")"
      }else{
        
        if let count = addIncidentRequest?.attachments.count{
          cell.attachmentView.labelAttachment.text = "Attachments (" + "\(count)" + ")"
        }
        
      }
      
      if let attachmentFile = viewDailyActivityDetails?.attachments?[indexPath.row].file {
        
        cell.attachmentView.attachmentSizeLabel.text = getSizeOfFile(urlString: attachmentFile)
        
      }else{
        
      }
      cell.attachmentView.viewAllAction = { (sender : UIButton) in
        
        let vc = UIStoryboard.messageStoryboard().instantiateViewController(withIdentifier:"AttachmentsVC") as! AttachmentsVC
        if let attachments = self.viewDailyActivityDetails?.attachments {
          vc.attachmentsDetails = attachments
        }
        self.navigationController?.pushViewController(vc, animated: true)
      }
      return cell
      
      
    default : return UITableViewCell()
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
extension IncidentDailyActivityVC : DailyActivityDelegate {
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
    self.displayServerSuccess(withMessage: "Add Incident Daily Activity Successfully")
    if let viewController = navigationController?.viewControllers.first(where: {$0 is ActivityListVC}) {
      navigationController?.popToViewController(viewController, animated: true)
    }
  }
  
  func editPhotEditActivityResponse(at editActivityResponse: EditPhotoActivityEmptyResponse) {
    
  }
  
  func getListDailyActivity(at dailyActivityList: [DailyActivity]) {
    
  }
  
  func viewDailyActivitySuccessfull(dailyActivityDetails: DailyActivityDetail) {
    viewDailyActivityDetails = dailyActivityDetails
    activityTableView.reloadData()
  }
  
  func failure(message: String) {
    displayServerError(withMessage: message)
  }
  
  
}

