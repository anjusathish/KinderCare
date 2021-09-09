//
//  ChangePasswordVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 14/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseViewController {

    @IBOutlet weak var conPasswordText: CTTextField!
    @IBOutlet weak var newPswdText: CTTextField!
    @IBOutlet weak var oldPswdText: CTTextField!
    //MARK:- Initialization
    @IBOutlet weak var contentView: TopCurvedView!
    
    @IBOutlet weak var topContactLabel: UILabel!
    @IBOutlet weak var topEmailLabel: UILabel!
    @IBOutlet weak var topNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    lazy var viewModel : ProfileViewModel   =  {
        return ProfileViewModel()
    }()
    var profileDetails : ProfileData?
    var Firstname : String = " "
    var emailAddress : String = " "
    var lastName:String?
    var institudeName:String?
    var dob:String?
    var gender:String?
    var contact:String?
    var address:String?
    var delegate:refreshProfileDetailsDelegate?
    
    //MARK:- View Life Cycle
       override func viewDidLoad() {
           super.viewDidLoad()
        titleString = "CHANGE PASSWORD"
       
        viewModel.delegate = self
        
        if let institudeName = UserManager.shared.currentUser?.instituteName {
                   self.institudeName = institudeName
               }
        
        if let _userid = UserManager.shared.currentUser?.userID {
                   viewModel.getProfileData(userID: String(_userid))
               }
           // Do any additional setup after loading the view.
       }
    
    override func viewDidLayoutSubviews() {
           profileImage.layer.borderWidth = 1
           profileImage.layer.borderColor = UIColor.white.cgColor
           
       }
       
       //MARK:- Local Methods
       func setProfileValues()
          {
            if let fname = profileDetails?.firstname {
                topNameLabel.text = fname
           }
            if let lname = profileDetails?.lastname {
                if let topname = topNameLabel.text {
                topNameLabel.text = topname + " " + lname
                      }
            }
           
           if let phn = profileDetails?.contact{
            topContactLabel.text = phn
                 }
           if let email = profileDetails?.email{
            topEmailLabel.text = email
           }
      if let img = UserManager.shared.currentUser?.profile{
                  print("Image :",img)
            if let urlString = img.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
                if let url = URL(string: urlString) {
               profileImage.sd_setImage(with: url)
            }
            }

        }
          
       }
       
    //MARK:- Button Action
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func updateAction(_ sender: UIButton) {

        guard let old_password = oldPswdText.text, !old_password.removeWhiteSpace().isEmpty else {
            displayError(withMessage: .invalidPassword)
                  return
              }
        guard let new_password = newPswdText.text, !new_password.removeWhiteSpace().isEmpty else {
                  displayError(withMessage: .invalidNewPassword)
                        return
                    }
        guard let con_password = conPasswordText.text, con_password.removeWhiteSpace() == new_password else {
            displayError(withMessage: .invalidPasswordMismatch)
              return
          }
              
        if let name = profileDetails?.firstname {
           lastName = name
             print(name)
        }
        if let email = topEmailLabel.text {
                   emailAddress = email
               }
        if let gender = profileDetails?.gender{
            self.gender = "\(gender)"
        }
        if let dob = profileDetails?.dateOfBirth{
            self.dob = dob
        }
        if let contact = profileDetails?.contact{
            self.contact = contact
        }
        if let address = profileDetails?.address{
            self.address = address
        }
       
        
          
        viewModel.changePassword(method: "PUT", firstname: lastName ?? "", email: emailAddress, old_password: old_password, password: new_password, con_password: con_password, dob: dob ?? "", gender: gender ?? "", contact: contact ?? "", instituteName: institudeName ?? "", address: address ?? "")
            
    }
}

extension ChangePasswordVC : profileDelegate {
    func healthViewSuccess(viewHealth: [viewHealth]) {
        
    }
    
    func editProfileData(message: String) {
        
    }
    
    
    
    func healthStatusListSuccess(listHealth: [ListHelath]) {
        
    }
    
    func healthAddSuccuess(message:String) {
        
    }
    
    func healthDeleteSuccess(message: String) {
        
    }
    
    func getProfileData(profileData: ProfileData) {
        print(profileData)
        profileDetails = profileData
         setProfileValues()
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
    }
    
    func changePasswordSuccessfully(message: String) {
        
           displayServerSuccess(withMessage: message)
        let viewController = UIStoryboard.onBoardingStoryboard().instantiateViewController(withIdentifier: "LoginVC")
        let navController = UINavigationController(rootViewController: viewController)
        navController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navController
        
//         self.delegate?.refreshProfile()
//        self.navigationController?.popViewController(animated: true)
    
    }
    
    
}
