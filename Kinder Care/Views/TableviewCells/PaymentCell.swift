//
//  PaymentCell.swift
//  Kinder Care
//
//  Created by CIPL0023 on 19/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell {

    @IBOutlet weak var vwPaymentStatus: CTView!
    
    @IBOutlet weak var labelPaid: UILabel!
    @IBOutlet weak var btnDropdown: UIButton!
    @IBOutlet weak var term1: UIButton!
    @IBOutlet weak var term2: UIButton!
    @IBOutlet weak var term3: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPaymentStatusView(type: String){
        if type == "invoice"{
            vwPaymentStatus.isHidden = true
        }else{
            vwPaymentStatus.isHidden = true
        }
    }
    
}
