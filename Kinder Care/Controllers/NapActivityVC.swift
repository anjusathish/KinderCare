//
//  NapActivityVC.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 29/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class NapActivityVC: BaseViewController {
  
  @IBOutlet var activityTableView: UITableView!
  @IBOutlet var statusLbl: UILabel!
  
  @IBOutlet var sendBtn: UIButton!
  @IBOutlet var cancelBtn: UIButton!
  @IBOutlet var bottomCancelSendView: CTView!
  
  var activityId:Int?
    var state:Int?
  var activityType: ActivityType!
  var viewDailyActivityDetails:DailyActivityDetail?
  var addNapRequest: AddNapActivityRequest?
  var updateNapActivityRequest: UpdateDailyActivityRequest?
  var addMedicineRequest: AddMedicineActivityRequest?
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
    else{
      titleString = "PREVIEW"
    }
    
    configureUI()
    
    self.activityTableView.register(UINib(nibName: "ActivitySelectedStudentTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivitySelectedStudentTableViewCell")
    self.activityTableView.register(UINib(nibName: "ActivityPreviewHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ActivityPreviewHeaderView")
    self.activityTableView.register(UINib(nibName: "SelectedStudentsTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectedStudentsTableViewCell")
    self.activityTableView.register(UINib(nibName: "ActivityDetailsTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityDetailsTimeTableViewCell")
    self.activityTableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
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
            
           
            if state == 1 {
                 bottomCancelSendView.isHidden = true
            }
            else if state == 0 {
                bottomCancelSendView.isHidden = true
            }else{
                bottomCancelSendView.isHidden = false
            }
            
            
            
          }else{
            sendBtn.setTitle("Save & Send", for: .normal)
            bottomCancelSendView.isHidden = false
            cancelBtn.setTitle("Cancel", for: .normal)
            if state == 1 {
                 bottomCancelSendView.isHidden = true
            }
            else if state == 0 {
                bottomCancelSendView.isHidden = true
            }else{
                bottomCancelSendView.isHidden = false
            }
            
          }
            
        case.teacher:
            if let _activityId = activityId {
                
                bottomCancelSendView.isHidden = true
                
            }
            else {
                bottomCancelSendView.isHidden = false
                
            }
            
            sendBtn.setTitle("Send", for: .normal)
            cancelBtn.setTitle("Cancel", for: .normal)
            
            if state == 1 {
                 bottomCancelSendView.isHidden = true
            }
            else if state == 0 {
                bottomCancelSendView.isHidden = true
            }else{
                bottomCancelSendView.isHidden = false
            }
            
            
            
            
        default :
          sendBtn.setTitle("Send", for: .normal)
          bottomCancelSendView.isHidden = false
          cancelBtn.setTitle("Cancel", for: .normal)
          
          if state == 1 {
               bottomCancelSendView.isHidden = true
          }
          else if state == 0 {
              bottomCancelSendView.isHidden = true
          }else{
              bottomCancelSendView.isHidden = false
          }
          
          break
        }
      }
    }
  }
  
  @objc func editBtnAction(button : UIButton) {
    
    if button.tag == 1 {
      
      let story = UIStoryboard(name: "AddActivity", bundle: nil)
      let nextVC = story.instantiateViewController(withIdentifier: "SelectStudentVC") as! SelectStudentVC
      nextVC.activityType = activityType
      self.navigationController?.pushViewController(nextVC, animated: true)
      
      
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
  //MARK:- Button Action
  
    @IBAction func cancelBtnAction(_ sender: Any) {
        if let activityID = viewDailyActivityDetails?.id{
            
            viewModel.activityUpdate(id: "\(activityID)", state: "0")
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func sendBtnAction(_ sender: Any) {
    
    if let _addNapRequest = addNapRequest{
            
      
      viewModel.addNapActivity(at: _addNapRequest)
      
    }else{
      
      if let activityID = viewDailyActivityDetails?.id{
        if UserManager.shared.currentUser?.userTypeName == "admin"{
        viewModel.activityUpdate(id: "\(activityID)", state: "1")
        }
      }
      else {
        self.navigationController?.popViewController(animated: true)
        }
    }
  }
  
  
}
//MARK:- TableView

extension NapActivityVC :UITableViewDataSource,UITableViewDelegate
{
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
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
      
    case 0 :
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedStudentsTableViewCell", for: indexPath) as! SelectedStudentsTableViewCell
      cell.activityTypeLabel.isHidden = true
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
        
        if let arrayStudentName = addNapRequest?.studentName {
          
          cell.selectedUsers = arrayStudentName
          
        }else{
          if let arrayStudentName = updateNapActivityRequest?.studentName {
            
            cell.selectedUsers = arrayStudentName
          }
        }
      }
      
      cell.collectionViewHeight.constant = cell.selectedStuCollectionView.collectionViewLayout.collectionViewContentSize.height
      cell.selectedStuCollectionView.reloadData()
      return cell
      
    case 1 :
      let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityDetailsTimeTableViewCell", for: indexPath) as! ActivityDetailsTimeTableViewCell
      cell.selectionStyle = .none
      
      if let _viewDailyActivity = viewDailyActivityDetails {
        cell.labelTime.text = _viewDailyActivity.startTime
        cell.endTime.text = _viewDailyActivity.endTime
        
      }else{
        
        if let _addNapRequest = addNapRequest{
          
          cell.labelTime.text = _addNapRequest.start_time
          cell.endTime.text = _addNapRequest.end_time
          
        }else{
          cell.labelTime.text = updateNapActivityRequest?.start_time
          cell.endTime.text = updateNapActivityRequest?.end_time
        }
      }
      
      cell.catergoryStackView.isHidden = true
      cell.editBtn.addTarget(self, action: #selector(editBtnAction(button:)), for: .touchUpInside)
      
      return cell
      
    case 2 :
      let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
      cell.selectionStyle = .none
      
      if let _viewDailyActivity = viewDailyActivityDetails {
        cell.descriptionLabel.text = _viewDailyActivity.dataDescription
      }else{
        
        if let _addNapRequest = addNapRequest{
          cell.descriptionLabel.text = _addNapRequest.description
        }else{
          cell.descriptionLabel.text = updateNapActivityRequest?.description
        }
        
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

extension NapActivityVC : DailyActivityDelegate {
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
    self.displayServerSuccess(withMessage: "Add Nap Activity Successfully")
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
