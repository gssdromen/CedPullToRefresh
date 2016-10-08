//
//  CedLoadingProtocol.swift
//  CedPullToRefresh
//
//  Created by CedricWu on 16/10/7.
//  Copyright © 2016年 CedricWu. All rights reserved.
//

@objc public protocol CedLoadingProtocol {
    @objc optional func startPulling()
    @objc optional func releaseToRefresh()
    @objc optional func refreshing()
    @objc optional func finishRefresh()
}
