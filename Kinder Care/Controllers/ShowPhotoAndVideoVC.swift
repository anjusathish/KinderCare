//
//  ShowPhotoAndVideoVC.swift
//  Kinder Care
//
//  Created by PraveenKumar R on 01/04/20.
//  Copyright © 2020 Athiban Ragunathan. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ShowPhotoAndVideoVC: BaseViewController {
  
  @IBOutlet weak var previewImageview: UIImageView!
  @IBOutlet weak var previewVideoView: UIView!
  
  var activityAttachmentDetail:Attachment?
  public var attachementPhoto = ""
  
  var avPlayer: AVPlayer!
  var avPlayerLayer: AVPlayerLayer!
  var paused: Bool = false
  
  
  //MARK:- ViewController LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    titleString = "PREVIEW"
    
    if activityAttachmentDetail?.mimetype == "image/png"{
      
      if let imageFilePath = activityAttachmentDetail?.file{
        
        if let urlString = imageFilePath.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
          
          if let url = URL(string: urlString) {
            
            previewImageview.sd_setImage(with: url)
          }
        }
      }
      
    }else{
      
      if let videoFilePath = activityAttachmentDetail?.file{
        
        guard let videoURL = URL(string: videoFilePath) else { return }
        
        playVideo(videoURL)
        
      }
    }
    
  }
  
  //MARK:- PlayVideo
  func playVideo(_ videoURL: URL){
    
    avPlayer = AVPlayer(url: videoURL)
    avPlayerLayer = AVPlayerLayer(player: avPlayer)
    avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    avPlayer.volume = 0
    avPlayer.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
    
    avPlayerLayer.frame = view.layer.bounds
    view.layer.insertSublayer(avPlayerLayer, at: 0)
    avPlayer.play()
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
