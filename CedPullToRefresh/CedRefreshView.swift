//
//  CedRefreshView.swift
//  CedPullToRefresh
//
//  Created by Cedric Wu on 10/10/2016.
//  Copyright © 2016 CedricWu. All rights reserved.
//

import UIKit

class CedRefreshView: UIView, CedLoadingProtocol {
    var loadingState: LoadingState = LoadingState.Finished {
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
    
    var triggeredByUser: Bool = false
    
    var actionHandler: (() -> Void)? = nil

    // MARK: - CedLoadingProtocol
    func startPulling(offset: CGPoint) {
        
    }
    
    func releaseToRefresh(offset: CGPoint) {
        
    }
    
    func refreshing(offset: CGPoint) {
        
    }
    
    func finishRefresh(offset: CGPoint) {
        
    }
    
    // MARK: - Public Methods
    public func getLoadingState() -> LoadingState {
        return self.loadingState
    }
    
    public func isTriggeredByUser() -> Bool {
        return self.triggeredByUser
    }
}
