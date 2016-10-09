//
//  CedLoadingProtocol.swift
//  CedPullToRefresh
//
//  Created by CedricWu on 16/10/7.
//  Copyright © 2016年 CedricWu. All rights reserved.
//

public enum LoadingState {
    case Pulling
    case ReleaseToRefresh
    case Refreshing
    case Finished
}

public protocol CedLoadingProtocol {
    func startPulling()
    func releaseToRefresh()
    func refreshing()
    func finishRefresh()

    var loadingState: LoadingState { get set }
    var triggeredByUser: Bool { get set }
    var actionHandler: (() -> Void)? { get set }
}
