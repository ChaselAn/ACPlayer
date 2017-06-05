//
//  ACPlayerTools.swift
//  playerDemo
//
//  Created by ancheng on 2017/6/5.
//  Copyright © 2017年 ac. All rights reserved.
//

import Foundation

class ACPlayerTools {
  static func formatTimeIntervalToString(_ time: TimeInterval) -> String {
    let min = Int(time / 60)
    let sec = Int(time.truncatingRemainder(dividingBy: 60))
    return String(format: "%02d:%02d", min, sec)
  }
}

typealias TimerExcuteClosure = @convention(block) () -> ()

extension Timer {
  private class ACTimerActionBlockWrapper : NSObject {
    var block : TimerExcuteClosure
    init(block: @escaping TimerExcuteClosure) {
      self.block = block
    }
  }
  
  class func ac_scheduledTimerWithTimeInterval(_ ti:TimeInterval, closure: @escaping TimerExcuteClosure, repeats yesOrNo: Bool) -> Timer {
    return self.scheduledTimer(timeInterval: ti, target: self, selector: #selector(ac_excuteTimerClosure(_:)), userInfo: ACTimerActionBlockWrapper(block: closure), repeats: true)
  }
  
  @objc private class func ac_excuteTimerClosure(_ timer: Timer) {
    if let action = timer.userInfo as? ACTimerActionBlockWrapper {
      action.block()
    }
  }
}
