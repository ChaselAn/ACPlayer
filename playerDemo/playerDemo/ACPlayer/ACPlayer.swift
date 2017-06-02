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
import SnapKit

public protocol ACPlayerDelegate: NSObjectProtocol {
  
  func playerViewBackButtonAction()
  
}

open class ACPlayer: UIView {
  
  public enum URLType {
    case none
    case asset(AVAsset)
    case URLString(String)
    case URL(URL)
  }
  
  public enum PlaceholderImageType {
    case none
    case image(UIImage)
    case URLString(String)
  }
  
  open weak var delegate: ACPlayerDelegate?
  // 视频资源URL
  open var videoURL: URLType = .none
  // 视频标题
  open var title: String?
  // 视频封面占位图，默认是空
  open var placeholderImage: PlaceholderImageType = .none
  // 视频填充模式
  open var videoGravity: String = AVLayerVideoGravityResizeAspect
  // 控制层View
  open var controlView: UIView? = nil
  
  private var player: AVPlayer!
  
  public init(customControlView: UIView?) {
    super.init(frame: CGRect.zero)
    self.controlView = customControlView
    setUI()
  }
  
  public init() {
    super.init(frame: CGRect.zero)
    setUI()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUI()
  }
  
  open func autoPlay() {
    setPlayer()
    player.play()
  }
  
  open func play() {
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
  
  private func setUI() {
    if controlView == nil {
      controlView = Bundle.main.loadNibNamed("ACPlayerControlView", owner: nil, options: nil)?.last as! ACPlayerControlView
    }
    addSubview(controlView!)
    controlView?.snp.makeConstraints({ (make) in
      make.edges.equalToSuperview()
    })
  }
}

