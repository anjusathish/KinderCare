//
//  PhotoDailyActivityVC.swift
//  Kinder Care
//
//  Created by CIPL0668 on 16/03/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SKPhotoBrowser

class PhotoDailyActivityVC: BaseViewController {
    
    @IBOutlet var activityTableView: UITableView!
    
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet weak var sendCancelView: CTView!
    
    var state:Int?
    var activityId:Int?
    var activityDetail:DailyActivityDetail?
    var activityType: ActivityType!
    var delegate:refreshDailyActivityDelegate?
    
    lazy var viewModel : DailyActivityViewModel   =  {
        return DailyActivityViewModel()
    }()
    
    private var userType : UserType!
    
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
        
        
        
        self.activityTableView.register(UINib(nibName: "SelectedStudentsTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectedStudentsTableViewCell")
        self.activityTableView.register(UINib(nibName: "ActivityDetailsTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityDetailsTimeTableViewCell")
        self.activityTableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
        self.activityTableView.register(UINib(nibName: "AttachmentViewAllTableViewCell", bundle: nil), forCellReuseIdentifier: "AttachmentViewAllTableViewCell")
    }
    
    func configureUI() {
        
        if  let userType = UserManager.shared.currentUser?.userType {
            
            if let _type = UserType(rawValue:userType ) {
                
                self.userType = _type
                
                switch  _type  {
                    
                case .admin :
                    cancelBtn.setTitle("Reject", for: .normal)
                    sendBtn.setTitle("Approve", for: .normal)
                    if activityDetail?.state == 2{
                        
                        let editTopBtn = UIButton(frame: CGRect(x: self.view.frame.width - (16 + 65), y: 15 + safeAreaHeight, width: 70, height: 30))
                        editTopBtn.setTitle("Edit", for: .normal)
                        editTopBtn.setImage(UIImage(named: "EditWhite"), for: .normal)
                        editTopBtn.backgroundColor = UIColor.clear
                        editTopBtn.addTarget(self, action: #selector(editBtnAction(button:)), for: .touchUpInside)
                        
                        if let _ = activityId {
                            sendBtn.setTitle("Send", for: .normal)
                            self.view.addSubview(editTopBtn)
                        }
                        else {
                            sendBtn.setTitle("Save & Send", for: .normal)
                            cancelBtn.backgroundColor = UIColor(hex: 0xF5563E, alpha: 1.0)
                        }
                        
                        cancelBtn.setTitle("Reject", for: .normal)
                        
                       
                        
                    }
                    if state == 1 {
                        sendCancelView.isHidden = true
                    }
                    else if state == 0 {
                        sendCancelView.isHidden = true
                    }else{
                        sendCancelView.isHidden = false
                    }
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
                    
                    
                    
                default : break
                }
            }
        }
    }
    
    @objc func editBtnAction(button : UIButton) {
        
        //        let story = UIStoryboard(name: "AddActivity", bundle: nil)
        //        let nextVC = story.instantiateViewController(withIdentifier: "SelectStudentVC") as! SelectStudentVC
        //        nextVC.activityType = activityType
        //        self.navigationController?.pushViewController(nextVC, animated: true)
        
        let story = UIStoryboard(name: "AddActivity", bundle: nil)
        let nextVC = story.instantiateViewController(withIdentifier: "AddVideoActivityVC") as! AddVideoActivityVC
        nextVC.activityDetail = activityDetail
        nextVC.activityType = activityType.rawValue
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //MARK:- Button Action
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        if let activityID = activityDetail?.id{
            
            viewModel.activityUpdate(id: "\(activityID)", state: "0")
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func sendBtnAction(_ sender: Any) {
        if let activityID = activityDetail?.id{
            
            viewModel.activityUpdate(id: "\(activityID)", state: "1")
        }
    }
    @objc func videoDownloadAction(_ sender : UIButton){
        
        if let videoUrlString = activityDetail?.attachments?[sender.tag].file{
            self.downloadVideoLinkAndCreateAsset(videoUrlString)
        }
    }
    
}//MARK:- TableView

extension PhotoDailyActivityVC :UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if let attachment = activityDetail?.attachments {
                return attachment.count
            }
            else
            {
                return 0
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentViewAllTableViewCell", for: indexPath) as! AttachmentViewAllTableViewCell
            cell.activityTypeView.isHidden = true
            
            if activityDetail?.type == "photo"{
                cell.videoPlayImage.isHidden = true
                
            }else{
                cell.videoPlayImage.isHidden = false
            }
            
            if let thumbImg = activityDetail?.attachments?[indexPath.row].thumb{
                
                if let urlString = thumbImg.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
                    
                    if let url = URL(string: urlString) {
                        cell.attachmentImageView.sd_setImage(with: url)
                    }
                }
            }
            cell.attachmentDownloadButton.addTarget(self, action: #selector(videoDownloadAction(_:)), for: .touchUpInside)
            cell.attachmentDownloadButton.tag = indexPath.row
            cell.attachmentNameLabel.text = activityDetail?.attachments?[indexPath.row].mimetype
            
            //            if activityId == nil || indexPatvideoDownloadActionh.row != 0 {
            //                cell.activityTypeView.isHidden = true
            //            }
            //            else {
            //                cell.activityTypeView.isHidden = false
            //                cell.activityTypeLabel.text = activityType.rawValue
            //            }
            
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedStudentsTableViewCell", for: indexPath) as! SelectedStudentsTableViewCell
            cell.activityTypeView.isHidden = true
            cell.editBtn.addTarget(self, action: #selector(editBtnAction(button:)), for: .touchUpInside)
            
            if let students = activityDetail?.students {
                cell.selectedUsers = students.map({$0.studentName})
            }
            if activityId != nil {
                cell.editBtn.isHidden = true
            }
            else
            {
                cell.editBtn.isHidden = true
            }
            cell.collectionViewHeight.constant = cell.selectedStuCollectionView.collectionViewLayout.collectionViewContentSize.height
            
            return cell
            
            //        case 2:
            //            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityDetailsTimeTableViewCell", for: indexPath) as! ActivityDetailsTimeTableViewCell
            //
            //            cell.labelTime.text = activityDetail?.startTime
            //            cell.endTime.text = activityDetail?.endTime
            //            cell.catergoryStackView.isHidden = true
            //            cell.editBtn.addTarget(self, action: #selector(editBtnAction(button:)), for: .touchUpInside)
            //
            //            return cell
            
        case 2 :
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
            
            cell.descriptionLabel.text = activityDetail?.dataDescription
            
            return cell
            
        default : return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let activityAttachmentDetail = activityDetail?.attachments?[indexPath.row]{
            
            if activityAttachmentDetail.mimetype == "video/mp4"{
                
                if let videoFilePath = activityAttachmentDetail.file{
                    
                    guard let videoURL = URL(string: videoFilePath) else { return }
                    
                    playVideoPlayer(videoURL)
                    
                }
                
            }else{
                previewPhotobrowser()
            }
        }
    }
    
    //MARK:- Play Video
    
    func playVideoPlayer(_ videoURL: URL){
        
        let player = AVPlayer(url: videoURL)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.present(playerViewController, animated: true){
            
            playerViewController.player!.play()
            
        }
    }
    
    //MARK:- Preview Photobrowser
    
    func previewPhotobrowser() {
        
        var images = [SKPhoto]()
        
        if let activityAttachment = activityDetail!.attachments{
            
            for arrayImagesPath in activityAttachment {
                
                if let imageFilePath = arrayImagesPath.file{
                    
                    let photo = SKPhoto.photoWithImageURL(imageFilePath)
                    photo.shouldCachePhotoURLImage = false
                    images.append(photo)
                }
            }
            
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(0)
            present(browser, animated: true, completion: {})
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


//MARK:- DailyActivityDelegate Methodes

extension PhotoDailyActivityVC : DailyActivityDelegate {
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
        
    }
    
    func editPhotEditActivityResponse(at editActivityResponse: EditPhotoActivityEmptyResponse) {
        
    }
    
    
    func getListDailyActivity(at dailyActivityList: [DailyActivity]) {
        
    }
    
    func viewDailyActivitySuccessfull(dailyActivityDetails: DailyActivityDetail) {
        activityDetail = dailyActivityDetails
        configureUI()
        activityTableView.reloadData()
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
    }
}

