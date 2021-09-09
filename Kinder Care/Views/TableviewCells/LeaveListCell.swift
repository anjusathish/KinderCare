//
//  LeaveListCell.swift
//  Kinder Care
//
//  Created by CIPL0023 on 13/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class LeaveListCell: UITableViewCell {

    //MARK:- Initialization
    @IBOutlet weak var imgLeaveType: UIImageView!
    @IBOutlet weak var lblLeaveType: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    
    @IBOutlet weak var lblDays: UILabel!
    
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblStartYear: UILabel!
    
    @IBOutlet weak var lblEndDate: UILabel!
     @IBOutlet weak var lblEndYear: UILabel!
  
    @IBOutlet weak var vwStatusView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK:- Change Leave List
    func leaveStatus(strType: String){
        self.btnStatus.setTitle(strType, for: .normal)
        
        if strType == "Pending"{
            vwStatusView.backgroundColor = UIColor.pendingColor.withAlphaComponent(0.15)
            btnStatus.backgroundColor = UIColor.pendingColor
        }else if strType == "Approved"{
            vwStatusView.backgroundColor = UIColor.approvedColor.withAlphaComponent(0.15)
            btnStatus.backgroundColor = UIColor.approvedColor
            
        }else{
            vwStatusView.backgroundColor = UIColor.rejectColor.withAlphaComponent(0.15)
            btnStatus.backgroundColor = UIColor.rejectColor
        }
    }
}
