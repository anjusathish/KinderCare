//
//  AddMealActivityCell.swift
//  Kinder Care
//
//  Created by CIPL0023 on 29/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import DropDown

class AddMealActivityCell: RoundedBorderTableViewCell {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var txtMeal: CTTextField!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
