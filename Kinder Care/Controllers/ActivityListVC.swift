//
//  ActivityListVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 26/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class ActivityListVC: BaseViewController {
  
  //MARK:- Initialization
  @IBOutlet weak var collViewActivity: UICollectionView!
  
  var arrActivity = ["Photo","Video","Meal","Nap","Classroom","Bathroom","Medicine","Incident"]
  var arrActivityImage = ["photoAdd","videoAdd","mealAdd","napAdd","classAdd","toiletAdd","medicneAdd","IncidentAdd"]
  
  //MARK:- View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    titleString = "Choose Activity"
    collViewActivity.register(UINib(nibName: "AddActivityCell", bundle: nil), forCellWithReuseIdentifier: "AddActivityCell")
    
    // Do any additional setup after loading the view.
  }
  
  //MARK:- Local Methods
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    DispatchQueue.main.async {
      self.collViewActivity?.collectionViewLayout.invalidateLayout()
      self.collViewActivity.layoutIfNeeded()
      self.collViewActivity.reloadData()
    }
  }
}


extension ActivityListVC: UICollectionViewDelegate, UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return arrActivity.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddActivityCell", for: indexPath) as! AddActivityCell
    let activity = arrActivity[indexPath.row]
    let imageName = arrActivityImage[indexPath.row]
    cell.configUI(activity: activity, image: imageName)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let activity = arrActivity[indexPath.row]
    
    print(activity)
    
    switch activity {
      
    case "Photo":
      
      let story = UIStoryboard(name: "AddActivity", bundle: nil)
      let nextVC = story.instantiateViewController(withIdentifier: "AddVideoActivityVC") as! AddVideoActivityVC
      nextVC.activityType = "photo"
      self.navigationController?.pushViewController(nextVC, animated: true)
      
    case "Video":
      
      let story = UIStoryboard(name: "AddActivity", bundle: nil)
      let nextVC = story.instantiateViewController(withIdentifier: "AddVideoActivityVC") as! AddVideoActivityVC
      nextVC.activityType = "video"
      self.navigationController?.pushViewController(nextVC, animated: true)
      
    case "Classroom":
      
      let story = UIStoryboard(name: "AddActivity", bundle: nil)
      let nextVC = story.instantiateViewController(withIdentifier: "SelectStudentVC") as! SelectStudentVC
      nextVC.activityType = ActivityType(rawValue: activity)
      self.navigationController?.pushViewController(nextVC, animated: true)
      
//      let story = UIStoryboard(name: "AddActivity", bundle: nil)
//      let nextVC = story.instantiateViewController(withIdentifier: "AddClassRoomVC") as! AddClassRoomVC
//      self.navigationController?.pushViewController(nextVC, animated: true)
      
    default:
      
      let story = UIStoryboard(name: "AddActivity", bundle: nil)
      let nextVC = story.instantiateViewController(withIdentifier: "SelectStudentVC") as! SelectStudentVC
      nextVC.activityType = ActivityType(rawValue: activity)
      self.navigationController?.pushViewController(nextVC, animated: true)
      
    }
  }
}
//MARK:- Collection View FlowLayout
extension ActivityListVC: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    
    let width:CGFloat = collViewActivity.frame.size.width / 2
    let height:CGFloat = collViewActivity.frame.size.height / 4
    return CGSize(width: width-5, height: height)
  }
}

