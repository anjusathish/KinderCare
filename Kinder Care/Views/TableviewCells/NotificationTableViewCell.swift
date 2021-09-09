//
//  NotificationTableViewCell.swift
//  Kinder Care
//
//  Created by CIPL0681 on 25/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import BEMCheckBox

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var activeCircle: BEMCheckBox!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelRequest: UILabel!
    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
