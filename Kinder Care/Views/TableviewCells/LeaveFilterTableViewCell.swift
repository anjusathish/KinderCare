//
//  LeaveFilterTableViewCell.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 17/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import BEMCheckBox

class LeaveFilterTableViewCell: UITableViewCell {

    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet weak var selectedCheckBox: BEMCheckBox!
    //@IBOutlet var selectedButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
