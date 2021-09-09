//
//  PickUpPersonApprovalTableViewCell.swift
//  Kinder Care
//
//  Created by CIPL0590 on 12/4/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class PickUpPersonApprovalTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImgView: UIImageView!
    @IBOutlet weak var childNameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var classLbl: UILabel!
    @IBOutlet weak var fatherLbl: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var approveRejectStackViw: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
