//
//  CedLoadingProtocol.swift
//  CedPullToRefresh
//
//  Created by CedricWu on 16/10/7.
//  Copyright © 2016年 CedricWu. All rights reserved.
//

import UIKit



public protocol CedLoadingProtocol {
    
    /// 开始滚动
    ///
    /// - Parameter percent: 0到1的CGFloat，表示百分比
    func startPulling(percent: CGFloat)
    
    
    /// 释放后开始更新
    ///
    /// - Parameter percent: 大于1的CGFloat，减1后表示超过的百分比
    func releaseToRefresh(percent: CGFloat)
    
    
    /// 开始更新状态
    ///
    /// - Parameter percent: 大于1的CGFloat，减1后表示超过的百分比，最后会变成1
    func refreshing(percent: CGFloat)
    
    
    /// 表示更新完成
    func done()

    var loadingView: UIView { get }
    var triggerOffset: CGFloat { get set }
}
