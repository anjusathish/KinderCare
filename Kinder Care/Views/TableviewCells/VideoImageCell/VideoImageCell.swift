//
//  VideoImageCell.swift
//  Kinder Care
//
//  Created by CIPL0023 on 06/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class VideoImageCell: UITableViewCell {

    @IBOutlet weak var stackMain: UIStackView!
    @IBOutlet weak var lblPhoto: UILabel!
    @IBOutlet weak var stackAttachMent: UIStackView!
    
    @IBOutlet weak var imageViw: UIImageView!
    
    @IBOutlet weak var downLoadBtn: UIButton!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var playerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         
       //loadCustomView()
        addSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadCustomView(){
        let customView = VideoImageView()
        let customView1 = VideoImageView()
        let screenSize = UIScreen.main.bounds
        self.stackAttachMent.insertArrangedSubview(customView, at: 1)
         self.stackAttachMent.insertArrangedSubview(customView1, at: 2)
       // self.stackAttachMent.addArrangedSubview(customView1)
        self.stackMain.addSubview(self.stackAttachMent)
    }
    
    func addSubviews() {
        let customView = VideoImageView()
        let customView1 = VideoImageView()
        
                let stack = UIStackView()
               stack.axis = .vertical
               stack.spacing = 8
               stack.distribution = .fill
               
               stack.addArrangedSubview(customView)
               stack.addArrangedSubview(customView1)
               
               stackAttachMent.addArrangedSubview(stack)
    }
}

