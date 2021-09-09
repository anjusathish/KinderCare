//
//  AttachmentViewAllTableViewCell.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 13/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class AttachmentViewAllTableViewCell: UITableViewCell {
  
  
    @IBOutlet weak var imageWebView: UIWebView!
    @IBOutlet weak var attachmentDownloadButton: UIButton!
  
  @IBOutlet weak var attachmentNameLabel: UILabel!
  @IBOutlet weak var attachmentImageView: UIImageView!
  @IBOutlet weak var activityTypeLabel: UILabel!
  @IBOutlet weak var activityTypeView: UIView!
  
  @IBOutlet weak var videoPlayImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
