//
//  MessageTableViewCell.swift
//  Kinder Care
//
//  Created by CIPL0681 on 14/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewAttachment: UIView!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var mainView: CTView!
    
    @IBOutlet weak var attachmentIconImgView: UIImageView!
    
    @IBOutlet weak var indicationBtn: UIButton!
    
    @IBOutlet weak var mainStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
