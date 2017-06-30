//
//  ACPlayerLoadingView.swift
//  playerDemo
//
//  Created by ancheng on 2017/6/30.
//  Copyright © 2017年 ac. All rights reserved.
//

import UIKit

class ACPlayerLoadingView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    isHidden = true
    backgroundColor = UIColor.clear
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    isHidden = true
    backgroundColor = UIColor.clear
  }

  func startAnimating() {
    isHidden = false
    setUpAnimation()
  }
  
  func stopAnimating() {
    isHidden = true
    layer.sublayers?.removeAll()
  }
  
  private final func setUpAnimation() {
    var animationRect = UIEdgeInsetsInsetRect(frame, UIEdgeInsets.zero)
    let minEdge = min(animationRect.width, animationRect.height)
    
    layer.sublayers = nil
    animationRect.size = CGSize(width: minEdge, height: minEdge)
    
    setUpAnimation(in: layer, size: animationRect.size, color: UIColor.white)
  }
  
  private func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
    let circleSize = size.width / 5
    
    for i in 0 ..< 5 {
      let factor = Float(i) * 1 / 5
      let circle = layerWith(size: CGSize(width: circleSize, height: circleSize), color: color)
      let animation = rotateAnimation(factor, x: layer.bounds.size.width / 2, y: layer.bounds.size.height / 2, size: CGSize(width: size.width - circleSize, height: size.height - circleSize))
      
      circle.frame = CGRect(x: 0, y: 0, width: circleSize, height: circleSize)
      circle.add(animation, forKey: "animation")
      layer.addSublayer(circle)
    }
  }
  
  private func rotateAnimation(_ rate: Float, x: CGFloat, y: CGFloat, size: CGSize) -> CAAnimationGroup {
    let duration: CFTimeInterval = 1.5
    let fromScale = 1 - rate
    let toScale = 0.2 + rate
    let timeFunc = CAMediaTimingFunction(controlPoints: 0.5, 0.15 + rate, 0.25, 1)
    
    let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
    scaleAnimation.duration = duration
    scaleAnimation.repeatCount = HUGE
    scaleAnimation.fromValue = fromScale
    scaleAnimation.toValue = toScale
    
    let positionAnimation = CAKeyframeAnimation(keyPath: "position")
    positionAnimation.duration = duration
    positionAnimation.repeatCount = HUGE
    positionAnimation.path = UIBezierPath(arcCenter: CGPoint(x: x, y: y), radius: size.width / 2, startAngle: CGFloat(3 * Double.pi * 0.5), endAngle: CGFloat(3 * Double.pi * 0.5 + 2 * Double.pi), clockwise: true).cgPath
    
    let animation = CAAnimationGroup()
    animation.animations = [scaleAnimation, positionAnimation]
    animation.timingFunction = timeFunc
    animation.duration = duration
    animation.repeatCount = HUGE
    animation.isRemovedOnCompletion = false
    
    return animation
  }
  
  private func layerWith(size: CGSize, color: UIColor) -> CALayer {
    let layer: CAShapeLayer = CAShapeLayer()
    let path: UIBezierPath = UIBezierPath()
    
    path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                radius: size.width / 2,
                startAngle: 0,
                endAngle: CGFloat(2 * Double.pi),
                clockwise: false)
    layer.fillColor = color.cgColor
    
    layer.backgroundColor = nil
    layer.path = path.cgPath
    layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    
    return layer
  }

  
}
