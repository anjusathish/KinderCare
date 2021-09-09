//
//  AddWeeklyMealTableViewCell.swift
//  Kinder Care
//
//  Created by CIPL0668 on 17/01/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit

class AddWeeklyMealTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var coursesTxt: CTTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
