//
//  ACPlayerControlView.swift
//  playerDemo
//
//  Created by ancheng on 2017/5/15.
//  Copyright © 2017年 ac. All rights reserved.
//

import UIKit

class ACPlayerControlView: UIView {

  @IBOutlet weak var progressSlider: UISlider!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    progressSlider.setThumbImage(#imageLiteral(resourceName: "ACPlayer_slider_thumb"), for: .normal)
  }
}
