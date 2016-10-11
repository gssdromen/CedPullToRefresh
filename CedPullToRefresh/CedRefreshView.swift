//
//  CedRefreshView.swift
//  CedPullToRefresh
//
//  Created by Cedric Wu on 10/10/2016.
//  Copyright © 2016 CedricWu. All rights reserved.
//

import UIKit

public class CedRefreshView: UIView, CedLoadingProtocol {
    public var loadingState: LoadingState = LoadingState.Finished {
        willSet {
            if self.loadingState != newValue {
                // 更新UI
                let point = CGPoint(x: 0, y: 0)
                switch newValue{
                case LoadingState.Finished:
                    self.finishRefresh(offset: point)
                    break
                case LoadingState.Pulling:
                    self.startPulling(offset: point)
                    break
                case LoadingState.Refreshing:
                    self.refreshing(offset: point)
                    break
                case LoadingState.ReleaseToRefresh:
                    self.releaseToRefresh(offset: point)
                    break
                }
            }
        }
        didSet {
            
        }
    }
    
    public var isObserving: Bool = false
    
    public var triggeredByUser: Bool = false
    
    public var actionHandler: (() -> Void)? = nil

    // MARK: - CedLoadingProtocol
    public func startPulling(offset: CGPoint) {
        
    }
    
    public func releaseToRefresh(offset: CGPoint) {
        
    }
    
    public func refreshing(offset: CGPoint) {
        
    }
    
    public func finishRefresh(offset: CGPoint) {
        
    }
    
    // MARK: - Public Methods
    public func getLoadingState() -> LoadingState {
        return self.loadingState
    }
    
    public func isTriggeredByUser() -> Bool {
        return self.triggeredByUser
    }
}
