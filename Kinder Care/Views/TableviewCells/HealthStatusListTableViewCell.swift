//
//  HealthStatusListTableViewCell.swift
//  Kinder Care
//
//  Created by CIPL0590 on 6/26/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit

class HealthStatusListTableViewCell: UITableViewCell {
    @IBOutlet weak var lblSanitizer: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
