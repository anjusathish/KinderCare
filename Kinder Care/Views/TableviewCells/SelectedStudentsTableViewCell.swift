//
//  SelectedStudentsTableViewCell.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 25/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class SelectedStudentsTableViewCell: UITableViewCell {
    
    @IBOutlet var selectLbl: UILabel!
    @IBOutlet var selectedStuCollectionView: UICollectionView!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var activityTypeLabel: UILabel!
    @IBOutlet weak var activityTypeView: UIView!
  
    var selectedUsers:[String]=[] {
        didSet {
            selectedStuCollectionView.reloadData()
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectedStuCollectionView.register(UINib(nibName: "SelectedStudentsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectedStudentsCollectionViewCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension SelectedStudentsTableViewCell : UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedStudentsCollectionViewCell", for: indexPath) as! SelectedStudentsCollectionViewCell
        cell.studentsNameLbl.text = selectedUsers[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let UserName = self.selectedUsers[indexPath.row]
        if UserName.contains("selected"){
            let size:CGFloat = (collectionView.frame.size.width)
            return CGSize(width: size, height: 100)
        }else{
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (selectedStuCollectionView.frame.size.width - space) / 2.0
            return CGSize(width: size, height: 50)
        }

    }
}
