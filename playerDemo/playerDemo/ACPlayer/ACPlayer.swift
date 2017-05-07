//
//  ACPlayer.swift
//  playerDemo
//
//  Created by ac on 2017/5/7.
//  Copyright © 2017年 ac. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

public protocol ACPlayerDelegate: NSObjectProtocol {
  
  func playerViewBackButtonAction()
  
}

open class ACPlayer: UIView {
  
  public enum ACPlayerURLType {
    case none
    case asset(AVAsset)
    case URLString(String)
    case URL(URL)
  }
  
  public enum ACPlayerPlaceholderImageType {
    case none
    case image(UIImage)
    case URLString(String)
  }
  
  open weak var delegate: ACPlayerDelegate?
  // 视频资源URL
  open var videoURL: ACPlayerURLType = .none
  // 视频标题
  open var title: String?
  // 视频封面占位图，默认是空
  open var placeholderImage: ACPlayerPlaceholderImageType = .none
  // 视频分辨率
  open var resolutionDic: [String: String] = [:]
  // 视频填充模式
  open var videoGravity: String = AVLayerVideoGravityResizeAspect
  
  //  private var playerItem: AVPlayerItem!
  private var isAutoPlay = false
  private var player: AVPlayer!
  
  init() {
    super.init(frame: CGRect.zero)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func autoPlay() {
    isAutoPlay = true
    setPlayer()
    player.play()
  }
  
  func play() {
    player.play()
  }
  
  private func setPlayer() {
    var playerItem: AVPlayerItem? = nil
    switch videoURL {
    case .asset(let asset):
      playerItem = AVPlayerItem(asset: asset)
    case .URL(let url):
      playerItem = AVPlayerItem(url: url)
    case .URLString(let urlStr):
      if let url = URL(string: urlStr) {
        playerItem = AVPlayerItem(url: url)
      }
    default:
      break
    }
    player = AVPlayer(playerItem: playerItem)
    
    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = UIScreen.main.bounds
    playerLayer.videoGravity = videoGravity
    layer.addSublayer(playerLayer)
  }
}

