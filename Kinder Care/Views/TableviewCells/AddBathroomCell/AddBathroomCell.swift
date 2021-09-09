//
//  AddBathroomCell.swift
//  Kinder Care
//
//  Created by CIPL0023 on 28/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class AddBathroomCell: UITableViewCell {
  
  @IBOutlet weak var txtType: CTTextField!
  @IBOutlet weak var txtStartTime: CTTextField!
  @IBOutlet weak var txtEndTime: CTTextField!
  @IBOutlet weak var buttonYes: UIButton!
  @IBOutlet weak var buttonNo: UIButton!
    @IBOutlet weak var dateTxtFld: CTTextField!
    
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
