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
  
  public enum ResourceType {
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
  // 视频资源
  open var videoResource: ResourceType = .none {
    didSet {
      setupPlayerLayer()
    }
  }
  // 视频标题
  open var title: String?
  // 视频封面占位图，默认是空
  open var placeholderImage: PlaceholderImageType = .none
  // 视频填充模式
  open var videoGravity: String = AVLayerVideoGravityResizeAspect
  
//  private var playerItem: AVPlayerItem?
//  fileprivate var player: AVPlayer!
  
  var controlView: ACPlayerControlView = Bundle.main.loadNibNamed("ACPlayerControlView", owner: nil, options: nil)?.last as! ACPlayerControlView
  var totalDuration: TimeInterval = 0
  
  fileprivate var playerLayerView: ACPlayerLayerView!
  fileprivate var timer: Timer?
  fileprivate var playerStatus: PlayerStatus = .none
  fileprivate var shouldSeekTo: TimeInterval = 0
  
//  public init(customControlView: UIView?) {
//    super.init(frame: CGRect.zero)
//    self.controlView = customControlView
//    setupUI()
//  }
  
  public init() {
    super.init(frame: CGRect.zero)
    setupUI()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupUI()
  }
  
//  open func autoPlay() {
////    setupPlayer()
//    play()
//  }
  
  open func play() {
    playerLayerView.videoGravity = videoGravity
    if playerStatus == .error { return }
    controlView.playButton.isSelected = true
    playerStatus = .playing
    setupTimer()
//    player.play()
  }
  
  open func pause() {
    playerStatus = .pause
//    player.pause()
    timer?.fireDate = Date.distantFuture
  }
  
  open func replay() {
    controlView.replay()
    playerLayerView.seek(to: 0) { (finished) in
      self.play()
    }
  }
  
  enum PlayerStatus {
    case none
    case playing
    case pause
    case end
    case error
  }
  
  private func setupPlayerLayer() {
    playerLayerView = ACPlayerLayerView(resourceType: videoResource)
  }
  
  private func setupUI() {
    addSubview(playerLayerView)

    controlView.delegate = self
    addSubview(controlView)
    
    playerLayerView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    controlView.snp.makeConstraints({ (make) in
      make.edges.equalToSuperview()
    })
  }
  
  fileprivate func setupTimer() {
    timer?.invalidate()
    timer = Timer.ac_scheduledTimerWithTimeInterval(0.5, closure: { [weak self] in
      self?.timerAction()
    }, repeats: true)
    timer?.fireDate = Date()
  }
  
  @objc private func timerAction() {
    guard let playerItem = playerLayerView.playerItem, playerItem.duration.timescale != 0 else { return }
    let currentTime = CMTimeGetSeconds(playerLayerView.player!.currentTime())
    let totalTime   = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
    controlView.setTimeAndSlider(currentTime: currentTime, totalTime: totalTime)
    if currentTime >= totalTime {
      playerStatus = .end
    }
  }
  
//  open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//    guard let item = object as? AVPlayerItem, let keyPath = keyPath else { return }
//    switch keyPath {
//    case PlayerObserverName.status:
//      break
//    case PlayerObserverName.loadedTimeRanges:
//      if let timeInterVarl = self.availableDuration() {
//        let duration = item.duration
//        let totalDuration = CMTimeGetSeconds(duration)
//        controlView.setProgress(loadedDuration: timeInterVarl, totalDuration: totalDuration)
//        self.totalDuration = totalDuration
//        controlView.totalDuration = totalDuration
//      }
//    case PlayerObserverName.playbackBufferEmpty:
//      controlView.showLoading()
//    case PlayerObserverName.playbackLikelyToKeepUp:
//      controlView.hideLoading()
//    default:
//      break
//    }
//  }
  
}

extension ACPlayer: ACPlayerControlViewDelegate {
  func controlView(controlView: ACPlayerControlView, didClickedButton button: UIButton) {
    guard let action = ACPlayerControlView.ButtonType(rawValue: button.tag) else { return }
    switch action {
    case .play:
      if playerStatus == .end {
        replay()
      } else {
        button.isSelected ? play() : pause()
      }
    case .back:
      delegate?.backButtonDidClicked(in: self)
    case .replay:
      replay()
    default:
      break
    }
  }
  
  func controlView(controlView: ACPlayerControlView, slider: UISlider, onSliderEvent event: UIControlEvents) {
    switch event {
    case UIControlEvents.touchDown:
      if playerLayerView.playerItem?.status == AVPlayerItemStatus.readyToPlay {
        timer?.fireDate = Date.distantFuture
      }
    case UIControlEvents.touchUpInside :
      let seconds = totalDuration * Double(slider.value)
      if seconds.isNaN {
        return
      }
      setupTimer()
      if playerLayerView.playerItem?.status == AVPlayerItemStatus.readyToPlay {
        playerLayerView.seek(to: Int(seconds), completionHandler: { (finished) in
          self.play()
        })
      } else {
        shouldSeekTo = seconds
      }
    default:
      break
    }
  }
}
