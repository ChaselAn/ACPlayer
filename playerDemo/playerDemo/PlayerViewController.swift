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
    m.fatherView = self.view
    return m
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let playerView = ACPlayerView()
    playerView.setPlayer(model: model)
    playerView.delegate = self
  }

}

extension PlayerViewController: ACPlayerViewDelegate {
  func playerViewBackButtonAction() {
    _ = navigationController?.popViewController(animated: true)
  }
}
