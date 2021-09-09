//
//  ActivityDetailsTimeTableViewCell.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 28/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class ActivityDetailsTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var labelActivityDetail: UILabel!
    @IBOutlet weak var labelClassRoomActivity: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var catergoryStackView: UIStackView!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelStartTime: UILabel!
    @IBOutlet var editBtn: UIButton!
    
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
