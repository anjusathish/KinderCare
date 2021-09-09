//
//  MealCell.swift
//  Kinder Care
//
//  Created by CIPL0023 on 11/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class MealCell: UITableViewCell {

    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var foodNameLbl: UILabel!
    
    @IBOutlet weak var foodnameLblReal: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var foodNameStack: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
