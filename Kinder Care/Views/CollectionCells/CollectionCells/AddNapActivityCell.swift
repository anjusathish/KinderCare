//
//  AddNapActivityCell.swift
//  Kinder Care
//
//  Created by CIPL0023 on 27/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class AddNapActivityCell: UITableViewCell {

    @IBOutlet weak var vwStartTime: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vwEndTime: UIView!
    
    @IBOutlet weak var txtStartTime: CTTextField!
    @IBOutlet weak var txtEndTime: CTTextField!
    @IBOutlet weak var txtDate: CTTextField!
    
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSanitizer: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var lblTemperture: UILabel!
    @IBOutlet weak var txtTemperature: CTTextField!
    
    @IBOutlet weak var lblEndTime: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
