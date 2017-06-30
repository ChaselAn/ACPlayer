//
//  ACPlayerLayerView.swift
//  playerDemo
//
//  Created by ancheng on 2017/6/30.
//  Copyright © 2017年 ac. All rights reserved.
//

import UIKit
import AVFoundation

protocol ACPlayerLayerViewDelegate: NSObjectProtocol {
  func controlViewSetProgress(loadedDuration: TimeInterval, totalDuration: TimeInterval)
}
class ACPlayerLayerView: UIView {
  
  enum PlayerObserverName {
    static let status = "status"
    static let loadedTimeRanges = "loadedTimeRanges"
    static let playbackBufferEmpty = "playbackBufferEmpty"
    static let playbackLikelyToKeepUp = "playbackLikelyToKeepUp"
  }
  
  var videoGravity: String = AVLayerVideoGravityResizeAspect {
    didSet {
      playerLayer.videoGravity = videoGravity
    }
  }
  
  weak var delegate: ACPlayerLayerViewDelegate?
  
  private(set) var playerItem: AVPlayerItem?
  private(set) var player: AVPlayer?
  private var playerLayer: AVPlayerLayer!

  func play() {
    player?.play()
  }
  
  func pause() {
    player?.pause()
  }
  
  func seek(to second: Int, completionHandler: @escaping (Bool)->()) {
    player?.seek(to: CMTimeMake(CMTimeValue(second), 1), toleranceBefore: CMTimeMake(1, 1), toleranceAfter: CMTimeMake(1, 1), completionHandler: completionHandler)
  }
  
  func setupPlayer(resourceType: ACPlayer.ResourceType) {
    switch resourceType {
    case .asset(let asset):
      playerItem = AVPlayerItem(asset: asset)
    case .URL(let url):
      playerItem = AVPlayerItem(url: url)
    case .URLString(let urlStr):
      if let url = URL(string: urlStr) {
        playerItem = AVPlayerItem(url: url)
      } else {
//        playerStatus = .error
      }
    default:
      break
//      playerStatus = .none
    }
    player = AVPlayer(playerItem: playerItem)
    
    playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = UIScreen.main.bounds
    playerLayer.videoGravity = videoGravity
    layer.addSublayer(playerLayer)
    
    addObserver()
  }
  
  private func addObserver() {
    playerItem?.addObserver(self, forKeyPath: PlayerObserverName.status, options: NSKeyValueObservingOptions.new, context: nil)
    playerItem?.addObserver(self, forKeyPath: PlayerObserverName.loadedTimeRanges, options: NSKeyValueObservingOptions.new, context: nil)
    playerItem?.addObserver(self, forKeyPath: PlayerObserverName.playbackBufferEmpty, options: NSKeyValueObservingOptions.new, context: nil)
    playerItem?.addObserver(self, forKeyPath: PlayerObserverName.playbackLikelyToKeepUp, options: NSKeyValueObservingOptions.new, context: nil)
    if let _ = playerItem {
      NotificationCenter.default.addObserver(self, selector: #selector(playEnd),
                                             name: .AVPlayerItemDidPlayToEndTime,
                                             object: nil)
    }
  }
  
  deinit {
    playerItem?.removeObserver(self, forKeyPath: PlayerObserverName.status)
    playerItem?.removeObserver(self, forKeyPath: PlayerObserverName.loadedTimeRanges)
    playerItem?.removeObserver(self, forKeyPath: PlayerObserverName.playbackBufferEmpty)
    playerItem?.removeObserver(self, forKeyPath: PlayerObserverName.playbackLikelyToKeepUp)
    NotificationCenter.default.removeObserver(self)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard let item = object as? AVPlayerItem, let keyPath = keyPath else { return }
    switch keyPath {
    case PlayerObserverName.status:
      break
    case PlayerObserverName.loadedTimeRanges:
      if let timeInterVarl = self.availableDuration() {
        let totalDuration = CMTimeGetSeconds(item.duration)
        delegate?.controlViewSetProgress(loadedDuration: timeInterVarl, totalDuration: totalDuration)
//        handleView.controlView.setProgress(loadedDuration: timeInterVarl, totalDuration: totalDuration)
//        handleView.totalDuration = totalDuration
//        handleView.controlView.totalDuration = totalDuration
      }
    case PlayerObserverName.playbackBufferEmpty:
//      handleView.controlView.showLoading()
      break
    case PlayerObserverName.playbackLikelyToKeepUp:
//      handleView.controlView.hideLoading()
      break
    default:
      break
    }
  }
  
  @objc private func playEnd() {
//    playerStatus = .end
//    handleView.controlView.playEnd()
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

}
