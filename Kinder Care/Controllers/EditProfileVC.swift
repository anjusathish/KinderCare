//
//  EditProfileVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 14/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import SDWebImage
import DropDown

protocol refreshProfileDetailsDelegate {
    func refreshProfile()
}
class EditProfileVC: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //MARK:- Initialization
    
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var contactText: CTTextField!
    @IBOutlet weak var emailTxt: CTTextField!
    @IBOutlet weak var nameTxt: CTTextField!
    @IBOutlet weak var contentView: TopCurvedView!
    @IBOutlet weak var txtDateOfBirth: CTTextField!
    @IBOutlet weak var cameraImgView: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var txtGender: CTTextField!
    
    
    //Custom Picker Instance variable
    var genderArray = ["Male","Female"]
    var customPickerObj : CustomPicker!
    var selectedPicker  = ""
    var profileDetails : ProfileData?
    var genderValue:Int = 0
    var dobValue : String = ""
    var contactValue : String = ""
    var addressValue : String = ""
    var selectedImage : UIImage?
    var imagePicker = UIImagePickerController()
    var delegate:refreshProfileDetailsDelegate?
    var selectedDate:Date?
    var institudeName:String?
    lazy var viewModel : ProfileViewModel   =  {
        return ProfileViewModel()
    }()
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleString = "EDIT PROFILE"
        
        viewModel.delegate = self
        
        if let institudeName = UserManager.shared.currentUser?.instituteName {
            self.institudeName = institudeName
        }
        
        setProfileValues()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageUploadTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageUploadTapped(tapGestureRecognizer:)))
        cameraImgView.isUserInteractionEnabled = true
        cameraImgView.addGestureRecognizer(tapGestureRecognizer2)
        
    }
    
    override func viewDidLayoutSubviews() {
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.white.cgColor
        
    }
    
    //MARK:- Local Methods
    func setProfileValues()
    {
        if let fname = profileDetails?.firstname {
            nameTxt.text = fname
            nameLabel.text = fname
        }
        if let lname = profileDetails?.lastname {
            if let topname = nameTxt.text {
                nameTxt.text = topname + " " + lname
                nameLabel.text = topname + " " + lname
            }
        }
        
        if let gender = profileDetails?.gender {
            if  gender == 1 {
                txtGender.text = "Male"
            }
            else{
                txtGender.text = "Female"
            }
        }
        
        //        if let fname = profileDetails?.firstname, let lname = profileDetails?.lastname{
        //            nameTxt.text = fname + " " + lname
        //            nameLabel.text = fname + " " + lname
        //        }
        if let dob = profileDetails?.dateOfBirth{
            print(dob)
            txtDateOfBirth.text = dob.getDateAsStringWith(inFormat: "yyyy-MM-dd", outFormat: "dd-MM-yyyy")
        }
        if let address = profileDetails?.address{
            addressTextView.text = address
        }
        if let phn = profileDetails?.contact{
            contactText.text = phn
            contactLabel.text = phn
        }
        if let email = profileDetails?.email{
            emailTxt.text = email
            emailLabel.text = email
        }
        if let img = UserManager.shared.currentUser?.profile{
            print("Image :",img)
            if let urlString = img.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
                if let url = URL(string: urlString) {
                    profileImage.sd_setImage(with: url)
                }
            }
            
        }
        //
        //            let url = URL(string: img)
        //            if let data = try? Data(contentsOf: url!)
        //            {
        //                let  image = UIImage(data: data)
        //                profileImage.image = image
        //            }
        //        }
        if let gender =  profileDetails?.gender {
            genderValue = gender
        }
    }
    
    func showDropDown(sender : UITextField, content : [String]) {
        
        let dropDown = DropDown()
        dropDown.direction = .any
        dropDown.anchorView = sender // UIView or UIBarButtonItem
        dropDown.dismissMode = .automatic
        dropDown.dataSource = content
        
        dropDown.selectionAction = { (index: Int, item: String) in
            
            sender.text = item
            
            
            print(item)
        }
        dropDown.width = sender.frame.width
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        if let visibleDropdown = DropDown.VisibleDropDown {
            visibleDropdown.dataSource = content
        }
        else {
            dropDown.show()
        }
        
        
    }
    
    //MARK:- Button Action
    
    @IBAction func updateAction(_ sender: UIButton) {
        
        
        guard let name = nameTxt.text, !name.removeWhiteSpace().isEmpty else {
            displayError(withMessage: .invalidFirstName)
            return
        }
        
        guard let email = emailTxt.text, email.removeWhiteSpace().isValidEmail()else {
            displayError(withMessage: .invalidEmail)
            return
        }
        guard let dob = txtDateOfBirth.text, !dob.isEmpty else {
            displayError(withMessage: .invalidDOB)
            return
        }
        guard let contactNumber = contactText.text, contactNumber.removeWhiteSpace().isIndianPhoneNumber(), contactNumber.count >= 10 else {
            displayError(withMessage: .invalidMobileNumber)
            return
        }
        
        guard let  address = addressTextView.text, !address.isEmpty else {
            displayError(withMessage: .invalidAddress)
            return
        }
        guard var gender = txtGender.text, !gender.isEmpty else{
            displayError(withMessage: .selectGender)
            return
        }
        if gender == "Male"{
            gender = "1"
        }
        else{
            gender = "2"
        }
        
        
        if let institudeName = UserManager.shared.currentUser?.instituteName{
            self.institudeName = institudeName
        }
        
        
        viewModel.EditProfileData(method: "PUT", firstname: name, email: email, dob:dob , contact: contactNumber, address: address, gender: gender, instituteName: institudeName ?? "")
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func imageUploadTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if cameraImgView.image == UIImage(named: "tick") {
            if let image = selectedImage {
                viewModel.changeProfilePicture(method: "PUT", image: image)
            }
        }
        else {
            
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallery()
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            
            self.present(alert, animated: true, completion: nil)
        }
        //        else{
        //           if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
        //               print("Button capture")
        //
        //               imagePicker.delegate = self
        //               imagePicker.sourceType = .savedPhotosAlbum
        //               imagePicker.allowsEditing = false
        //
        //               present(imagePicker, animated: true, completion: nil)
        //           }
        //
        //       }
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let pickedImage = info[.originalImage] as? UIImage
        {
            
            profileImage.image = pickedImage
            selectedImage = pickedImage
            cameraImgView.image = UIImage(named: "tick")
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /*     if (range.location == 0 && string == " ") {
         return false;
         }
         return true*/
        
        if textField == contactText{
            let currentText = textField.text ?? ""
            
            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            // make sure the result is under 10 characters
            return updatedText.count <= 10
        }
        return false
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtDateOfBirth {
            let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
            picker.dismissBlock = { date in
                self.selectedDate = date
                self.txtDateOfBirth.text = date.asString(withFormat: "dd-MM-yyyy")
            }
            return false
            
        }
        else if textField == txtGender {
            showDropDown(sender: textField, content: genderArray)
            return false
        }
        
        return true
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

//MARK:- CustomPicker Methods


extension EditProfileVC : profileDelegate {
    func healthViewSuccess(viewHealth: [viewHealth]) {
        
    }
    func healthStatusListSuccess(listHealth: [ListHelath]) {
        
    }
    
    func healthAddSuccuess(message:String) {
        
    }
    
    func healthDeleteSuccess(message: String) {
        
    }
    
    
    
    func changePasswordSuccessfully(message: String) {
        let viewController = UIStoryboard.onBoardingStoryboard().instantiateViewController(withIdentifier: "LoginVC")
        let navController = UINavigationController(rootViewController: viewController)
        navController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navController
//        displayServerSuccess(withMessage: message)
//        self.delegate?.refreshProfile()
//        self.navigationController?.popViewController(animated: true)
    }
    
    func getProfileData(profileData: ProfileData) {
        print("")
    }
    
    func failure(message: String) {
        displayServerSuccess(withMessage: message)
    }
    
    func editProfileData(message: String) {
        
//        displayServerSuccess(withMessage: message)
//        self.delegate?.refreshProfile()
//        self.navigationController?.popViewController(animated: true)
//
        
    }
    
    
}
