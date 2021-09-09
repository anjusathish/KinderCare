//
//  BaseViewController.swift
//  Clear Thinking
//
//  Created by Athiban Ragunathan on 05/07/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation
import UIKit
import TTGSnackbar
import Photos

enum ErrorMessage : String {
    
    case invalidEmail = "Please enter a valid email"
    case invalidOTP = "Please enter a valid OTP"
    case invalidFirstName = "Please enter a valid First Name"
    case invalidLastName = "Please enter a valid Last Name"
    case invalidPassword = "Please enter a valid Password"
     case invalidNewPassword = "Please enter a New Password"
    case invalidPasswordMismatch = "Password & Confirm Password doesn't match"
    case invalidArea = "Please select the area"
    case invalidDOB = "Please select your date of birth"
    case invalidCode = "Please select the country"
    case invalidMobileNumber = "Please enter valid mobile number"
    case advSearch = "Please select a search option or use quick search"
    case terms = "Please agree to the Terms & Condition"
    case invalidZipcode = "Please enter a valid Zip code"
    case invalidSuggestion = "Please enter your Suggestion"
    case invalidQuote = "Please enter your Quote"
    case invalidTopic = "Please choose your topic"
    case invalidKeyword = "Please Enter your keyword"
    case invalidAuthor = "Please choose your AuthorName"
    case invalidMisconception = "Please choose your Misconception"
    case topicLimit = "Maximum topics selected, remove one to select new topic"
    case oneTimeSubscription = "Please choose either one subscription"
    case enterPrice = "Please choose money else enter the Money"
    case invalidName = "Please enter a valid Name"
    case invalidAddress = "Please Enter Address"
    case invalidCity = "Please Enter City"
    case invalidstate = "Please Enter State"
    case invalidNotes = "Please Enter Notes"
    case invalidCountry = "Please Enter Country"
    case invalidPaymentUrl = "Invalid Payment Url, Please try again later"
    case invalidAuthorCategory = "Please select author category"
    case invalidPostalCode = "Please Enter Valid Postal Code"
    case selectTopic = "Please select atleast one topic"
    case selectRetailer = "Please select atleast one Retailer"
    case selectProfilePicture = "Please select Profile Picture"
    case userAlreadyAssignMessage = "User is already assigned with this property"
    case energyPlan = "Please select atleast one Energy Plan"
    case property = "No Appliances assigned for this property"
    case age = "Please Enter  Age"
    case dob = "Please Select Date Of Birth"
    case className = "Please Select Class"
    case validChildName = "Please Enter Child Name"
    case fatherName = "Please Enter Father Name"
    case motherName = "Please Enter Mother Name"
    case selectSentToUsers = "Please Select Sent To Users and Email"
    case selectSentUsersEmail = "Please Enter Email"
    case leaveFromDate = "Please select Leave From Date"
    case leaveToDate = "Please select Leave Till Date"
    case leaveType = "Please select Leave Type"
    case reasonforleave = "Please Enter Reason for Leave"
    case emergencyContact = "Please Enter Emergency Contact"
    case subject = "Please Enter Subject"
    case message = "Please Enter Message"
    case selectMeal = "Please select a menu item before adding another"
    case selectMenu = "Please add a menu to proceed further"
    case purpose = "Please Select Purpose"
    case selectDate = "Please select date"
    case selectStudent = "Please Select any one Student"
    case selectTeacher = "Please Select any one Teacher"
    case coursesAdded = "All available courses have been added"
    case selectClassAndSection = "Please select Class and Section"
    case selectGender = "Please Select Gender"
    case description = "Please Enter Description"
    case temperature = "Please Enter Temperature"
    case startTime  = "Please Select Time"
}

class BaseViewController: UIViewController {
    
    private let snackbar = TTGSnackbar()
    
    var topBarHeight : CGFloat = 60
    var safeAreaHeight : CGFloat {
        get {
            if let window = UIApplication.shared.windows.first {
                return window.safeAreaInsets.top
            }
            return 0.0
        }
    }
    
    var titleString : String = "" {
        didSet {
            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: topBarHeight + safeAreaHeight))
            titleView.backgroundColor = UIColor.clear
            
