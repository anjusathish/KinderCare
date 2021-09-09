//
//  AddMealCell.swift
//  Kinder Care
//
//  Created by CIPL0023 on 26/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
// Abdul edit

import UIKit
import DropDown

protocol sendSelectedDetailsDelegate {
  
  func getSelectedDetails(classID: Int, sectionID: Int,_ classModel: ClassModel, _ sectionModel: Section)
}

class AddCommonActivityCell: UITableViewCell {
  
  @IBOutlet weak var collStudent: UICollectionView!
  @IBOutlet weak var lblActivityName: UILabel!
  @IBOutlet weak var btnSelectStudent: UIButton!
  
  @IBOutlet weak var txtClass: CTTextField!
  @IBOutlet weak var txtSection: CTTextField!
    
    @IBOutlet weak var dateTxtFld: CTTextField!
    @IBOutlet weak var dateView: UIView!
    
  var activityPhotoDetails: DailyActivityDetail?
    
  var selectedUsers:[String] = [] {
    
    didSet {
      collStudent.reloadData()
    }
    }
    var classId : Int?
    var sectionID : Int?
    var classModel: ClassModel?
    var sectionModel: Section?
    var fromDate:String?
    var selectedDate:Date?
    
   
    let classDropDown = DropDown()
    let sectionDropDown = DropDown()
    var delegate: sendSelectedDetailsDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collStudent.delegate = self
        collStudent.dataSource = self
        
        txtClass.delegate = self
    txtSection.delegate = self
    
    self.collStudent.register(UINib(nibName: "SelectedStudentsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectedStudentsCollectionViewCell")
    self.setupDropDowns()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  //MARK: - Setup Drop Down
  func setupDropDowns() {
    
    setupClassDropDown()
    
    // setupSectionDropDown()
  }
  
  func setupClassDropDown() {
    classDropDown.anchorView = txtClass
    classDropDown.bottomOffset = CGPoint(x: 0, y: txtClass.bounds.height)
    // You can also use localizationKeysDataSource instead. Check the docs.
    classDropDown.dataSource = ["LKG","Pre KG","UKG"]
    classDropDown.selectionAction = { [weak self] (index, item) in
      self?.txtClass.text = item
    }
  }
  
  //MARK:- Show DropDown
  func showDropDown(sender : UITextField, content : [String]) {
    
    let dropDown = DropDown()
    dropDown.direction = .any
    dropDown.anchorView = sender
    dropDown.dismissMode = .automatic
    dropDown.dataSource = content
    
    dropDown.selectionAction = { (index: Int, item: String) in
      
      sender.text = item
      
      if sender == self.txtClass{
        
        self.classId = SharedPreferenceManager.shared.classNameListArray[index].id
//        if let _classId = SharedPreferenceManager.shared.classNameListArray.filter({$0.className == item}).map({$0.id}).first{
//          self.classId = _classId
//        }
        
        self.classModel = SharedPreferenceManager.shared.classNameListArray[index]
        
        
      }else{
        
        self.sectionID = SharedPreferenceManager.shared.sectionArray[index].id
        
        self.sectionModel = SharedPreferenceManager.shared.sectionArray[index]
      }
      
      guard let _classModel = self.classModel, let _sectionModel = self.sectionModel else {
          return
      }
      self.delegate?.getSelectedDetails(classID: self.classId!, sectionID: self.sectionID!, _classModel, _sectionModel)
    }
    
    dropDown.width = sender.frame.width
    dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
    dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
    
    if let visibleDropdown = DropDown.VisibleDropDown {
      
      visibleDropdown.dataSource = content
      
    }else {
      dropDown.show()
    }
  }
}


extension AddCommonActivityCell: UICollectionViewDataSource,UICollectionViewDelegate{
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return selectedUsers.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedStudentsCollectionViewCell", for: indexPath) as! SelectedStudentsCollectionViewCell
    cell.studentsNameLbl.text = selectedUsers[indexPath.row]
    return cell
  }
  
}

//MARK:- Collection View FlowLayout
extension AddCommonActivityCell: UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    
    let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
    let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
    let size:CGFloat = (collStudent.frame.size.width - space) / 2.0
    return CGSize(width: size, height: 50)
  }
}

//MARK- UITextFieldDelegate Methodes

extension AddCommonActivityCell : UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool{
    
    textField.resignFirstResponder()
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if (range.location == 0 && string == " ") {
      
      return false
    }
    return true
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    if textField == txtClass{
      
      showDropDown(sender: textField, content: SharedPreferenceManager.shared.classNameListArray.map({$0.className}))
      return false
      
    }else if textField == txtSection{
      
        showDropDown(sender: textField, content: SharedPreferenceManager.shared.sectionArray.map({$0.section!}))
        return false
    }
    
//    else if textField == dateTxtFld {
//        let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
//
//        picker.dismissBlock = { date in
//            self.selectedDate = date
//            //self.fromDateSelected = date
//            textField.text = date.asString(withFormat: "dd-MM-yyyy")
//            self.fromDate = date.asString(withFormat: "yyyy-MM-dd")
//
//        }
//        return false
//
//    }
    return true
    }
}
