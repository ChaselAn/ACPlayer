//
//  ACPlayerControlView.swift
//  playerDemo
//
//  Created by ancheng on 2017/5/15.
//  Copyright © 2017年 ac. All rights reserved.
//

import UIKit

@objc protocol ACPlayerControlViewDelegate {

  func controlView(controlView: ACPlayerControlView, didClickedButton button: UIButton)

  func controlView(controlView: ACPlayerControlView, slider: UISlider, onSliderEvent event: UIControlEvents)
  
}

class ACPlayerControlView: UIView {
  
  public enum ButtonType: Int {
    case play       = 101
    case back       = 102
    case fullscreen = 103
    case replay     = 104
  }

  @IBOutlet private weak var progressSlider: UISlider!
  @IBOutlet private weak var fastForwardView: UIView!
  @IBOutlet private weak var bottomView: UIView!
  @IBOutlet private weak var topView: UIView!
  @IBOutlet private weak var progressView: UIProgressView!
  @IBOutlet private weak var currentTimeLabel: UILabel!
  @IBOutlet private weak var totalTimeLabel: UILabel!
  
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet private weak var backButton: UIButton!
  @IBOutlet private weak var fullScreenButton: UIButton!
  @IBOutlet private weak var replayButton: UIButton!
  
  @IBOutlet private weak var fullScreenButtonWidthConst: NSLayoutConstraint!
  
  weak var delegate: ACPlayerControlViewDelegate?
  var totalDuration: TimeInterval = 0
  
  private var isShow = true
  private var hideWorkItem: DispatchWorkItem?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchBegan))
    addGestureRecognizer(tapGesture)
    progressSlider.setThumbImage(#imageLiteral(resourceName: "ACPlayer_slider_thumb"), for: .normal)
    fastForwardView.layer.cornerRadius = 4
    fastForwardView.layer.masksToBounds = true
    
    playButton.tag = ButtonType.play.rawValue
    backButton.tag = ButtonType.back.rawValue
    fullScreenButton.tag = ButtonType.fullscreen.rawValue
    replayButton.tag = ButtonType.replay.rawValue
    
    fullScreenButtonWidthConst.constant = 0
    
    autoHideControlView()
  }
  
  @IBAction func backBtnClicked(_ sender: UIButton) {
    delegate?.controlView(controlView: self, didClickedButton: sender)
  }

  @IBAction func playBtnClicked(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    delegate?.controlView(controlView: self, didClickedButton: sender)
    autoHideControlView()
  }
  
  @IBAction func sliderTouchBegan(_ sender: UISlider) {
    delegate?.controlView(controlView: self, slider: sender, onSliderEvent: .touchDown)
  }
  
  @IBAction func sliderValueChanged(_ sender: UISlider) {
    autoHideControlView()
    let currentTime = Double(sender.value) * totalDuration
    currentTimeLabel.text = ACPlayerTools.formatTimeIntervalToString(currentTime)
  }
  
  @IBAction func sliderTouchEnded(_ sender: UISlider) {
    autoHideControlView()
    delegate?.controlView(controlView: self, slider: sender, onSliderEvent: .touchUpInside)
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
