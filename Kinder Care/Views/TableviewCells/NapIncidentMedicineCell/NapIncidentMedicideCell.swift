//
//  NapIncidentMedicideCell.swift
//  Kinder Care
//
//  Created by CIPL0023 on 12/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class NapIncidentMedicideCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwAttachment: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func hideAttachment(strType: String){
        if strType == "Incident"{
         //   vwAttachment.isHidden = false
        }else{
         //   vwAttachment.isHidden = true
        }
    }
    
}
