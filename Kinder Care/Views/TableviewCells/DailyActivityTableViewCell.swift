//
//  DailyActivityTableViewCell.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 25/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class DailyActivityTableViewCell: UITableViewCell {

    @IBOutlet var statusBtn: UIButton!
    @IBOutlet var activityImgView: UIImageView!
    @IBOutlet var activityLbl: UILabel!
    @IBOutlet var classSectionLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
