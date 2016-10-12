//
//  CedPullToRefresh.swift
//  CedPullToRefresh
//
//  Created by CedricWu on 16/10/7.
//  Copyright © 2016年 CedricWu. All rights reserved.
//

import UIKit

private var pullToRefreshViewKey = "CedPullToRefreshView"

private let observeKeyContentOffset = "contentOffset"
private let observeKeyContentSize = "contentSize"

private let defaultPullToRefreshViewHeight: CGFloat = 60

public extension UIScrollView {
    
    private var cedPullToRefreshView: CedRefreshView? {
        get {
            return objc_getAssociatedObject(self, &pullToRefreshViewKey) as? CedRefreshView
        }
        set {
            self.willChangeValue(forKey: pullToRefreshViewKey)
            objc_setAssociatedObject(self, &pullToRefreshViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            self.didChangeValue(forKey: pullToRefreshViewKey)
        }
    }

    public func ced_setCustomPullToRefreshView(refreshView: CedRefreshView) {
        self.cedPullToRefreshView = refreshView
    }
    
    public func ced_addPullToRefreshWith(actionHandler: @escaping (() -> Void)) {
        if self.cedPullToRefreshView == nil {
            // 启用默认View
            self.cedPullToRefreshView = CedRefreshHeaderView(frame: CGRect(x: 0, y: -defaultPullToRefreshViewHeight, width: self.bounds.width, height: defaultPullToRefreshViewHeight))
        }
        self.insertSubview(self.cedPullToRefreshView!, at: 0)
        self.cedPullToRefreshView?.actionHandler = actionHandler
        self.ced_setShowsPullToRefresh(true)
    }
    
    public func ced_setShowsPullToRefresh(_ showsPullToRefresh: Bool) {
        guard self.cedPullToRefreshView != nil else {
            return
        }
        self.cedPullToRefreshView!.isHidden = !showsPullToRefresh
        if showsPullToRefresh {
            self.ced_addPullToRefreshObservers()
        } else {
            self.ced_removePullToRefreshObservers()
        }
    }
    
    func ced_addPullToRefreshObservers() {
        if self.cedPullToRefreshView != nil {
            if !self.cedPullToRefreshView!.isObserving {
                self.addObserver(self.cedPullToRefreshView!, forKeyPath: observeKeyContentOffset, options: .new, context: nil)
                self.addObserver(self.cedPullToRefreshView!, forKeyPath: observeKeyContentSize, options: .new, context: nil)
                self.cedPullToRefreshView!.isObserving = true
            }
        }
    }
    
    func ced_removePullToRefreshObservers() {
        if self.cedPullToRefreshView != nil {
            if self.cedPullToRefreshView!.isObserving {
                self.removeObserver(self.cedPullToRefreshView!, forKeyPath: observeKeyContentOffset)
                self.removeObserver(self.cedPullToRefreshView!, forKeyPath: observeKeyContentSize)
                self.cedPullToRefreshView!.isObserving = false
            }
        }
    }

    public var ced_showsPullToRefresh: Bool {
        return self.cedPullToRefreshView != nil ? self.cedPullToRefreshView!.isHidden : false
    }

    public func ced_triggerPullToRefresh() {
        if self.cedPullToRefreshView != nil {
            self.cedPullToRefreshView!.refreshing(offset: CGPoint(x: 0, y: 0))
        }
    }

}

