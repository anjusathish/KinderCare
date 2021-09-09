//
//  CompOffApprovalTableViewCell.swift
//  Kinder Care
//
//  Created by PraveenKumar R on 22/03/21.
//  Copyright © 2021 Athiban Ragunathan. All rights reserved.
//

import UIKit

class CompOffApprovalTableViewCell: UITableViewCell {
  
  @IBOutlet weak var acceptRejectBaseView: UIView!
  @IBOutlet weak var rejectBtn: UIButton!
  @IBOutlet weak var approveBtn: UIButton!
  
  @IBOutlet weak var lblStartDate: UILabel!
  @IBOutlet weak var lblStartYear: UILabel!
  
  @IBOutlet weak var lblEndDate: UILabel!
  @IBOutlet weak var lblEndYear: UILabel!
  
  @IBOutlet weak var leaveTypleLabel: UILabel!
  @IBOutlet weak var showStatusLbl: UILabel!
  
  @IBOutlet weak var classSectionLabel: UILabel!
  
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var acceptRejectSViw: UIStackView!
  
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
