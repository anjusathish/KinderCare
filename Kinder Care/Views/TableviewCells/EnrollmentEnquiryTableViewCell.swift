//
//  EnrollmentEnquiryTableViewCell.swift
//  Kinder Care
//
//  Created by CIPL0590 on 12/3/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class EnrollmentEnquiryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var subNameLbl: UILabel!
    
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
