//
//  ProfileVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 15/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import SDWebImage


enum Gender : Int {
  case Male = 1
  case Female = 2
}

class ProfileVC: BaseViewController {
  
  //MARK:- Initialization
  @IBOutlet weak var contentView: TopCurvedView!
  @IBOutlet weak var profileImage: UIImageView!
  
  @IBOutlet weak var passwordLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var dobLabel: UILabel!
  @IBOutlet weak var phoneNumberLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sanitizerButton: CTButton!
    
  lazy var viewModel : ProfileViewModel =  {
    return ProfileViewModel()
  }()
  
  var profileDetails : ProfileData?
  
  //MARK:- View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    titleString = "PROFLIE"
    viewModel.delegate = self
    
    profileDetails = UserProfile.shared.currentUser
    setProfileValues()
    self.configureUI()
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageUploadTapped(tapGestureRecognizer:)))
    profileImage.isUserInteractionEnabled = true
    profileImage.addGestureRecognizer(tapGestureRecognizer)
  }
  
  override func viewWillAppear(_ animated: Bool) {
  }
  
    @IBAction func btnSanitizer(_ sender: Any) {
        
    }
    @objc func imageUploadTapped(tapGestureRecognizer: UITapGestureRecognizer){
    
  }
  
  //MARK:- SetProfileValues
  func setProfileValues(){
    
    if let _fname = profileDetails?.firstname {
      nameLabel.text = _fname
    }
    
    if let lname = profileDetails?.lastname{
      if let name = nameLabel.text {
        nameLabel.text = name + " " + lname
      }
    }
    
    if let img =  profileDetails?.profile{
      
      let imgPath = ImageURL.imageBasePath + img
      
      if let urlString = imgPath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
        if let url = URL(string: urlString) {
          profileImage.sd_setImage(with: url)
        }
      }
      
    }else{
      
      if let img = UserManager.shared.currentUser?.profile{
        
        if let urlString = img.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
          if let url = URL(string: urlString) {
            profileImage.sd_setImage(with: url)
          }
        }
      }
    }
    
    if let phn = profileDetails?.contact {
      phoneNumberLabel.text = phn
    }
    
    if let email = profileDetails?.email {
      emailLabel.text = email
    }
    
    if let dob = profileDetails?.dateOfBirth {
        print(dob)
      dobLabel.text = dob.getDateAsStringWith(inFormat: "yyyy-MM-dd", outFormat: "dd-MM-yyyy")
    }
    
    if let address = profileDetails?.address {
      addressLabel.text = address
    }
   
    if let gender =  profileDetails?.gender {
      let  genderValue = Gender(rawValue: gender)
      switch genderValue {
      case .Male:
        genderLabel.text = "Male"
        break
      case .Female :
        genderLabel.text = "Female"
        break
      default:
        break
      }
    }
  }
  
  override func viewDidLayoutSubviews() {
    profileImage.layer.borderWidth = 1
    profileImage.layer.borderColor = UIColor.white.cgColor
    
  }
    
  
    func configureUI(){
        
        if  let userType = UserManager.shared.currentUser?.userType {
            if let _type = UserType(rawValue:userType ) {
                
                switch  _type  {
                case .all,.student : break
                case .admin, .parent ,.superadmin:
                    self.sanitizerButton.isHidden = true
                    break
                case .teacher :
                    self.sanitizerButton.isHidden = true
                    break
                    
                    
                    
                }
            }
        }
        
    }
  //MARK:- Button Action
  @IBAction func editProfile(_ sender: Any) {
    let vc = UIStoryboard.profileStoryboard().instantiateViewController(withIdentifier:"EditProfileVC") as! EditProfileVC
    vc.profileDetails = profileDetails
    vc.delegate = self
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func changeAction(_ sender: UIButton) {
    let vc = UIStoryboard.profileStoryboard().instantiateViewController(withIdentifier:"ChangePasswordVC") as! ChangePasswordVC
    vc.profileDetails = profileDetails
    vc.delegate = self
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

extension ProfileVC : profileDelegate {
    func healthViewSuccess(viewHealth: [viewHealth]) {
        
    }
    
    func editProfileData(message: String) {
        
    }
    
    func changePasswordSuccessfully(message: String) {
        
    }
    
    func healthStatusListSuccess(listHealth: [ListHelath]) {
        
    }
    
    func healthAddSuccuess(message:String) {
        
    }
    
    func healthDeleteSuccess(message: String) {
        
    }
    
  
  
  
  func getProfileData(profileData: ProfileData) {
    
    profileDetails = profileData
    if let profile = profileDetails?.profile {
      UserManager.shared.currentUser?.profile = ImageURL.imageBasePath + profile
    }
    setProfileValues()        
  }
  
  func failure(message: String) {
    displayServerError(withMessage: message)
  }
}

extension ProfileVC : refreshProfileDetailsDelegate {
  
  func refreshProfile() {
    
    if let _userid = UserManager.shared.currentUser?.userID {
      viewModel.getProfileData(userID: String(_userid))
    }
  }
}
