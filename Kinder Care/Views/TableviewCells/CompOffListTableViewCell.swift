//
//  CompOffListTableViewCell.swift
//  Kinder Care
//
//  Created by CIPL0419 on 17/03/21.
//  Copyright © 2021 Athiban Ragunathan. All rights reserved.
//

import UIKit

class CompOffListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var labelCreaitDateYear: UILabel!
  @IBOutlet weak var labelCreaitDateDayMonth: UILabel!
  
  @IBOutlet weak var labelAppliateDateYear: UILabel!
  @IBOutlet weak var labelAppliateDateDayMonth: UILabel!
  
  @IBOutlet weak var labelReason: UILabel!
  @IBOutlet weak var btnStatus: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
