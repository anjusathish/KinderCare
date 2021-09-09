//
//  ClassRoomCell.swift
//  Kinder Care
//
//  Created by CIPL0023 on 11/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class ClassRoomCell: UITableViewCell {

    @IBOutlet var viewAllBtn: UIButton!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var labelSubject: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tilteLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var milestoneLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    
    @IBOutlet weak var attachmentView: CTView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
}

class RoundedShadowTableViewCell: UITableViewCell {

    var isFirstRow:Bool = false
    var isLastRow:Bool = false

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    func resetFor(indexPath:IndexPath, inTableView:UITableView){
        isFirstRow = false
        isLastRow = false

        if indexPath.row == 0{
            isFirstRow = true
        }
        if indexPath.row == (inTableView.numberOfRows(inSection: indexPath.section) - 1){
            isLastRow = true
        }

    }


    //MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        // OFFSET the content view
        var topOffset:CGFloat = 0
        var bottomOffset:CGFloat = 0
        if isFirstRow{
            topOffset = 5
        }
        if isLastRow{
            bottomOffset = 5
        }

        // Add border right and left
        let inset = UIEdgeInsets(top:topOffset, left: 15, bottom: bottomOffset, right: 15)

        contentView.frame = contentView.frame.inset(by: inset)

        // CORNERS
        var corners:CACornerMask = []
        if isFirstRow && !isLastRow{
            corners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        if isLastRow && !isFirstRow{
            corners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        if isLastRow && isFirstRow{
            corners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }

        let view = contentView

        // corner radius
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = corners

        // BORDERS
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.black.cgColor

        // SHADOW
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 9.0/2.0
        view.layer.masksToBounds = false

        // In case there is only one row, use default apple behavior
        if isLastRow && isFirstRow{
            return
        }

        // For a group of row inside the same section


        // the shadow rect determines the area in which the shadow gets drawn
        var rect = view.bounds.insetBy(dx: 0, dy: -10)
        if isFirstRow {
            rect.origin.y += 12;
        }else if isLastRow{
            rect.size.height -= 10;
        }
        view.layer.shadowPath =  UIBezierPath(roundedRect: rect, cornerRadius: 6).cgPath

        // the mask rect ensures that the shadow doesn't bleed into other table cells
        var maskRect:CGRect = view.bounds.insetBy(dx: -20, dy: 0)
        if isFirstRow {
            maskRect.origin.y -= 10;
            maskRect.size.height += 10;
        }else if isLastRow{
            maskRect.size.height += 10;
        }
        // and finally add the shadow mask
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(rect: maskRect).cgPath
        view.layer.mask = maskLayer

    }

}

class RoundedBorderTableViewCell: UITableViewCell {

    var isFirstRow:Bool = false
    var isLastRow:Bool = false

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    func resetFor(indexPath:IndexPath, inTableView:UITableView){
        isFirstRow = false
        isLastRow = false

        if indexPath.row == 0{
            isFirstRow = true
        }
        if indexPath.row == (inTableView.numberOfRows(inSection: indexPath.section) - 1){
            isLastRow = true
        }

    }


    //MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()

        // OFFSET the content view
        var topOffset:CGFloat = 0
        var bottomOffset:CGFloat = 0
        if isFirstRow{
            topOffset = 5
        }
        if isLastRow{
            bottomOffset = 5
        }

        // Add border right and left
        let inset = UIEdgeInsets(top:topOffset, left: 15, bottom: bottomOffset, right: 15)

        contentView.frame = contentView.frame.inset(by: inset)

        // CORNERS
        var corners:CACornerMask = []
        if isFirstRow && !isLastRow{
            corners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        if isLastRow && !isFirstRow{
            corners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        if isLastRow && isFirstRow{
            corners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }

        let view = contentView
        view.backgroundColor = .ctGray

        // corner radius
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = corners

        // BORDERS
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.black.cgColor

        // SHADOW
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false

        // In case there is only one row, use default apple behavior
        if isLastRow && isFirstRow{
            return
        }

        // For a group of row inside the same section


        // the shadow rect determines the area in which the shadow gets drawn
        var rect = view.bounds.insetBy(dx: 0, dy: -10)
        if isFirstRow {
            rect.origin.y += 12;
        }else if isLastRow{
            rect.size.height -= 10;
        }
        view.layer.shadowPath =  UIBezierPath(roundedRect: rect, cornerRadius: 15).cgPath

        // the mask rect ensures that the shadow doesn't bleed into other table cells
        var maskRect:CGRect = view.bounds.insetBy(dx: -20, dy: 0)
        if isFirstRow {
            maskRect.origin.y -= 10;
            maskRect.size.height += 10;
        }else if isLastRow{
            maskRect.size.height += 10;
        }
        // and finally add the shadow mask
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(rect: maskRect).cgPath
        view.layer.mask = maskLayer

    }

}

