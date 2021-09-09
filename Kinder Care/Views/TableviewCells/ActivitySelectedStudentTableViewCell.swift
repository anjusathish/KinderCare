//
//  ActivitySelectedStudentTableViewCell.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 10/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class ActivitySelectedStudentTableViewCell: UITableViewCell {

    @IBOutlet var selectedStuCollectionView: UICollectionView!
    @IBOutlet var editBtn: UIButton!
    
    @IBOutlet var activityLabel: UILabel!
    var selectedStuNamesArray = ["Chris MArtin", "John Mathew","Chris MArtin", "John Mathew","Chris MArtin", "John Mathew","Chris MArtin", "John Mathew","Chris MArtin", "John Mathew"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
         self.selectedStuCollectionView.register(UINib(nibName: "SelectedStudentsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectedStudentsCollectionViewCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension ActivitySelectedStudentTableViewCell : UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedStuNamesArray.count
          }
          
          func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedStudentsCollectionViewCell", for: indexPath) as! SelectedStudentsCollectionViewCell
            cell.studentsNameLbl.text = selectedStuNamesArray[indexPath.row]
            return cell
          }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (selectedStuCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: 50)
    }
}
