//
//  AttachmentView.swift
//  Kinder Care
//
//  Created by CIPL0681 on 1/7/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit

@IBDesignable
class AttachmentView: UIView {
    
    @IBOutlet weak var attachmentSizeLabel: UILabel!
    @IBOutlet weak var viewallBtn: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelAttachment: UILabel!
    @IBOutlet weak var attachmentView: CTView!
    
    @objc var viewAllAction : ((UIButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Private Helper Methods
    
    // Performs the initial setup.
    private func setupView() {
        
        Bundle.main.loadNibNamed("AttachmentView", owner: self, options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        viewallBtn.addTarget(self, action: #selector(self.viewAllAction(_:)), for: .touchUpInside)

        addSubview(contentView)
        
    }
    
    @objc func viewAllAction(_ sender: UIButton){ 
        if let action = self.viewAllAction {
                    action(sender)
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
