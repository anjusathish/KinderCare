//
//  ChildListTableViewCell.swift
//  Kinder Care
//
//  Created by Athiban Ragunathan on 21/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import BEMCheckBox

class ChildListTableViewCell: UITableViewCell {

    @IBOutlet var customView: CTView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var sectionlabel: UILabel!
    @IBOutlet weak var checkBox: BEMCheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.borderColor = UIColor.black.cgColor
    }
}
