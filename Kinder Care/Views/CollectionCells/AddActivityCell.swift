//
//  AddActivityCell.swift
//  Kinder Care
//
//  Created by CIPL0023 on 25/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class AddActivityCell: UICollectionViewCell {

    @IBOutlet weak var imgActivity: UIImageView!
    @IBOutlet weak var lblActivity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configUI(activity: String,image: String){
        self.lblActivity.text = "\(activity)"
        self.imgActivity.image = UIImage(named: image)
    }

}
