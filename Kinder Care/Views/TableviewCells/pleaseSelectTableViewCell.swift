//
//  pleaseSelectTableViewCell.swift
//  Kinder Care
//
//  Created by CIPL0668 on 19/02/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit
import BEMCheckBox

class pleaseSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var selectionBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var bmCheckbox: BEMCheckBox!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
