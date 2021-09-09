//
//  HealthStatusListViewController.swift
//  Kinder Care
//
//  Created by CIPL0590 on 6/26/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit

class HealthStatusListViewController: BaseViewController {

    @IBOutlet weak var healthListTableView: UITableView!
    var healthListArray = [ListHelath]()
    
    lazy var viewModel : ProfileViewModel   =  {
        return ProfileViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        self.titleString = "VIEW HEALTH STATUS"
        viewModel.healthStatusList(from_date: Date().getasString(inFormat: "yyyy-MM-dd"), to_date: Date().getasString(inFormat: "yyyy-MM-dd"))
       
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HealthStatusAddViewController") as! HealthStatusAddViewController
        vc.delegate = self 
        self.navigationController?.pushViewController(vc, animated: true)

    }
    

}

extension HealthStatusListViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return healthListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HealthStatusListTableViewCell", for: indexPath as IndexPath) as! HealthStatusListTableViewCell
        cell.lblTemperature.text = "\(healthListArray[indexPath.row].temp)" + " Celsius"
        cell.lblTime.text = healthListArray[indexPath.row].createdAt  
        if healthListArray[indexPath.row].santizer == 1{
                  cell.lblSanitizer.text = "Yes"
        }
        else{
                  cell.lblSanitizer.text = "NO"
        }

        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let id = healthListArray[indexPath.row].id
        viewModel.healthDeleteStatus(id: "\(id)")
        print("jdsajksd")
    }
    
    
}

extension HealthStatusListViewController:profileDelegate{
    func healthViewSuccess(viewHealth: [viewHealth]) {
        
    }
    
    func editProfileData(message: String) {
        
    }
    
    func changePasswordSuccessfully(message: String) {
        
    }
    
    
    
    func getProfileData(profileData: ProfileData) {
        
    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
    
   
   
    
    func healthStatusListSuccess(listHealth: [ListHelath]) {
        self.healthListArray = listHealth
        self.healthListTableView.reloadData()
    }
    
    func healthAddSuccuess(message:String) {
        
    }
    
    func healthDeleteSuccess(message: String) {
        self.displayServerSuccess(withMessage: message)
        self.healthListTableView.reloadData()
        viewModel.healthStatusList(from_date: Date().getasString(inFormat: "yyyy-MM-dd"), to_date: Date().getasString(inFormat: "yyyy-MM-dd"))
    }
    
    
}
extension HealthStatusListViewController:refreshHealthTableViewDelegate{
    func refreshHealthTableView() {
        
        viewModel.healthStatusList(from_date: Date().getasString(inFormat: "yyyy-MM-dd"), to_date: Date().getasString(inFormat: "yyyy-MM-dd"))
        
    }
    
    
}
