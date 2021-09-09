//
//  FamilyInfoTableViewCell.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 13/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class FamilyInfoTableViewCell: UITableViewCell {

    @IBOutlet var grayStackView: UIStackView!
    @IBOutlet weak var pickupNameLbl: UILabel!
    @IBOutlet weak var relationLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
