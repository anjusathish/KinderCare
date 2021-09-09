//
//  DailyActivityClassroomTableViewCell.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 07/01/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit

class DailyActivityClassroomTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var milestoneLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityTitleLabel: UILabel!
    @IBOutlet weak var attachView: AttachmentView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
