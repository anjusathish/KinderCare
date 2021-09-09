//
//  ReportsTableViewCell.swift
//  Kinder Care
//
//  Created by CIPL0681 on 02/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class ReportsTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var labelAbsent: UILabel!
    @IBOutlet weak var labelPresent: UILabel!
    @IBOutlet weak var labelStudent: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var lblWorkingDays: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


