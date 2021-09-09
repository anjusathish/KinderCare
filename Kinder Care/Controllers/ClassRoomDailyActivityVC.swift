//
//  ClassRoomDailyActivityVC.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 29/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class ClassRoomDailyActivityVC: BaseViewController {
    
    @IBOutlet var activityTableView: UITableView!
    @IBOutlet var statusLbl: UILabel!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet weak var sendCancelView: CTView!
    
    var state:Int?
    var activityId:Int?
    var activityType: ActivityType!
    var viewDailyActivityDetails:DailyActivityDetail?
    var addClassRoomRequest: AddClassRoomActivityRequest?
    var delegate:refreshDailyActivityDelegate?
    lazy var viewModel : DailyActivityViewModel   =  {
        return DailyActivityViewModel()
    }()
    
    public var selectedStudentsArray : [Student] = []
    public var classID : Int?
    public var sectionID : Int?
    
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
        
        
        self.activityTableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
        
        self.activityTableView.register(UINib(nibName: "AttachmentTableViewCell", bundle: nil), forCellReuseIdentifier: "AttachmentTableViewCell")
        
        self.activityTableView.register(UINib(nibName: "DailyActivityClassroomTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyActivityClassroomTableViewCell")
        
    }
    func configureUI() {
        if  let userType = UserManager.shared.currentUser?.userType {
            if let _type = UserType(rawValue:userType ) {
                switch  _type  {
                case .admin :
                    
                    let editTopBtn = UIButton(frame: CGRect(x: self.view.frame.width - (16 + 65), y: 15 + safeAreaHeight, width: 70, height: 30))
                    editTopBtn.setTitle("Edit", for: .normal)
                    editTopBtn.setImage(UIImage(named: "EditWhite"), for: .normal)
                    editTopBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
                    editTopBtn.backgroundColor = UIColor.clear
                    editTopBtn.tag = 3
                    editTopBtn.addTarget(self, action: #selector(editBtnAction(button:)), for: .touchUpInside)
                    
                    if  activityId != nil {
                        sendBtn.setTitle("Send", for: .normal)
                        cancelBtn.backgroundColor = UIColor(hex: 0xF5563E, alpha: 1.0)
                        self.view.addSubview(editTopBtn)
                        
                    }
                    else{
                        sendBtn.setTitle("Save & Send", for: .normal)
                    }
                    cancelBtn.setTitle("Reject", for: .normal)
                    
                    if state == 1 {
                       sendCancelView.isHidden = true
                    }
                    else if state == 0 {
                       sendCancelView.isHidden = true
                    }else{
                       sendCancelView.isHidden = false
                       }
                    break
                case .teacher:
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
        if let  data = viewDailyActivityDetails?.attachments {
            let vc = UIStoryboard.messageStoryboard().instantiateViewController(withIdentifier:"AttachmentsVC") as! AttachmentsVC
            print(data)
            vc.attachmentsDetails = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        if let activityID = viewDailyActivityDetails?.id{
            
            viewModel.activityUpdate(id: "\(activityID)", state: "0")
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func sendBtnAction(_ sender: Any) {
        if let request = addClassRoomRequest{
            
            viewModel.addClassRoomActivity(at: request)
        }
        else if  let activityID = viewDailyActivityDetails?.id {
            
            viewModel.activityUpdate(id: "\(activityID)", state: "1")
            
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
            let vc = UIStoryboard.AddActivityStoryboard().instantiateViewController(withIdentifier:"AddClassRoomVC") as! AddClassRoomVC
            
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    
}
//MARK:- TableView

extension ClassRoomDailyActivityVC :UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case 0 :
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
                        cell.editBtn.isHidden = true
                        cell.editBtn.tag = 1
                        cell.editBtn.addTarget(self, action: #selector(editBtnAction(button:)), for: .touchUpInside)
                    }
                }
            }
            
            if let students = viewDailyActivityDetails?.students {
                cell.selectedUsers = students.map({$0.studentName})
                
            }else{
                
                if let arrayStudentName = addClassRoomRequest?.studentName {
                    
                    cell.selectedUsers = arrayStudentName
                }
            }
            
            cell.collectionViewHeight.constant = cell.selectedStuCollectionView.collectionViewLayout.collectionViewContentSize.height
            cell.selectedStuCollectionView.reloadData()
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyActivityClassroomTableViewCell", for: indexPath) as! DailyActivityClassroomTableViewCell
            cell.selectionStyle = .none
            // cell.editBtn.isHidden = true
            
            if let _viewDailyActivityDetails = viewDailyActivityDetails{
                
                cell.activityTitleLabel.text = _viewDailyActivityDetails.classroomCategoryName
                cell.titleLabel.text = _viewDailyActivityDetails.title
                cell.descriptionLabel.text = _viewDailyActivityDetails.dataDescription
                cell.milestoneLabel.text = _viewDailyActivityDetails.classroomMilestoneName
                if let time = _viewDailyActivityDetails.startTime,let timeEnd =  _viewDailyActivityDetails.startTime{
                    
                    cell.durationLabel.text = time + " to " + timeEnd
                    
                }
                
                
                
            }else{
                
                cell.titleLabel.text = addClassRoomRequest?.title
                cell.descriptionLabel.text = addClassRoomRequest?.description
                if let milestone = addClassRoomRequest?.classroom_milestone_id{
                    cell.milestoneLabel.text = milestone
                }
                if let CategoryName = addClassRoomRequest?.classroom_category_id{
                    cell.activityTitleLabel.text = CategoryName
                }
                
                if let sTime  = addClassRoomRequest?.start_time,let eTime = addClassRoomRequest?.end_time{
                    
                    cell.durationLabel.text = sTime + " to " + eTime
                }
                
            }
            
            if  let count = viewDailyActivityDetails?.attachments?.count{
                
                cell.attachView.labelAttachment.text = "Attachments (" + "\(count)" + ")"
                
            }else{
                
                if let count = addClassRoomRequest?.attachments.count{
                    
                    cell.attachView.labelAttachment.text = "Attachments (" + "\(count)" + ")"
                    
                }
            }
           
            if viewDailyActivityDetails?.attachments?.count == 0 {
                
            }
            else{
            if let attachmentFile = viewDailyActivityDetails?.attachments?[indexPath.row].file {
                cell.attachView.attachmentSizeLabel.text = getSizeOfFile(urlString: attachmentFile)
            }
            }
            if  self.viewDailyActivityDetails?.attachments?.count == 0 {
                cell.attachView.isHidden = true
            }
            else if  self.addClassRoomRequest?.attachments.count == 0{
                cell.attachView.isHidden = true
            }
            else{
                cell.attachView.isHidden = false
            }
            cell.attachView.viewAllAction = { (sender : UIButton) in
                
                let vc = UIStoryboard.messageStoryboard().instantiateViewController(withIdentifier:"AttachmentsVC") as! AttachmentsVC
                print(self.viewDailyActivityDetails)
                if let attachments = self.viewDailyActivityDetails?.attachments {
                    vc.attachmentsDetails = attachments
                }
                else {
                    if let attachmentLink = self.addClassRoomRequest?.attachments{
                        print(attachmentLink)
                        vc.attachmentLink = attachmentLink
                    }
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

extension ClassRoomDailyActivityVC : DailyActivityDelegate{
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
        self.displayServerSuccess(withMessage: "Add ClassRoom Activity Successfully")
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

