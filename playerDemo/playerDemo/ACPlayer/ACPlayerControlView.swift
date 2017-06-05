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
  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var currentTimeLabel: UILabel!
  @IBOutlet weak var totalTimeLabel: UILabel!
  
  weak var handlePlayer: ACPlayer?
  
  private var isShow = true
  private var hideWorkItem: DispatchWorkItem?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchBegan))
    addGestureRecognizer(tapGesture)
    progressSlider.setThumbImage(#imageLiteral(resourceName: "ACPlayer_slider_thumb"), for: .normal)
    fastForwardView.layer.cornerRadius = 4
    fastForwardView.layer.masksToBounds = true
    autoHideControlView()
  }
  
  @IBAction func backBtnClicked(_ sender: UIButton) {
    guard let handlePlayer = handlePlayer else { return }
    handlePlayer.delegate?.backButtonDidClicked(in: handlePlayer)
  }

  @IBAction func playBtnClicked(_ sender: UIButton) {
    guard let handlePlayer = handlePlayer else { return }
    switch handlePlayer.playerStatus {
    case .playing:
      handlePlayer.pause()
      sender.isSelected = true
    case .pause:
      handlePlayer.play()
      sender.isSelected = false
    case .end:
      handlePlayer.replay()
      sender.isSelected = false
    default:
      break
    }
    autoHideControlView()
  }
  
  @IBAction func sliderTouchBegan(_ sender: UISlider) {
    
  }
  
  @IBAction func sliderValueChanged(_ sender: UISlider) {
    
  }
  
  @IBAction func sliderTouchEnded(_ sender: UISlider) {
    autoHideControlView()
  }
  
  @IBAction func fullScreenBtnClicked(_ sender: UIButton) {
  }
  
  @IBAction func replayBtnClicked(_ sender: UIButton) {
  }
  
  @objc private func touchBegan() {
    controlViewAnimate(!isShow)
  }
  
  func setProgress(loadedDuration: TimeInterval , totalDuration: TimeInterval) {
    progressView.setProgress(Float(loadedDuration) / Float(totalDuration), animated: true)
  }
  
  func setTimeAndSlider(currentTime: TimeInterval, totalTime: TimeInterval) {
    currentTimeLabel.text = ACPlayerTools.formatTimeIntervalToString(currentTime)
    totalTimeLabel.text = ACPlayerTools.formatTimeIntervalToString(totalTime)
    progressSlider.value = Float(currentTime) / Float(totalTime)
  }
  
  private func controlViewAnimate(_ isShow: Bool) {
    self.isShow = isShow
    let alpha: CGFloat = isShow ? 1 : 0
    UIApplication.shared.setStatusBarHidden(!isShow, with: .fade)
    
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
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(3), execute: hideWorkItem!)
  }

  deinit {
    print("ACPlayerControlView deinit")
  }
}
