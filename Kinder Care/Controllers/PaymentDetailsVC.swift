//
//  PaymentDetailsVC.swift
//  Kinder Care
//
//  Created by CIPL0023 on 19/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class PaymentDetailsVC: BaseViewController {

    //MARK:- Initialization
    
       //MARK:- View Life Cycle
       override func viewDidLoad() {
           super.viewDidLoad()
        titleString = "PAYMENT"

           // Do any additional setup after loading the view.
       }
       
       //MARK:- Local Methods
       
       
       //MARK:- Button Action
    @IBAction func downloadInvoiceAction(_ sender: Any) {
     self.navigationController?.popViewController(animated: true)
    }


}