            let bgImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height))
            bgImageView.image = UIImage(named: "Top Purple BG")
            bgImageView.contentMode = .scaleAspectFill
            bgImageView.clipsToBounds = true
            
            let rectShape = CAShapeLayer()
            rectShape.bounds = bgImageView.frame
            rectShape.position = bgImageView.center
            rectShape.path = UIBezierPath(roundedRect: bgImageView.bounds, byRoundingCorners: [.bottomLeft], cornerRadii: CGSize(width: 30, height: 30)).cgPath
            bgImageView.layer.mask = rectShape
            
            titleView.addSubview(bgImageView)
            
            self.view.addSubview(titleView)
            
            let menuButton = UIButton(frame: CGRect(x: 16, y: 16 + safeAreaHeight, width: 30, height: 30))
            
            if let controller = self.navigationController?.viewControllers.last {
                
                if !(controller is RootViewController) {
                    showBackIcon = true
                    menuButton.setImage(UIImage(named: "backIcon"), for: .normal)
                    menuButton.tintColor = UIColor.white
                }
                else {
                    menuButton.setImage(UIImage(named: "menu-three-horizontal-lines-symbol"), for: .normal)
                }
            }
            else {
                menuButton.setImage(UIImage(named: "menu-three-horizontal-lines-symbol"), for: .normal)
            }
            
            menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
            titleView.addSubview(menuButton)
            
            let notificationButton = UIButton(frame: CGRect(x: self.view.frame.width - (16 + 30), y: 10 + safeAreaHeight, width: 30, height: 30))
            notificationButton.addTarget(self, action: #selector(notificationAction(sender:)), for: .touchUpInside)
            notificationButton.setImage(UIImage(named: "bell"), for: .normal)
            titleView.addSubview(notificationButton)
            
            if let controller = self.navigationController?.viewControllers.last {
                
                if controller is NotificationVC  || controller is MealActivityVC || controller is NapActivityVC || controller is IncidentDailyActivityVC || controller is MedicineDailyActivityVC || controller is ClassRoomDailyActivityVC || controller is BathroomDailyActivityVC  || controller is PhotoDailyActivityVC {
                    notificationButton.removeFromSuperview()
                }
              
            }
            
            let titleLabel = UILabel(frame: CGRect(x: 76, y: 15 + safeAreaHeight, width: self.view.frame.width - (76 + 76), height: 30))
            titleLabel.text = titleString
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.textColor = UIColor.white
            titleView.addSubview(titleLabel)
            
            adjustConstraint()
        }
    }
    
    var showBackIcon : Bool = false
    
    var segmentToPlaceOnTopOfTopBar : CTSegmentControl? {
        didSet {
            adjustConstraint()
        }
    }
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if !titleString.isEmpty {
            adjustConstraint()
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            if notification.name == UIResponder.keyboardWillHideNotification {
                // snackbar.bottomMargin = 4
            }
            else {
                // snackbar.bottomMargin = keyboardRectangle.height + 4
            }
        }
    }
    
    @objc func menuButtonAction(sender : UIButton) {
        
        if showBackIcon {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.sideMenuViewController.presentLeftMenuViewController()
        }
    }
    
    @objc func notificationAction(sender : UIButton) {
        
        let notificationVC = UIStoryboard.notificationStoryboard().instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }

    func adjustConstraint() {
        
        for contstraint in self.view.constraints {
            if isTopConstraint(constraint: contstraint) {
                
                if let segment = segmentToPlaceOnTopOfTopBar {
                    contstraint.constant = ((topBarHeight) + safeAreaHeight) - segment.frame.height/2
                    self.view.bringSubviewToFront(segment)
                }
                else {
                    contstraint.constant += (topBarHeight + safeAreaHeight)
                }
                break
            }
        }
    }
    
    func isTopConstraint(constraint : NSLayoutConstraint) -> Bool {
        
        return firstTopConstraint(constraint: constraint) || secondTopConstraint(constraint: constraint)
    }
    
    func firstTopConstraint(constraint : NSLayoutConstraint) -> Bool {
        
        if let firstItem = constraint.firstItem as? UIView {
            return firstItem == self.view && constraint.firstAttribute == NSLayoutConstraint.Attribute.top
        }
        return false
    }
    
    func secondTopConstraint(constraint : NSLayoutConstraint) -> Bool {
        
        if let secondItem = constraint.secondItem as? UIView {
            return secondItem == self.view && constraint.secondAttribute == NSLayoutConstraint.Attribute.top
        }
        return false
    }
    func downloadVideoLinkAndCreateAsset(_ videoLink: String) {
        
        // use guard to make sure you have a valid url
        guard let videoURL = URL(string: videoLink) else { return }
        
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // check if the file already exist at the destination folder if you don't want to download it twice
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent).path) {
            
            // set up your download task
            URLSession.shared.downloadTask(with: videoURL) { (location, response, error) -> Void in
                
                // use guard to unwrap your optional url
                guard let location = location else { return }
                
                // create a deatination url with the server response suggested file name
                let destinationURL = documentsDirectoryURL.appendingPathComponent(response?.suggestedFilename ?? videoURL.lastPathComponent)
                
                do {
                    
                    try FileManager.default.moveItem(at: location, to: destinationURL)
                    
                    PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in
                        DispatchQueue.main.async
                            {
                                showAlertView(title: "Success", msg: "File Downlaoded successfully!", controller: self) {
                                    
                                }
                        }

                        // check if user authorized access photos for your app
                        if authorizationStatus == .authorized {
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destinationURL)}) { completed, error in
                                    //                                    if completed {
//                                    DispatchQueue.main.async
//                                        {
//                                            showAlertView(title: "Success", msg: "File Downlaoded successfully!", controller: self) {
//
//                                            }
//                                    }
                                    
                                    //                                    } else {
                                    //                                        print(error)
                                    //                                    }
                            }
                        }
                    })
                    
                } catch { print(error) }
                
            }.resume()
            
        } else {
            print("File already exists at destination url")
            showAlertView(title: "Alert", msg: "This file already exists at your Media Library", controller: self) {
                
            }
            
        }
        
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

//extension BaseViewController {
//
//    func displayServerSuccess(withMessage message : String){
//        snackbar.duration = .middle
//        snackbar.message = message.replacingOccurrences(of: "message", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "\"", with: "")
//        snackbar.show()
//    }
//
//    func displayServerError(withMessage message : String) {
//        snackbar.duration = .middle
//        snackbar.message = message.replacingOccurrences(of: "message(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "\"", with: "")
//        snackbar.show()
//    }
//
//    func displayError(withMessage message : ErrorMessage) {
//        snackbar.duration = .middle
//        snackbar.message = message.rawValue
//        snackbar.show()
//    }
//}

extension BaseViewController {
    
    func displayServerSuccess(withMessage message : String){
        snackbar.duration = .middle
        snackbar.message = message.replacingOccurrences(of: "message", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "\"", with: "")
        snackbar.show()
    }
    
    func displayServerError(withMessage message : String) {
        snackbar.duration = .middle
        snackbar.message = message.replacingOccurrences(of: "message(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "\"", with: "")
        snackbar.show()
    }
    
    func displayError(withMessage message : ErrorMessage) {
        snackbar.duration = .middle
        snackbar.message = message.rawValue
        snackbar.show()
    }
}
