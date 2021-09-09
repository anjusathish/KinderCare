//
//  AssignedTableViewCell.swift
//  Kinder Care
//
//  Created by CIPL0590 on 7/1/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit

class AssignedTableViewCell: UITableViewCell {

    @IBOutlet weak var teacherLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var teacher1StLbl: UILabel!
    @IBOutlet weak var email2Lbl: UILabel!
    @IBOutlet weak var contact3rdLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
