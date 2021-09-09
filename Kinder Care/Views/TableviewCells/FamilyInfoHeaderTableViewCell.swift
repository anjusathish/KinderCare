//
//  FamilyInfoHeaderTableViewCell.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 13/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class FamilyInfoHeaderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblFather: UILabel!
    @IBOutlet weak var lblMother: UILabel!
    @IBOutlet weak var lblPrimaryMail: UILabel!
    @IBOutlet weak var lblSecondaryMail: UILabel!
    @IBOutlet weak var lblFatherContact: UILabel!
    @IBOutlet weak var lblMotherContact: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
