//
//  MealTableViewCell.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 27/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet var foodItemStackView: UIStackView!
    @IBOutlet var foodTypeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
