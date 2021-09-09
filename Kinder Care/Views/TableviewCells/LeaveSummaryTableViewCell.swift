//
//  LeaveSummaryTableViewCell.swift
//  Kinder Care
//
//  Created by PraveenKumar R on 22/03/21.
//  Copyright © 2021 Athiban Ragunathan. All rights reserved.
//

import UIKit

class LeaveSummaryTableViewCell: UITableViewCell {
  
  @IBOutlet weak var labelLeaveType: UILabel!
  @IBOutlet weak var labelActualLeaveCount: UILabel!
  @IBOutlet weak var labelAppliedLeaveCount: UILabel!
  @IBOutlet weak var labelLeaveBalance: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
