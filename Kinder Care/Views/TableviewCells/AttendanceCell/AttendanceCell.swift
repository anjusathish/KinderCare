//
//  AttendanceCell.swift
//  Kinder Care
//
//  Created by CIPL0023 on 21/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class AttendanceCell: UITableViewCell {
    
    @IBOutlet weak var signOutView: UIView!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var stackViewTime: UIStackView!
    @IBOutlet weak var btnPresentAbsent: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var inTime: UILabel!
    @IBOutlet weak var outTimeLbl: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
