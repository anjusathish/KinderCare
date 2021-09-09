//
//  DashboardVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 06/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CoreMedia
import Photos
import SKPhotoBrowser

class DashboardVC: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    //MARK:- Initialization
    
    @IBOutlet weak var tblActivities: UITableView!
    @IBOutlet weak var childDropDown: ChildDropDown!
    @IBOutlet weak var collActivity: UICollectionView!
    @IBOutlet weak var lblActivity: UILabel!
    @IBOutlet weak var calendarViw: CTDayCalender!
    
    @IBOutlet weak var lblDescription: UILabel!
    var rowCount = 0
    lazy var strActivityType = "All"
    var selectedIndexPath : IndexPath?
    var selectedActivityIndex : Int?
    
    var childNameID:Int?
    var playerItem : AVPlayerItem!
    var videoPlayer : AVPlayer!
    
    
    var activityArray = ["Photo","Video","Meal","Nap","Classroom","Bathroom","Medicine","Incident"]
    var arrayImageActivity = ["PhotoNormal","VideoNormal","Mealicon","Nap","Classroom","BathroomA","Medicineicon","Incident"]
    var arrayImageHighlight = ["PhotoHighlight","VideoHighlight","MealHighlight","NapHighlight","ClassroomHighlight","BathroomHightlight","MedicineHighlight","IncidentHighlight"]
    
    var childNameArray = [ChildName]()
    var classSectionArray  = [[String]]()
    var dashboardActivityArray = [DashboardActivity]()
    var mealsArray = [mealsData]()
    var videoPhotoArray = [Attachment]()
    var VideoPhotoNew = [String]()
    
    lazy var viewModel : childNameViewModel = {
        return childNameViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarHeight = 100
        titleString = "DASHBOARD"
        
        //tblActivities.delegate = self
      //  tblActivities.dataSource = self
        
        viewModel.delegate = self
        viewModel.childNameList()

        tblActivities.register(UINib(nibName: "ActivityTableCell", bundle: nil), forCellReuseIdentifier: "ActivityTableCell")
        tblActivities.register(UINib(nibName: "VideoImageCell", bundle: nil), forCellReuseIdentifier: "VideoImageCell")
        tblActivities.register(UINib(nibName: "MealCell", bundle: nil), forCellReuseIdentifier: "MealCell")
        tblActivities.register(UINib(nibName: "ClassRoomCell", bundle: nil), forCellReuseIdentifier: "ClassRoomCell")
        tblActivities.register(UINib(nibName: "NapIncidentMedicideCell", bundle: nil), forCellReuseIdentifier: "NapIncidentMedicideCell")
        tblActivities.register(UINib(nibName: "AttachmentTableViewCell", bundle: nil), forCellReuseIdentifier: "AttachmentTableViewCell")
        
        collActivity.register(UINib(nibName: "ActivivtyCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ActivivtyCollectionCell")
        collActivity.register(UINib(nibName: "ActivityImageCell", bundle: nil), forCellWithReuseIdentifier: "ActivityImageCell")
        
        self.view.bringSubviewToFront(childDropDown)
        
        childDropDown.titleArray = childNameArray.map({$0.name})
        
        childDropDown.subtitleArray = childNameArray.map({$0.className + " , " + $0.section + " Section"})
        childDropDown.imageArray = childNameArray.map({$0.profile})
        
        childDropDown.selectionAction = { (index : Int) in
            self.childNameID = self.childNameArray[index].id
            
        }
        
        childDropDown.addChildAction = { (sender : UIButton) in
            let vc = UIStoryboard.FamilyInformationStoryboard().instantiateViewController(withIdentifier:"AddChildVC") as! AddChildVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if let childName = UserManager.shared.childNameList {
            childNameArray = childName
            self.childNameID = childNameArray.map({$0.id}).first
        }
        if let schoolId = UserManager.shared.currentUser?.school_id{
            SharedPreferenceManager.shared.getClassNameList(schoolId: "\(schoolId)")
        }
        // Commit test
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    func dropDownSetUp(){
        if childNameArray.count > 1 {
            
            
            childDropDown.titleArray = childNameArray.map({$0.name})
            
            childDropDown.subtitleArray = childNameArray.map({$0.className + " , " + $0.section + " Section"})
            
            childDropDown.imageArray = childNameArray.map({$0.profile})
              childDropDown.isUserInteractionEnabled = true
            
        }
        else{
            childDropDown.titleArray = childNameArray.map({$0.name})
            
            childDropDown.subtitleArray = childNameArray.map({$0.className + " , " + $0.section + " Section"})
            
            childDropDown.imageArray = childNameArray.map({$0.profile})
            childDropDown.isUserInteractionEnabled = false
        }
        
        
    }
    
    // MARK: - Local Methods
    @objc func attachmentViewAllBtnAction(_ sender: Any) {
        let vc = UIStoryboard.messageStoryboard().instantiateViewController(withIdentifier:"AttachmentsVC") as! AttachmentsVC
        
        let attachment  = dashboardActivityArray.map({$0.attachments})
        for attachmentItem in attachment {
            vc.attachmentsDetails = attachmentItem ?? []
        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func calenderAction(_ sender: CTDayCalender) {
        self.ActivityData()
    }
    
    // MARK:- All List
    func listAllCell(tableView:UITableView,strType:String,indexPath:IndexPath) -> UITableViewCell{
        if strType == "Meal"{
            let cell = self.tblActivities.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath)
            
            
            return cell
        }
            
            
        else if strType == "Photo" || strType == "Video" {
            let cell = self.tblActivities.dequeueReusableCell(withIdentifier: "VideoImageCell", for: indexPath)
            
            
            
            return cell
        }else{
            
            
            let cell:NapIncidentMedicideCell = self.tblActivities.dequeueReusableCell(withIdentifier: "NapIncidentMedicideCell", for: indexPath) as! NapIncidentMedicideCell
            cell.lblTitle.text = strType
            cell.hideAttachment(strType: strType)
            return cell
        }
    }
    
    //MARK:- Table View Delegate
    
    
    //MARK:- CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayImageActivity.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ActivivtyCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivivtyCollectionCell", for: indexPath) as! ActivivtyCollectionCell
        
        
        if(indexPath.row == selectedActivityIndex){
            //if indexpath is selected use your darker image
            let imageName = self.arrayImageHighlight[indexPath.row]
            cell.imgView.image = UIImage(named: imageName)
            
        }
        else
        {
            let imageName = self.arrayImageActivity[indexPath.row]
            cell.imgView.image = UIImage(named: imageName)
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedActivityIndex = indexPath.row
        let activity = self.activityArray[indexPath.row]
        self.strActivityType = activity
        self.tblActivities.reloadData()
        self.collActivity.reloadData()
        self.ActivityData()
        
        
    }
    
    func ActivityData(){
        
        if selectedActivityIndex == 0 {
            if let studentId = childNameID{
                viewModel.dashboardActivity(studentID: "\(studentId)", fromDate: calendarViw.date.getasString(inFormat: "yyyy-MM-dd"), toDate: calendarViw.date.getasString(inFormat: "yyyy-MM-dd"), type: "Photo")
            }
        }
            
        else if selectedActivityIndex == 1 {
            if let studentId = childNameID{
                viewModel.dashboardActivity(studentID: "\(studentId)", fromDate: calendarViw.date.getasString(inFormat: "yyyy-MM-dd"), toDate: calendarViw.date.getasString(inFormat: "yyyy-MM-dd"), type: "Video")
            }
        }
            
        else if selectedActivityIndex == 2 {
            if let studentId = childNameID{
                viewModel.dashboardActivity(studentID: "\(studentId)", fromDate: calendarViw.date.getasString(inFormat: "yyyy-MM-dd"), toDate: calendarViw.date.getasString(inFormat: "yyyy-MM-dd"), type: "Meal")
            }
        }
            
        else if selectedActivityIndex == 3 {
            
            if let studentId = childNameID{
                viewModel.dashboardActivity(studentID: "\(studentId)", fromDate: calendarViw.date.getasString(inFormat: "yyyy-MM-dd"), toDate: calendarViw.date.getasString(inFormat: "yyyy-MM-dd"), type: "nap")
            }
            
        }
        else if selectedActivityIndex == 4 {
            
            if let studentId = childNameID{
                viewModel.dashboardActivity(studentID: "\(studentId)", fromDate: calendarViw.date.getasString(inFormat: "yyyy-MM-dd"), toDate: calendarViw.date.getasString(inFormat: "yyyy-MM-dd"), type: "classroom")
            }
        }
        else if selectedActivityIndex == 5 {
            
            if let studentId = childNameID{
                viewModel.dashboardActivity(studentID: "\(studentId)", fromDate: calendarViw.date.getasString(inFormat: "yyyy-MM-dd"), toDate: calendarViw.date.getasString(inFormat: "yyyy-MM-dd"), type: "Bathroom")
            }
        }
        else if selectedActivityIndex == 6 {
            
            if let studentId = childNameID{
                viewModel.dashboardActivity(studentID: "\(studentId)", fromDate: calendarViw.date.getasString(inFormat: "yyyy-MM-dd"), toDate: calendarViw.date.getasString(inFormat: "yyyy-MM-dd"), type: "Medicine")
            }
        }
        else if selectedActivityIndex == 7 {
            
            if let studentId = childNameID{
                viewModel.dashboardActivity(studentID: "\(studentId)", fromDate: calendarViw.date.getasString(inFormat: "yyyy-MM-dd"), toDate: calendarViw.date.getasString(inFormat: "yyyy-MM-dd"), type: "Incident")
            }
        }
    }
    @objc func videoDownloadAction(_ sender : UIButton){
        
        if let videoUrlString = videoPhotoArray[sender.tag].file{
            self.downloadVideoLinkAndCreateAsset(videoUrlString)
        }
    }
    
}
extension DashboardVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.strActivityType == "Meal"  {
            
            let filteredArray = mealsArray.map({$0.course_type_name}).uniques
            
            return filteredArray.count
        }
            
        else if self.strActivityType == "Photo"  {
            return VideoPhotoNew.count
        }
        else if self.strActivityType == "Video"  {
            return videoPhotoArray.count
        }
        else {
            return dashboardActivityArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if strActivityType == "Meal"{
            
            let cell = self.tblActivities.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealCell
                        
            let filteredArray = mealsArray.map({$0.course_type_name}).uniques

            let course_type_name = filteredArray[indexPath.row]
            
            let filteredMealArray = mealsArray.filter({$0.course_type_name == course_type_name})
            
            for item in cell.foodNameStack.subviews {
              item.removeFromSuperview()
            }
            
            for item in filteredMealArray {
                let itemLabel = UILabel()
                itemLabel.font = UIFont.systemFont(ofSize: 15)
                itemLabel.text = item.food_name
              cell.foodNameStack.addArrangedSubview(itemLabel)
            }
            
            cell.foodNameLbl.text = course_type_name
            cell.descriptionLbl.text = mealsArray[indexPath.row].description
            
            if let startTime = mealsArray[indexPath.row].start_time,let endTime = mealsArray[indexPath.row].end_time{
                
                cell.lblTime.text =  startTime + " to " + endTime
            }
            
            return cell
        }
            
        else if self.strActivityType == "Classroom"{
            
            let cell = self.tblActivities.dequeueReusableCell(withIdentifier: "ClassRoomCell", for: indexPath) as! ClassRoomCell
            
            if dashboardActivityArray[indexPath.row].attachments?.count == 0{
                cell.attachmentView.isHidden = true
            }
            else{
                 cell.attachmentView.isHidden = false
            }
            
            cell.categoryLbl.text = dashboardActivityArray[indexPath.row].classroomCategoryName
            
            if let startTime = dashboardActivityArray[indexPath.row].startTime,let endTime = dashboardActivityArray[indexPath.row].endTime {
                
                cell.durationLbl.text = startTime + " to " + endTime
                
            }
            cell.tilteLbl.text = dashboardActivityArray[indexPath.row].title
            cell.labelSubject.text = dashboardActivityArray[indexPath.row].datumDescription
            cell.milestoneLbl.text = dashboardActivityArray[indexPath.row].classroomMilestoneName
            cell.viewAllBtn.addTarget(self, action: #selector(attachmentViewAllBtnAction(_:)), for: .touchUpInside)
            
            
            
            return cell
            
        }else if self.strActivityType == "All"{
            
            let cell = self.tblActivities.dequeueReusableCell(withIdentifier: "VideoImageCell", for: indexPath)
            return cell
        }
        else if self.strActivityType == "Photo" || self.strActivityType == "Video" {
            let cell = self.tblActivities.dequeueReusableCell(withIdentifier: "VideoImageCell", for: indexPath) as! VideoImageCell
            
            if self.strActivityType == "Photo" {
                
                cell.playerView.isHidden = true
                cell.imageViw.isHidden = false
                cell.lblPhoto.text = "PHOTOS"
                 let img = VideoPhotoNew[indexPath.row]
                    print(img)
                    cell.downLoadBtn.addTarget(self, action: #selector(videoDownloadAction(_:)), for: .touchUpInside)
                    if let urlString = img.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
                        if let url = URL(string: urlString) {
                            cell.imageViw.sd_setImage(with: url)
                        }
                    }
                
                //cell.descriptionLbl.text = videoPhotoArray.first?.description
                if let description = videoPhotoArray.first?.description {
                    cell.descriptionLbl.text = description
                }
                
            }else if self.strActivityType == "Video"{
                cell.playerView.isHidden = false
                cell.imageViw.isHidden = true
                if let videoUrlString = videoPhotoArray[indexPath.row].file{
                    print(videoUrlString)
                    cell.downLoadBtn.addTarget(self, action: #selector(videoDownloadAction(_:)), for: .touchUpInside)
                    cell.downLoadBtn.tag = indexPath.row
                    let videoURL = URL(string: videoUrlString)
                    let player = AVPlayer(url: videoURL!)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.addChild(playerViewController)
                    cell.playerView.addSubview(playerViewController.view)
                    playerViewController.view.frame = cell.playerView.frame
                    
                }
                
                cell.lblPhoto.text = "VIDEOS"
                
            }else{
                cell.lblPhoto.text = "PHOTOS"
            }
            return cell
        }else{
            
            
            let cell:NapIncidentMedicideCell = self.tblActivities.dequeueReusableCell(withIdentifier: "NapIncidentMedicideCell", for: indexPath) as! NapIncidentMedicideCell
            let type = self.dashboardActivityArray[indexPath.row].type
            cell.lblTitle.text = type.uppercased() + " ACTIVITY"
            // cell.lblTitle.text = type
            
            
            if let startTime = dashboardActivityArray[indexPath.row].startTime,let endTime = dashboardActivityArray[indexPath.row].endTime {
                
                cell.timeLbl.text = startTime + " to " + endTime
                
            }
            
            
            
            cell.descriptionLbl.text = self.dashboardActivityArray[indexPath.row].datumDescription
            cell.hideAttachment(strType: self.strActivityType)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.strActivityType == "Photo" &&  self.strActivityType == "Video" {
        var images = [SKPhoto]()
        
        if let activityAttachment = videoPhotoArray[indexPath.row].file{
            
            let photo = SKPhoto.photoWithImageURL(activityAttachment)
            photo.shouldCachePhotoURLImage = false
            images.append(photo)
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(0)
            present(browser, animated: true, completion: {})
        }
        
               }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}


//MARK:- Collection View FlowLayout
extension DashboardVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let dimension:CGFloat = collectionView.frame.size.width / 6
        return CGSize(width: 70, height: 70)
    }
}

extension DashboardVC:childNameListDelegate{
    
    func dashboardActivity(dashboard: [DashboardActivity]) {
        self.dashboardActivityArray.removeAll()
        dashboardActivityArray = dashboard
        let meal = dashboard.map({$0.meals})
        // mealsArray = meal
        for mealItem in meal {
            mealsArray = mealItem ?? []
        }
        let videoPhoto  = dashboard.map({$0.attachments})
        
        for videoPhotoItem in videoPhoto {
            videoPhotoArray = videoPhotoItem ?? []
            for newVideoPhoto in videoPhotoArray{
                VideoPhotoNew.append(newVideoPhoto.file!)
            }
        }
        
        print(videoPhotoArray)
        
        self.tblActivities.reloadData()
        
    }
    
    func childNameList(schoolList: [ChildName]) {
        childNameArray = schoolList
        self.dropDownSetUp()
    }
    
    func failure(message: String) {
        self.dashboardActivityArray.removeAll()
        self.mealsArray.removeAll()
        self.videoPhotoArray.removeAll()
        self.tblActivities.reloadData()
        displayServerError(withMessage: message)
    }
    
    
}

