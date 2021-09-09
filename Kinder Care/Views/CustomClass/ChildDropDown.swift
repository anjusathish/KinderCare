//
//  ChildDropDown.swift
//  Kinder Care
//
//  Created by Athiban Ragunathan on 21/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import BEMCheckBox

enum UserTypes : Int
{
    case parent = 5
    case teacher = 4
    case admin = 3
    case superadmin = 2
    case all = 1
    case student = 6
}

@IBDesignable
class ChildDropDown: UIView {
    
    
    @IBOutlet var contentView: ChildDropDown!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var section: UILabel!
    
    var headerTitle : String = "Choose Child Profile"
//    var footerTitle : String = "ADD MORE CHILD"{
//        didSet{
//            footerHeight = footerTitle.isEmpty ? 0 : 60
//        }
//    }
    
    var schoolListArray : [SchoolListData] = []
    
    private var footerHeight = 60
    
    private var shadowLayer: CAShapeLayer!
    private var containerView : UIView!
    private var containerBGView : UIView!
    private var childTableView : UITableView!
    public var selectedIndex : Int?
    
    var selectionAction : ((Int) -> Void)?
    var addChildAction : ((UIButton) -> Void)?
    
    private var shadowLayer1: CAShapeLayer!
    private let _window = UIApplication.shared.keyWindow!
    
    var titleArray : [String] = []{
        didSet {
            selectedIndex = 0
            setSelected()
        }
    }
    var subtitleArray : [String] = []{
        didSet {
            selectedIndex = 0
            setSelected()
        }
    }
    var imageArray : [String] = []{
        didSet {
            selectedIndex = 0
            setSelected()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    // MARK: - Private Helper Methods
    
    // Performs the initial setup.
    private func setupView() {
        
        Bundle.main.loadNibNamed("ChildDropDown", owner: self, options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        addSubview(contentView)
        
        childTableView = UITableView()
        childTableView.dataSource = self
        childTableView.delegate = self
        childTableView.separatorStyle = .none
        childTableView.backgroundColor = .clear
        
        childTableView.register(UINib(nibName: "ChildListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChildCell")
        
        containerView = UIView()
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        containerBGView = UIView()
        containerBGView.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(gesture:)))
        containerBGView.addGestureRecognizer(tapGesture)
        
        dropDownView.layer.shadowColor = UIColor.black.cgColor
        dropDownView.layer.shadowOpacity = 0.2
        dropDownView.layer.shadowOffset = CGSize(width: 0, height: 0)
        dropDownView.layer.shadowRadius = 3
    }
    
    @objc func tapGestureAction(gesture : UITapGestureRecognizer) {
        heightConstant.constant = 0
        self.containerBGView.removeFromSuperview()
    }
    
    func setSelected() {
        
        if let index = selectedIndex {
            
            if let userType = UserManager.shared.currentUser?.userType, let _selectedType = UserTypes(rawValue: userType) {
                
                switch _selectedType{
                    
                case .superadmin:

                    if let schoolList = UserManager.shared.schoolList, index < schoolList.count {
                        UserManager.shared.currentUser?.school_id = schoolList[index].id
                    }
                    
                default :  break
                }
            }
            
            if index < titleArray.count {
                nameLabel.text = titleArray[index]
            }
            
            if index < subtitleArray.count {
                section.text = subtitleArray[index]
            }
            /*  if index < imageArray.count {
             let img = imageArray[index]
             if let urlString = img.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
             if let url = URL(string: urlString) {
             profileImageView.sd_setImage(with: url)
             }
             }
             }*/
        }
    }
    
    // MARK: - Action
    
    @IBAction func dropDownAction(_ sender: UIButton) {
        
        if heightConstant.constant == 0 {
            
            heightConstant.constant = CGFloat(250 + footerHeight)
            
            if let y = sender.globalFrame?.origin.y, let x = sender.superview?.globalFrame?.origin.x {
                
                containerView.frame = CGRect(x: x + 20, y: y + sender.frame.height + 20, width: self.frame.width - 40, height: 0)
                containerBGView.frame = CGRect(origin: .zero, size: CGSize(width: _window.frame.width, height: _window.frame.height))
            }
            
            childTableView.frame = CGRect(origin: .zero, size: CGSize(width: self.frame.width - 40, height: self.heightConstant.constant - 50))
            
            containerView.addSubview(childTableView)
            containerBGView.addSubview(containerView)
            _window.addSubview(containerBGView)
            
            self.containerView.frame.size.height = self.heightConstant.constant - 50
            
            childTableView.reloadData()
        }
        else {
            
            self.containerBGView.removeFromSuperview()
            heightConstant.constant = 0
        }
        
    }
    
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

extension ChildDropDown : BEMCheckBoxDelegate {
    
    func didTap(_ checkBox: BEMCheckBox) {
        
        if let index = selectedIndex, let cell = childTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ChildListTableViewCell {
            cell.checkBox.setOn(false, animated: false)
        }
        
        checkBox.setOn(true, animated: true)
        selectedIndex = checkBox.tag
        
        setSelected()
        
        if let action = selectionAction {
            
            action(selectedIndex!)
            dropDownAction(UIButton())
        }
    }
}

extension ChildDropDown : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChildCell", for: indexPath) as! ChildListTableViewCell
        cell.checkBox.tag = indexPath.row
        cell.checkBox.delegate = self
        
        cell.namelabel.text = titleArray[indexPath.row]
        cell.sectionlabel.text = subtitleArray[indexPath.row]
        //        let img = imageArray[indexPath.row]
        //          let imgPath = ImageURL.imageBasePath + img
        //        if let urlString = imgPath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
        //                        if let url = URL(string: urlString) {
        //                       profileImageView.sd_setImage(with: url)
        //                    }
        //                    }
        if let index = selectedIndex, index == indexPath.row {
            cell.checkBox.on = true
            cell.customView.showBorder = true
        }
        else {
            cell.checkBox.on = false
            cell.customView.showBorder = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 10, width: tableView.frame.width, height: 21))
        titleLabel.text = headerTitle
        titleLabel.textColor = UIColor.ctBlue
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        let borderLabel = UILabel(frame: CGRect(x: 0, y: 34, width: tableView.frame.width, height: 1))
        borderLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(borderLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 45
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        
//        
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
//        footerView.backgroundColor = .white
//        
//        
//        let button = UIButton(frame: CGRect(x: 0, y: 15, width: tableView.frame.width, height: 30))
//        
//       // let attributtedString = NSMutableAttributedString(string: footerTitle, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor : UIColor.ctBlue])
//        
//       // button.setAttributedTitle(attributtedString, for: .normal)
//       // button.addTarget(self, action: #selector(addchildAction), for: .touchUpInside)
//        
//      //  footerView.addSubview(button)
//        
//       // return footerView
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        
//        return CGFloat(footerHeight)
//    }
    
    @objc func addchildAction(button: UIButton) {
        
        dropDownAction(UIButton())
        
        if let action = self.addChildAction {
            action(button)
        }
    }
}
