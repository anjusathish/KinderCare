//
//  AssignedTeacherViewController.swift
//  Kinder Care
//
//  Created by CIPL0590 on 7/1/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit

class AssignedTeacherViewController: BaseViewController {
    
    @IBOutlet weak var childDropDown: ChildDropDown!
    @IBOutlet weak var assignedTableView: UITableView!
    
    var teacherListArray = [AssignedTeacher]()
    var childNameArray = [ChildName]()
    var childNameID:Int?
    
    lazy var viewModel : familyInformationViewModel = {
        return familyInformationViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBarHeight = 100
        titleString = "ASSIGNED TEACHER"
        viewModel.delegate = self
        
        if let childName = UserManager.shared.childNameList {
            childNameArray = childName
            self.childNameID = childNameArray.map({$0.id}).first
        }
        self.view.bringSubviewToFront(childDropDown)
        childNameDropDown()
        
        if let childId = childNameID{
            viewModel.familyDetail(student_id: childId)
        }
        
    }
    
    func childNameDropDown(){
        
        childDropDown.titleArray = childNameArray.map({$0.name})
         childDropDown.subtitleArray = childNameArray.map({$0.className + " , " + $0.section + " Section"})
        if childNameArray.count > 1 {
        childDropDown.selectionAction = { (index : Int) in
            print(index)
            self.childNameID = self.childNameArray[index].id
            
            if let childId = self.childNameID {
                self.viewModel.familyDetail(student_id: childId)
            }
            
        }}
        else{
            childDropDown.isUserInteractionEnabled = false
        }
        
        childDropDown.addChildAction = { (sender : UIButton) in
            let vc = UIStoryboard.FamilyInformationStoryboard().instantiateViewController(withIdentifier:"AddChildVC") as! AddChildVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
}

extension AssignedTeacherViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teacherListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignedTableViewCell", for: indexPath as IndexPath) as! AssignedTableViewCell
        cell.teacherLbl.text = teacherListArray[indexPath.row].name
      //  cell.contactLbl.text = teacherListArray[indexPath.row].contactNo
       // cell.emailLbl.text = teacherListArray[indexPath.row].email
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "AssignedTeacherViewVC") as! AssignedTeacherViewVC
        secondViewController.id = teacherListArray[indexPath.row].id
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    
}

extension AssignedTeacherViewController: familyInformationDelegate{
    func paymentList(paymentList: [PaymentListData]) {
        
    }
    
    
    
    func familyDetailsList(familyDetails: FamilyInformationData?) {
        self.teacherListArray = (familyDetails?.assignedTeachers)!
        self.assignedTableView.reloadData()
    }
    
    func editPickupSuccess() {
        
    }
    
    func failure(message: String) {
        displayServerSuccess(withMessage: message)
    }
    
    
}
