//
//  PlayerViewController.swift
//  playerDemo
//
//  Created by ancheng on 2017/3/15.
//  Copyright © 2017年 ac. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
  
  private lazy var model: ACPlayerModel = {
    let m = ACPlayerModel()
    m.videoURL = URL(string: "http://image1.yuanfenba.net/uploads/oss/video/20170317/1489741596853256.mp4")
    m.fatherView = self.view
    return m
  }()
  private var playerView = ACPlayerView()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.white
//    let playerView = ACPlayerView()
    playerView.frame = UIScreen.main.bounds
    playerView.setPlayer(model: model)
    playerView.delegate = self
    playerView.autoPlayVideo()
    view.addSubview(playerView)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    playerView.play()
  }

}

extension PlayerViewController: ACPlayerViewDelegate {
  func playerViewBackButtonAction() {
    _ = navigationController?.popViewController(animated: true)
  }
}
