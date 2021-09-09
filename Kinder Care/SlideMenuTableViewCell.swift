//
//  SlideMenuTableViewCell.swift
//  Kinder Care
//
//  Created by CIPL0681 on 08/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class SlideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var labelMenu: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    
    @IBOutlet weak var trailingLabelCount: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
