//
//  ViewExtension.swift
//  iJob
//
//  Created by Athiban Ragunathan on 02/03/18.
//  Copyright © 2018 Athiban Ragunathan. All rights reserved.
//

import UIKit

extension UIView{
    
    var globalPoint :CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }

    var globalFrame :CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}

extension UIViewController {
    
    func showDateTimePicker(mode : UIDatePicker.Mode, selectedDate : Date? = Date()) -> PickerViewController {
        
        let vc = UIStoryboard.attendanceStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        vc.mode = mode
        vc.currentDate = selectedDate
        present(controllerInSelf: vc)
        return vc
    }
    
    func present(controllerInSelf controller : UIViewController) {
        
        let popUpController = STPopupController(rootViewController: controller)
        popUpController.backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss(gesture:))))

        popUpController.hidesCloseButton = true
        popUpController.style = .bottomSheet
        popUpController.navigationBarHidden = true
        popUpController.containerView.backgroundColor = UIColor.clear
        popUpController.present(in: self)
    }
    
    @objc func dismiss(gesture:UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
