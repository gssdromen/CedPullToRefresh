//
//  CedLoadingProtocol.swift
//  CedPullToRefresh
//
//  Created by CedricWu on 16/10/7.
//  Copyright © 2016年 CedricWu. All rights reserved.
//

public enum LoadingState {
    case Stopped
    case Pulling
    case ReleaseToRefresh
    case Refreshing
    case Finishing
}

public protocol CedLoadingProtocol {
    func startPulling(offset: CGPoint)
    func releaseToRefresh(offset: CGPoint)
    func refreshing(offset: CGPoint)
    func finishRefresh(offset: CGPoint)

    var loadingState: LoadingState { get set }
    var triggeredByUser: Bool { get set }
    var isObserving: Bool { get set }
    var actionHandler: (() -> Void)? { get set }
}
