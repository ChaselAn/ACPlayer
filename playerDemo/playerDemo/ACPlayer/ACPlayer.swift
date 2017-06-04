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
  
  func backButtonDidClicked(in player: ACPlayer)
  
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
  private var controlView: ACPlayerControlView = Bundle.main.loadNibNamed("ACPlayerControlView", owner: nil, options: nil)?.last as! ACPlayerControlView
  
  private var playerItem: AVPlayerItem?
  private var player: AVPlayer!
  private var playerLayerView = UIView()
  
//  public init(customControlView: UIView?) {
//    super.init(frame: CGRect.zero)
//    self.controlView = customControlView
//    setUI()
//  }
  
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
  
  enum PlayerObserverName {
    static let status = "status"
    static let loadedTimeRanges = "loadedTimeRanges"
    static let playbackBufferEmpty = "playbackBufferEmpty"
    static let playbackLikelyToKeepUp = "playbackLikelyToKeepUp"
  }
  
  private func setPlayer() {
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
    playerLayerView.layer.addSublayer(playerLayer)
    
    playerItem?.addObserver(self, forKeyPath: PlayerObserverName.status, options: NSKeyValueObservingOptions.new, context: nil)
    playerItem?.addObserver(self, forKeyPath: PlayerObserverName.loadedTimeRanges, options: NSKeyValueObservingOptions.new, context: nil)
    playerItem?.addObserver(self, forKeyPath: PlayerObserverName.playbackBufferEmpty, options: NSKeyValueObservingOptions.new, context: nil)
    playerItem?.addObserver(self, forKeyPath: PlayerObserverName.playbackLikelyToKeepUp, options: NSKeyValueObservingOptions.new, context: nil)
  }
  
  private func availableDuration() -> TimeInterval? {
    if let loadedTimeRanges = player?.currentItem?.loadedTimeRanges, let first = loadedTimeRanges.first {
      let timeRange = first.timeRangeValue
      let startSeconds = CMTimeGetSeconds(timeRange.start)
      let durationSecound = CMTimeGetSeconds(timeRange.duration)
      let result = startSeconds + durationSecound
      return result
    }
    return nil
  }
  
  private func setUI() {
    addSubview(playerLayerView)
//    if controlView == nil {
//      let tempControlView =
//      tempControlView.handlePlayer = self
//      controlView = tempControlView
//    }
    controlView.handlePlayer = self
    addSubview(controlView)
    
    playerLayerView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    controlView.snp.makeConstraints({ (make) in
      make.edges.equalToSuperview()
    })
  }
  
  open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard let item = object as? AVPlayerItem, let keyPath = keyPath else { return }
    switch keyPath {
    case PlayerObserverName.status:
      break
    case PlayerObserverName.loadedTimeRanges:
      if let timeInterVarl = self.availableDuration() {
        let duration = item.duration
        let totalDuration = CMTimeGetSeconds(duration)
        controlView.setProgress(loadedDuration: timeInterVarl, totalDuration: totalDuration)
      }
    default:
      break
    }
  }
  
  deinit {
    playerItem?.removeObserver(self, forKeyPath: PlayerObserverName.status)
    playerItem?.removeObserver(self, forKeyPath: PlayerObserverName.loadedTimeRanges)
    playerItem?.removeObserver(self, forKeyPath: PlayerObserverName.playbackBufferEmpty)
    playerItem?.removeObserver(self, forKeyPath: PlayerObserverName.playbackLikelyToKeepUp)
  }
}

