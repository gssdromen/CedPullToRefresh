//
//  CedRefreshView.swift
//  CedPullToRefresh
//
//  Created by Cedric Wu on 10/10/2016.
//  Copyright © 2016 CedricWu. All rights reserved.
//

import UIKit

private let observeKeyContentOffset = "contentOffset"
private let observeKeyContentSize = "contentSize"

public class CedRefreshView: UIView, CedLoadingProtocol {
    public var isObserving: Bool = false
    
    public var triggeredByUser: Bool = false
    
    public var actionHandler: (() -> Void)? = nil
    
    public var loadingState: LoadingState = LoadingState.Stopped {
        willSet {
            switch newValue {
            case LoadingState.Stopped:
                break
            case LoadingState.Pulling:
                break
            case LoadingState.ReleaseToRefresh:
                break
            case LoadingState.Refreshing:
                break
            }
        }
    }
    
    open var scrollViewOriginContentTopInset: CGFloat = 0
    
    public var scrollView: UIScrollView? {
        return self.superview as? UIScrollView
    }
    
    // MARK: - CedLoadingProtocol
    open func startPulling(offset: CGPoint) {
        
    }
    
    open func releaseToRefresh(offset: CGPoint) {
        
    }
    
    open func refreshing(offset: CGPoint) {
        
    }
    
    open func finishRefresh(offset: CGPoint) {
        
    }
    
    open func stopped() {
        
    }
    
    // MARK: - Public Methods
    public func getLoadingState() -> LoadingState {
        return self.loadingState
    }
    
    public func isTriggeredByUser() -> Bool {
        return self.triggeredByUser
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == observeKeyContentOffset {
            if change != nil {
                let point: CGPoint = (change![NSKeyValueChangeKey.newKey] as! NSValue).cgPointValue
                print(NSStringFromCGPoint(point))
                
                self.contentOffsetChangeAction(contentOffset: point)
            }
        } else if keyPath == observeKeyContentSize {
            self.setNeedsLayout()
        }
    }
    
    public func stopAnimating() {
        self.loadingState = LoadingState.Stopped
        self.resetContentInset()
    }
    
    // MARK: - Internal Methods
    func contentOffsetChangeAction(contentOffset: CGPoint?) {
        guard self.scrollView != nil else {
            return
        }
        let offset: CGPoint = contentOffset == nil ? CGPoint(x: 0, y: 0) : contentOffset!

        if self.loadingState != LoadingState.Refreshing {
            let scrollOffsetThreshold = self.frame.origin.y - self.scrollViewOriginContentTopInset
            if !self.scrollView!.isDragging && self.loadingState == LoadingState.ReleaseToRefresh {
                self.loadingState = LoadingState.Refreshing
                self.refreshing(offset: contentOffset!)
            } else if offset.y >= scrollOffsetThreshold { // 还没到刷新的触发线
                if self.scrollView!.isDragging {
                    if self.loadingState == LoadingState.Stopped {
                        self.loadingState = LoadingState.Pulling
                        self.startPulling(offset: offset)
                    }
                } else {
                    if self.loadingState == LoadingState.Pulling {
                        self.startPulling(offset: offset)
                    }
                }
            } else if offset.y < scrollOffsetThreshold && scrollView!.isDragging { // 到刷新的触发线
                if self.scrollView!.isDragging {
                    if self.loadingState == LoadingState.Pulling {
                        self.loadingState = LoadingState.ReleaseToRefresh
                        self.releaseToRefresh(offset: offset)
                    }
                } else {
                    if self.loadingState == LoadingState.ReleaseToRefresh {
                        self.loadingState = LoadingState.Refreshing
                        self.refreshing(offset: offset)
                        self.setContentInsetForRefreshing()
                        if self.actionHandler != nil {
                            self.actionHandler!()
                        }
                    }
                }
            }
        } else {
            self.loadingState = LoadingState.Refreshing
            if self.actionHandler != nil {
                self.actionHandler!()
            }
        }
        if offset.y == 0 {
            self.loadingState = LoadingState.Stopped
            self.stopped()
            self.resetContentInset()
        }
    }
    
    func setContentInsetForRefreshing() {
        guard self.scrollView != nil else {
            return
        }

        let offset = max(self.scrollView!.contentOffset.y * -1, 0)
        var currentInset = self.scrollView!.contentInset
        currentInset.top = min(offset, self.scrollViewOriginContentTopInset + bounds.height)
        self.setContentInset(edgeInsets: currentInset)
    }
    
    func resetContentInset() {
        guard self.scrollView != nil else {
            return
        }
        
        var currentInset = scrollView!.contentInset
        currentInset.top = scrollViewOriginContentTopInset
        self.setContentInset(edgeInsets: currentInset)
    }
    
    func setContentInset(edgeInsets: UIEdgeInsets) {
        self.scrollView?.contentInset = edgeInsets
    }

}
