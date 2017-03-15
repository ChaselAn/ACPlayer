//
//  ACPlayerModel.swift
//  playerDemo
//
//  Created by ancheng on 2017/3/15.
//  Copyright © 2017年 ac. All rights reserved.
//

import UIKit

class ACPlayerModel: NSObject {
  /** 视频标题 */
  var title = ""
  /** 视频URL */
  var videoURL: URL? = nil
  /** 视频封面本地图片 */
  var placeholderImage: UIImage? = nil
  /**
   * 视频封面网络图片url
   * 如果和本地图片同时设置，则忽略本地图片，显示网络图片
   */
  var placeholderImageURLString = ""
  /** 视频分辨率 */
  var resolutionDic: [String: String] = [:]
  /** 从xx秒开始播放视频(默认0) */
  var seekTime = 0
  // cell播放视频，以下属性必须设置值
//  var tableView = UITableView()
  /** cell所在的indexPath */
//  var indexPath = IndexPath()
  /** 播放器View的父视图（必须指定父视图）*/
  weak var fatherView: UIView!

}
