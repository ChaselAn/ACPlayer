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
  fileprivate var player: AVPlayer!
  private var playerLayerView = UIView()
  fileprivate var timer: Timer?
  fileprivate var playerStatus: PlayerStatus = .none
  fileprivate var totalDuration: TimeInterval = 0
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
  
  open func autoPlay() {
    setupPlayer()
    play()
  }
  
  open func play() {
    if playerStatus == .error { return }
    controlView.playButton.isSelected = false
    playerStatus = .playing
    setupTimer()
    player.play()
  }
  
  open func pause() {
    playerStatus = .pause
    player.pause()
    timer?.fireDate = Date.distantFuture
  }
  
  open func replay() {
    
  }
  
  enum PlayerObserverName {
    static let status = "status"
    static let loadedTimeRanges = "loadedTimeRanges"
    static let playbackBufferEmpty = "playbackBufferEmpty"
    static let playbackLikelyToKeepUp = "playbackLikelyToKeepUp"
  }
  
  enum PlayerStatus {
    case none
    case playing
    case pause
    case end
    case error
  }
  
  private func setupPlayer() {
    switch videoURL {
    case .asset(let asset):
      playerItem = AVPlayerItem(asset: asset)
    case .URL(let url):
      playerItem = AVPlayerItem(url: url)
    case .URLString(let urlStr):
      if let url = URL(string: urlStr) {
        playerItem = AVPlayerItem(url: url)
      } else {
        playerStatus = .error
      }
    default:
      playerStatus = .none
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
    guard let playerItem = playerItem, playerItem.duration.timescale != 0 else { return }
    let currentTime = CMTimeGetSeconds(player!.currentTime())
    let totalTime   = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
    controlView.setTimeAndSlider(currentTime: currentTime, totalTime: totalTime)
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
        self.totalDuration = totalDuration
        controlView.totalDuration = totalDuration
      }
    case PlayerObserverName.playbackBufferEmpty:
      break
    case PlayerObserverName.playbackLikelyToKeepUp:
      break
    default:
      break
    }
  }
  
  deinit {
    playerItem?.removeObserver(self, forKeyPath: PlayerObserverName.status)
    playerItem?.removeObserver(self, forKeyPath: PlayerObserverName.loadedTimeRanges)
    playerItem?.removeObserver(self, forKeyPath: PlayerObserverName.playbackBufferEmpty)
    playerItem?.removeObserver(self, forKeyPath: PlayerObserverName.playbackLikelyToKeepUp)
    print("ACPlayer deinit")
  }
}

extension ACPlayer: ACPlayerControlViewDelegate {
  func controlView(controlView: ACPlayerControlView, didClickedButton button: UIButton) {
    guard let action = ACPlayerControlView.ButtonType(rawValue: button.tag) else { return }
    switch action {
    case .play:
      button.isSelected ? pause() : play()
    case .back:
      delegate?.backButtonDidClicked(in: self)
    default:
      break
    }
  }
  
  func controlView(controlView: ACPlayerControlView, slider: UISlider, onSliderEvent event: UIControlEvents) {
    switch event {
    case UIControlEvents.touchDown:
      if player?.currentItem?.status == AVPlayerItemStatus.readyToPlay {
        timer?.fireDate = Date.distantFuture
      }
    case UIControlEvents.touchUpInside :
      let seconds = totalDuration * Double(slider.value)
      if seconds.isNaN {
        return
      }
      setupTimer()
      if self.player?.currentItem?.status == AVPlayerItemStatus.readyToPlay {
        let draggedTime = CMTimeMake(Int64(seconds), 1)
        player!.seek(to: draggedTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: { (finished) in
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
