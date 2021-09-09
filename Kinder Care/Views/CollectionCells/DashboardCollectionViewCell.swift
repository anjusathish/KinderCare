//
//  DashboardCollectionViewCell.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 21/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit


class DashboardCollectionViewCell: UICollectionViewCell {

    @IBOutlet var InnerTitleLbl: UILabel!
    @IBOutlet var countLbl: UILabel!
    @IBOutlet var progressCircularView: KDCircularProgress!
    
    @IBOutlet var headingLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
