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
  @IBOutlet weak var fastForwardView: UIView!
  @IBOutlet weak var bottomView: UIView!
  @IBOutlet weak var topView: UIView!
  
  private var isShow = false
  private var hideWorkItem: DispatchWorkItem?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchBegan))
    addGestureRecognizer(tapGesture)
    progressSlider.setThumbImage(#imageLiteral(resourceName: "ACPlayer_slider_thumb"), for: .normal)
    fastForwardView.layer.cornerRadius = 4
    fastForwardView.layer.masksToBounds = true
  }
  
  @IBAction func backBtnClicked(_ sender: UIButton) {
  }

  @IBAction func playBtnClicked(_ sender: UIButton) {
  }
  
  @IBAction func sliderTouchBegan(_ sender: UISlider) {
  }
  
  @IBAction func sliderValueChanged(_ sender: UISlider) {
  }
  
  @IBAction func sliderTouchEnded(_ sender: UISlider) {
  }
  
  @IBAction func fullScreenBtnClicked(_ sender: UIButton) {
  }
  
  @IBAction func replayBtnClicked(_ sender: UIButton) {
  }
  
  @objc private func touchBegan() {
    controlViewAnimate(!isShow)
  }
  
  private func controlViewAnimate(_ isShow: Bool) {
    self.isShow = isShow
    let alpha: CGFloat = isShow ? 1 : 0
    
    UIView.animate(withDuration: 0.25, animations: { 
      self.topView.alpha = alpha
      self.bottomView.alpha = alpha
      
    }) { (_) in
      if isShow {
        self.autoHideControlView()
      }
    }
  }
  
  private func autoHideControlView() {
    hideWorkItem?.cancel()
    hideWorkItem = DispatchWorkItem(block: { [weak self] in
      self?.controlViewAnimate(false)
    })
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(5), execute: hideWorkItem!)
  }
}
