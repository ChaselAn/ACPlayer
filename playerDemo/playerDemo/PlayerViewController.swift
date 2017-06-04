//
//  PlayerViewController.swift
//  playerDemo
//
//  Created by ancheng on 2017/3/15.
//  Copyright © 2017年 ac. All rights reserved.
//

import UIKit
import SnapKit

class PlayerViewController: UIViewController {
  
  private var playerView = ACPlayer()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.white
    playerView.frame = UIScreen.main.bounds
    playerView.delegate = self
    playerView.videoURL = .URLString("http://image1.yuanfenba.net/uploads/oss/video/20170317/1489741596853256.mp4")
    playerView.autoPlay()
    view.addSubview(playerView)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    playerView.play()
  }

}

extension PlayerViewController: ACPlayerDelegate {
  func playerViewBackButtonAction() {
    _ = navigationController?.popViewController(animated: true)
  }
}
