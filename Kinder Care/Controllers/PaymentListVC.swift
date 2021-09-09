//
//  PaymentListVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 19/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class PaymentListVC: BaseViewController {

     //MARK:- Initialization
     @IBOutlet weak var tblPaymentList: UITableView!
     @IBOutlet weak var childDropDown: ChildDropDown!
    
     var paymentType = "invoice"
     var selectedIndexPath:IndexPath?
     var childNameArray = [ChildName]()
      var childNameID:Int?
    var paymentListArray = [PaymentListData]()
    
    lazy var viewModel : familyInformationViewModel = {
        return familyInformationViewModel()
    }()
    
    
          //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        topBarHeight = 100
        titleString = "PAYMENT"
        
        if let childName = UserManager.shared.childNameList {
            childNameArray = childName
            self.childNameID = childNameArray.map({$0.id}).first
        }
        
        tblPaymentList.delegate = self
        tblPaymentList.dataSource = self
        tblPaymentList.tableFooterView = UIView()
        tblPaymentList.register(UINib(nibName: "PaymentCell", bundle: nil), forCellReuseIdentifier: "PaymentCell")
        
        self.view.bringSubviewToFront(childDropDown)
        if let childId = self.childNameID,let schoolID = UserManager.shared.currentUser?.school_id {
            self.viewModel.paymentList(student_id: "\(childId)", school_id: "\(schoolID)")
            
        }
        
        self.childNameDropDown()
        

    }
    
    func childNameDropDown(){
        
        childDropDown.titleArray = childNameArray.map({$0.name})
        childDropDown.subtitleArray = childNameArray.map({$0.className + " , " + $0.section + " Section"})
        
        if childNameArray.count > 1 {
            
            
            
            childDropDown.selectionAction = { (index : Int) in
                print(index)
                self.childNameID = self.childNameArray[index].id
                
                if let childId = self.childNameID,let schoolID = UserManager.shared.currentUser?.school_id {
                    self.viewModel.paymentList(student_id: "\(childId)", school_id: "\(schoolID)")
                    
                }
                
            }
        }
        else{
            childDropDown.isUserInteractionEnabled = false
        }
        childDropDown.addChildAction = { (sender : UIButton) in
            let vc = UIStoryboard.FamilyInformationStoryboard().instantiateViewController(withIdentifier:"AddChildVC") as! AddChildVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    //MARK:- Button Action
    @IBAction func selectPayment(_ sender: CTSegmentControl) {
        self.selectedIndexPath = nil
        if sender.selectedSegmentIndex == 0{
            paymentType = "invoice"
        }else{
            paymentType = "transaction"
        }
        self.tblPaymentList.reloadData()
    }
    
    @objc func termAction(sender: UIButton){
        
        if let cell = sender.superview?.superview?.superview?.superview?.superview?.superview?.superview?.superview as? PaymentCell{
            
            if let indexPath = tblPaymentList.indexPath(for: cell){
                
                let nextVC = UIStoryboard.paymentStoryboard().instantiateViewController(withIdentifier: "PaymentDetailsVC") as! PaymentDetailsVC
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
        
    }
    
    @objc func term2Action(sender: UIButton){
        
        if let cell = sender.superview?.superview?.superview?.superview?.superview?.superview?.superview?.superview as? PaymentCell{
            
            if let indexPath = tblPaymentList.indexPath(for: cell){
                
                let nextVC = UIStoryboard.paymentStoryboard().instantiateViewController(withIdentifier: "PaymentDetailsVC") as! PaymentDetailsVC
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    @objc func term3Action(sender: UIButton){
        
        if let cell = sender.superview?.superview?.superview?.superview?.superview?.superview?.superview?.superview as? PaymentCell{
            
            if let indexPath = tblPaymentList.indexPath(for: cell){
                
                let nextVC = UIStoryboard.paymentStoryboard().instantiateViewController(withIdentifier: "InvoiceDetailsVC") as! InvoiceDetailsVC
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
        
    }
}


//MARK:- TableView Delegates
extension PaymentListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if paymentType == "transaction"{
             return 3
        }
        else{
            return paymentListArray.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PaymentCell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as! PaymentCell
        cell.selectionStyle = .none
        
        if paymentType == "transaction"{
            cell.btnDropdown.isHidden  = true
            
            let main_string = "Paid  ₹ 3000"
            let string_to_color = "₹ 3000"
            
            let range = (main_string as NSString).range(of: string_to_color)
            let attributedString = NSMutableAttributedString.init(string: main_string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.ctBlue, range: range)
            attributedString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .regular)], range: NSMakeRange(0, attributedString.length))
            
            cell.labelPaid.attributedText = attributedString
        }else{
            cell.btnDropdown.isHidden  = false
            cell.dateLbl.text = paymentListArray[indexPath.row].date
            let main_string = "\(paymentListArray[indexPath.row].pending)"
            let string_to_color = "₹ 3000"
            
            let range = (main_string as NSString).range(of: string_to_color)
            let attributedString = NSMutableAttributedString.init(string: main_string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.ctYellow, range: range)
            attributedString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .regular)], range: NSMakeRange(0, attributedString.length))
            cell.labelPaid.attributedText = attributedString
        }
        
        cell.setPaymentStatusView(type: self.paymentType)
        
        cell.btnDropdown.addTarget(self, action: #selector(dropdownAction), for: .touchUpInside)
        cell.term1.addTarget(self, action: #selector(termAction), for: .touchUpInside)
        cell.term2.addTarget(self, action: #selector(term2Action), for: .touchUpInside)
        cell.term3.addTarget(self, action: #selector(term3Action), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        if paymentType == "transaction"{
            let nextVC = UIStoryboard.paymentStoryboard().instantiateViewController(withIdentifier: "PaymentDetailsVC") as! PaymentDetailsVC
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func dropdownAction(sender: UIButton){
        
        if let cell = sender.superview?.superview?.superview?.superview?.superview as? PaymentCell{
            if let indexPath = tblPaymentList.indexPath(for: cell){
                
                //expand and CollapseCell
                let cell = self.tblPaymentList.cellForRow(at: indexPath)  as! PaymentCell
                
                if self.selectedIndexPath == indexPath{
                    self.selectedIndexPath = nil
                    cell.vwPaymentStatus.isHidden = true
                    cell.vwPaymentStatus.layoutIfNeeded()
                }else{
                    self.selectedIndexPath = indexPath
                    cell.vwPaymentStatus.isHidden = false
                    cell.vwPaymentStatus.layoutIfNeeded()
            }
                
            tblPaymentList.beginUpdates()
            tblPaymentList.endUpdates()
        }
      }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
   /* func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        if  paymentType == "transaction"{
            let nextVC = UIStoryboard.paymentStoryboard().instantiateViewController(withIdentifier: "PaymentDetailsVC") as! PaymentDetailsVC
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else{
            
            //expand and CollapseCell
            let cell = self.tblPaymentList.cellForRow(at: indexPath)  as! PaymentCell
            
            if self.selectedIndexPath == indexPath{
                self.selectedIndexPath = nil
//                UIView.animate(withDuration: 1.0, delay: 0.0, options: [.transitionCurlDown], animations: {
//                    cell.vwPaymentStatus.isHidden = true
//                    cell.vwPaymentStatus.layoutIfNeeded()
//                }, completion: nil)
                
                cell.vwPaymentStatus.isHidden = true
                cell.vwPaymentStatus.layoutIfNeeded()
                
            }else{
                self.selectedIndexPath = indexPath
//                UIView.animate(withDuration: 1.0, delay: 0.0, options: [.transitionCurlUp], animations: {
//                    cell.vwPaymentStatus.isHidden = false
//                    cell.vwPaymentStatus.layoutIfNeeded()
//                }, completion: nil)
                
                cell.vwPaymentStatus.isHidden = false
                cell.vwPaymentStatus.layoutIfNeeded()
            }
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }*/
    
    /*func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 1) {
            cell.alpha = 1.0
        }
    }*/
}


extension PaymentListVC:familyInformationDelegate{
    func paymentList(paymentList: [PaymentListData]) {
        self.paymentListArray = paymentList
        self.tblPaymentList.reloadData()
    }
    
    func familyDetailsList(familyDetails: FamilyInformationData?) {
        
    }
    
    func editPickupSuccess() {
        
    }
    
    func failure(message: String) {
        
    }
    
    
    
    
}
