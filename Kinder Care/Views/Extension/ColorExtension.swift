//
//  ColorExtension.swift
//  Customer
//
//  Created by Athiban Ragunathan on 24/11/17.
//  Copyright © 2017 Athiban Ragunathan. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var ctBlue = UIColor(hex: 0x523CC0, alpha: 1.0)
    static var ctYellow = UIColor(hex: 0xF29C12, alpha: 1.0)
    static var ctGray = UIColor(hex: 0xF6F6F6, alpha: 1.0)
    static var ctGrgeen = UIColor(hex: 0x20B8AB, alpha: 1.0)
    static var ctBorderGray = UIColor(hex: 0xF4F4F4, alpha: 1.0)
    static var ctMenuGray = UIColor(hex: 0x7E98A4, alpha: 1.0)
    static var ctBorderLightGray = UIColor(hex: 0xC4C4C4, alpha: 1.0)
    static var ctMenuGraySelected = UIColor(hex: 0x3E4A57, alpha: 1.0)
    static var ctPending = UIColor(hex: 0xF39C12, alpha: 1.0)
    static var ctApproved = UIColor(hex: 0x2ECC71, alpha: 1.0)
    static var ctRejected = UIColor(hex: 0xE5583C, alpha: 1.0)
    static var ctDarkGray = UIColor(hex: 0x42484D,alpha:1.0)
    static var ctMessageHighlighted = UIColor(hex: 0xF4F2FA,alpha:1.0)


  
    convenience init(hex: UInt32, alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hex & 0xFF00) >> 8)/256.0
        let blue = CGFloat(hex & 0xFF)/256.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
