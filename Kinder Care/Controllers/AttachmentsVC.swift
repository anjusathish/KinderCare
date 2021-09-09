//
//  AttachmentsVC.swift
//  Kinder Care
//
//  Created by Ragavi Rajendran on 13/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import Photos
import SKPhotoBrowser
import AVKit
import AVFoundation

class AttachmentsVC: BaseViewController {
    
    @IBOutlet var attachmentTableView: UITableView!
    
    var attachmentsDetails:[Attachment]=[]
    var attachmentLink :[URL]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleString = "ATTACHMENTS"
        print(attachmentsDetails)
        self.attachmentTableView.register(UINib(nibName: "AttachmentViewAllTableViewCell", bundle: nil), forCellReuseIdentifier: "AttachmentViewAllTableViewCell")
    }
    
    @objc func videoDownloadAction(_ sender : UIButton){ //Sathish Doubt
       
            if let videoUrlString = attachmentsDetails[sender.tag].file{
                self.downloadVideoLinkAndCreateAsset(videoUrlString)
            }
            
        
        else{
            //self.downloadVideoLinkAndCreateAsset(URL.init(string: attachmentLink))
           
        }}
    
    func previewPhotobrowser() {
       
       var images = [SKPhoto]()
       
         let activityAttachment = attachmentsDetails
         
         for arrayImagesPath in activityAttachment {
           
           if let imageFilePath = arrayImagesPath.file{
             
             let photo = SKPhoto.photoWithImageURL(imageFilePath)
             photo.shouldCachePhotoURLImage = false
             images.append(photo)
           }
         }
         
         let browser = SKPhotoBrowser(photos: images)
         browser.initializePageIndex(0)
         present(browser, animated: true, completion: {})
       
     }
    func playVideoPlayer(_ videoURL: URL){
      
      let player = AVPlayer(url: videoURL)
      
      let playerViewController = AVPlayerViewController()
      playerViewController.player = player
      
      self.present(playerViewController, animated: true){
        
        playerViewController.player!.play()
        
      }
    }
    
     
    
}

// MARK: - TableView
extension AttachmentsVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentViewAllTableViewCell", for: indexPath) as! AttachmentViewAllTableViewCell
        cell.attachmentDownloadButton.addTarget(self, action: #selector(videoDownloadAction(_:)), for: .touchUpInside)
        cell.attachmentDownloadButton.tag = indexPath.row

        if attachmentsDetails.count == 0{
            if let link = attachmentLink{
                
                cell.attachmentImageView.sd_setImage(with: link[indexPath.row])
            }
        }
            
        else{
            
            
            
            
            
            
            if let thumbImg  = attachmentsDetails[indexPath.row].thumb {
                
                if let urlString = thumbImg.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
                    if let url = URL(string: urlString) {
                        cell.attachmentImageView.sd_setImage(with: url)
                    }
                }
            }
            
            
            if let mime = attachmentsDetails[indexPath.row].mimetype{
                cell.attachmentNameLabel.text = mime
                if mime == "image/jpeg"{
                    cell.videoPlayImage.isHidden = true
                }
                else if mime == "image/png"{
                    cell.videoPlayImage.isHidden = true
                }
                
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if attachmentsDetails.count == 0{
            return 1
        }
        else{
            return attachmentsDetails.count
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let activityAttachmentDetail = attachmentsDetails[indexPath.row]
             
             if activityAttachmentDetail.mimetype == "video/mp4"{
               
               if let videoFilePath = activityAttachmentDetail.file{
                 
                 guard let videoURL = URL(string: videoFilePath) else { return }
                 
                 playVideoPlayer(videoURL)
                 
               }
               
             }else{
               previewPhotobrowser()
             }
           
        
    }
    
}
