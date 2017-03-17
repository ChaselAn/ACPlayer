//
//  ACPlayerView.swift
//  playerDemo
//
//  Created by ancheng on 2017/3/15.
//  Copyright © 2017年 ac. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

protocol ACPlayerViewDelegate: NSObjectProtocol {
  
  func playerViewBackButtonAction()
  
}
class ACPlayerView: UIView {
  
  var videoGravity: String = AVLayerVideoGravityResizeAspect
  weak var delegate: ACPlayerViewDelegate?
  
//  private var urlAsset: AVURLAsset!
  private var playerModel: ACPlayerModel!
  private var videoUrl: URL!
//  private var playerItem: AVPlayerItem!
  private var isAutoPlay = false
  private var player: AVPlayer!

  init() {
    super.init(frame: CGRect.zero)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func setPlayer(controlView: UIView? = nil, model: ACPlayerModel) {
    assert(model.fatherView != nil, "please set fatherView first!")
    self.playerModel = model
    self.videoUrl = model.videoURL
  }
  
  func autoPlayVideo() {
    let urlAsset = AVURLAsset(url: videoUrl)
    // 初始化playerItem
    let playerItem = AVPlayerItem(asset: urlAsset)
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    player = AVPlayer(playerItem: playerItem)
    
    // 初始化playerLayer
    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = UIScreen.main.bounds
//    backgroundColor = UIColor.black
    // 此处为默认视频填充模式
    playerLayer.videoGravity = videoGravity
    layer.addSublayer(playerLayer)
    // 自动播放
    isAutoPlay = true
    
//     //添加播放进度计时器
//    [self createTimer];
//    
//    // 获取系统音量
//    [self configureVolume];
//    
//    // 本地文件不设置ZFPlayerStateBuffering状态
//    if ([self.videoURL.scheme isEqualToString:@"file"]) {
//      self.state = ZFPlayerStatePlaying;
//      self.isLocalVideo = YES;
//      [self.controlView zf_playerDownloadBtnState:NO];
//    } else {
//      self.state = ZFPlayerStateBuffering;
//      self.isLocalVideo = NO;
//      [self.controlView zf_playerDownloadBtnState:YES];
//    }
    // 开始播放
//    play()
//    self.isPauseByUser = NO;
  }
  
  func play() {
    player.play()
  }
  
}
