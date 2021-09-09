//
//  LeaveApprovalCell.swift
//  Kinder Care
//
//  Created by CIPL0023 on 13/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class LeaveApprovalCell: UITableViewCell {

    @IBOutlet weak var acceptRejectBaseView: UIView!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var approveBtn: UIButton!
    @IBOutlet weak var endYearLabel: UILabel!
    @IBOutlet weak var endDayMonthLabel: UILabel!
    @IBOutlet weak var startYearLabel: UILabel!
    @IBOutlet weak var startDayMonthLabel: UILabel!
    @IBOutlet weak var noOfDayLabel: UILabel!
    @IBOutlet weak var leaveTypleLabel: UILabel!
    @IBOutlet weak var classSectionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var acceptRejectSViw: UIStackView!
   
    @IBOutlet weak var showStatusLbl: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
