//
//  AddAttachmentCell.swift
//  Kinder Care
//
//  Created by CIPL0023 on 03/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class AddAttachmentCell: UITableViewCell {
  @IBOutlet weak var labelAddAttchement: UILabel!
  
  @IBOutlet weak var textfiekdImageName: CTTextField!
  @IBOutlet weak var buttonAddAttachment: UIButton!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
