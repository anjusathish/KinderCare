//
//  SelectSenderPopUpVC.swift
//  Kinder Care
//
//  Created by CIPL0668 on 19/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol SelectedUserDelegate: class {
  func selectedUserList(arrayUserList: [UserType])
}

class SelectSenderPopUpVC: UIViewController {
  
  @IBOutlet weak var userListTableView: UITableView!
  
//  var userTypeListArray = [["None","0"],["Admin","3"],["Teacher","4"],["Parent","6"]]
    
    var userTypeArrayList = ["Admin","Teacher","Student"]
  
  // var selectedArrayUserList:[[String]] = []
  
  var delegate: SelectedUserDelegate?
  
  var userTypeArray : [UserType] = []
  
  var selectedUserTypeArray: [UserType] = []
  
  //MARK:- ViewController LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if  let userType = UserManager.shared.currentUser?.userType {
    
      if let _type = UserType(rawValue:userType ) {
        
        switch _type {
          
        case .teacher: userTypeArray = [.student]
        
        case .parent: break
          
        case .admin:
            
            if UserManager.shared.currentUser?.permissions?.msgToParents == 0 {
                userTypeArray = [.admin,.teacher]
            }
            else if UserManager.shared.currentUser?.permissions?.msgToTeachers == 0 {
                userTypeArray = [.admin,.student]
            }
            else{
                userTypeArray = [.admin,.teacher,.student]
            }
          
        case .superadmin: userTypeArray = [.admin,.teacher,.student]
          
        case .all: break
          
        case .student: userTypeArray = [.admin,.teacher,.student]
          
        }
        
      }
    }
    
    userListTableView.register(UINib(nibName: "pleaseSelectTableViewCell", bundle: nil), forCellReuseIdentifier: "pleaseSelectTableViewCell")
    
    // let defaults = UserDefaults.standard
    //let myarray = defaults.s
    
  }
  
  //MARK:- UIButton Action Methodes
  @objc func selectBtnAction(_ sender : BEMCheckBox){
    
    if let cell = sender.superview?.superview?.superview as? pleaseSelectTableViewCell{
      
      guard let indexPath = userListTableView.indexPath(for: cell) else{
        return
      }
      
      if selectedUserTypeArray.contains(userTypeArray[indexPath.row]) {
        
        if let index = selectedUserTypeArray.firstIndex(where: {$0 == userTypeArray[indexPath.row]}){
          
          selectedUserTypeArray.remove(at: index)
        }
        
      }else{
        selectedUserTypeArray.append(userTypeArray[indexPath.row])
      }
      
      userListTableView.reloadData()
      
    }
  }
    
  @IBAction func applyBtnAction(_ sender: Any) {
    print(selectedUserTypeArray)
    delegate?.selectedUserList(arrayUserList: selectedUserTypeArray)
    self.dismiss(animated: true, completion: nil)
    
  }
  @IBAction func closeBtnAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}

//MARK:- UITableViewDelegate,UITableViewDataSource Methodes
extension SelectSenderPopUpVC : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return userTypeArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "pleaseSelectTableViewCell", for: indexPath) as! pleaseSelectTableViewCell
    
    cell.titleLabel.text = userTypeArray[indexPath.row].stringValue
    cell.bmCheckbox.tag = indexPath.row
    
    cell.bmCheckbox.addTarget(self, action: #selector(selectBtnAction(_:)), for: .valueChanged)
    
    if selectedUserTypeArray.contains(userTypeArray[indexPath.row]) {
      
      cell.bmCheckbox.on = true
      
    }else{
      cell.bmCheckbox.on = false
      //cell.bmCheckbox.tintColor = UIColor.lightGray
    }
    
    
    /* cell.selectionBtn.tag = indexPath.row
     
     cell.selectionBtn.addTarget(self, action: #selector(selectBtnAction(_:)), for: .touchUpInside)
     
     if selectedArrayUserList.contains(userTypeListArray[indexPath.row]) {
     
     cell.selectionBtn.tintColor = UIColor.ctBlue
     
     }else{
     cell.selectionBtn.tintColor = UIColor.lightGray
     }*/
    
    
    
    
    return cell
  }
  
  
}
