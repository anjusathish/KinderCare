//
//  ActivityTableCell.swift
//  Kinder Care
//
//  Created by CIPL0023 on 06/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class ActivityTableCell: UITableViewCell{
  
  @IBOutlet weak var collActivity: UICollectionView!
  @IBOutlet weak var lblActivity: UILabel!
  @IBOutlet weak var viewAddMoreImage: UIView!
  
  @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var rightAddData: UILabel!
    
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    collActivity.register(UINib(nibName: "ActivivtyCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ActivivtyCollectionCell")
    collActivity.register(UINib(nibName: "ActivityImageCell", bundle: nil), forCellWithReuseIdentifier: "ActivityImageCell")
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  
}
