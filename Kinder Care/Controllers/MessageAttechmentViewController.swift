//
//  MessageAttechmentViewController.swift
//  Kinder Care
//
//  Created by CIPL0590 on 7/14/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class MessageAttechmentViewController: BaseViewController {
    
    @IBOutlet weak var messageTblView: UITableView!
    
     var attachmentsDetails:[MessageDetails]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleString = "ATTACHMENTS"
        
        self.messageTblView.register(UINib(nibName: "AttachmentViewAllTableViewCell", bundle: nil), forCellReuseIdentifier: "AttachmentViewAllTableViewCell")
    }
    
    
    
    
}

extension MessageAttechmentViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentViewAllTableViewCell", for: indexPath) as! AttachmentViewAllTableViewCell
        cell.videoPlayImage.isHidden = true
        cell.attachmentImageView.isHidden = true
        cell.imageWebView.isHidden = false
        
        if let thumbImg  = attachmentsDetails.first?.webattachments {
           
            
            if let url = URL(string: thumbImg[indexPath.row].link!) {
                let request = URLRequest(url: url)
                cell.imageWebView.loadRequest(request)
            }
        }
        cell.attachmentNameLabel.text = attachmentsDetails.first?.webattachments![indexPath.row].name
        cell.attachmentDownloadButton.addTarget(self, action: #selector(videoDownloadAction(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attachmentsDetails.first?.attachment?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        previewPhotobrowser(indexPath: indexPath)
    }
    
    @objc func videoDownloadAction(_ sender : UIButton){
        self.displayServerError(withMessage: "Downloaded Successfully")

    }
    
    func previewPhotobrowser(indexPath:IndexPath) {
      
      var images = [SKPhoto]()
      
        let activityAttachment = attachmentsDetails
        
        for arrayImagesPath in activityAttachment.map({$0.webattachments}) {
          
            if let imageFilePath = arrayImagesPath?.map({$0.link}){
            let photo  = SKPhoto.photoWithImageURL(imageFilePath[indexPath.row] as! String)
            photo.shouldCachePhotoURLImage = false
            images.append(photo)
          }
        }
        
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
      
    }
   
}
