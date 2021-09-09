//
//  TextfieldExtension.swift
//  iJob
//
//  Created by Athiban Ragunathan on 24/02/18.
//  Copyright © 2018 Athiban Ragunathan. All rights reserved.
//

import UIKit

extension UITextField {
    
    func addImage(image : UIImage) {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.leftView = imageView
        self.leftViewMode = .always
        self.tintColor = UIColor.ctBlue
    }
    
    func addRightImage(image : UIImage) {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.rightView = imageView
        self.rightViewMode = .always
        self.tintColor = UIColor.ctBlue
    }
    
    func addRightLabelText(text : String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 15))
        label.text = text
        label.textColor = UIColor.ctBlue
        label.font = UIFont.systemFont(ofSize: 13)
        self.rightView = label
        self.rightViewMode = .always
        self.tintColor = UIColor.ctBlue
    }
}
