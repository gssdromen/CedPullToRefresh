//
//  CedPullToRefresh.swift
//  CedPullToRefresh
//
//  Created by CedricWu on 16/10/7.
//  Copyright © 2016年 CedricWu. All rights reserved.
//

import UIKit

private var pullToRefreshViewKey = "CedRefreshHeaderView"



private let defaultPullToRefreshViewHeight: CGFloat = 60

public extension UIScrollView {
    private var cedPullToRefreshView: CedRefreshHeaderView! {
        get {
            return objc_getAssociatedObject(self, &pullToRefreshViewKey) as? CedRefreshHeaderView
        }
        set {
            willChangeValue(forKey: pullToRefreshViewKey)
            objc_setAssociatedObject(self, &pullToRefreshViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            didChangeValue(forKey: pullToRefreshViewKey)
        }
    }

    // MARK: - Public Methods
    public func ced_addPullToRefreshWith(triggerAction: @escaping (() -> Void), loadingProtocol lp: CedLoadingProtocol? = nil) {
        var loadingProtocol: CedLoadingProtocol = lp == nil ? CedRefreshDefaultHeader() : lp!

        let height = loadingProtocol.triggerOffset

        cedPullToRefreshView = CedRefreshHeaderView(frame: CGRect(x: 0, y: -height, width: self.bounds.width, height: height), lp: loadingProtocol)

        insertSubview(cedPullToRefreshView, at: 0)
        cedPullToRefreshView.triggerAction = triggerAction
        cedPullToRefreshView.loadingAnimator = loadingProtocol
        cedPullToRefreshView.scrollViewOriginContentInset = contentInset
    }
    
    public var ced_showsPullToRefresh: Bool {
        return cedPullToRefreshView != nil ? cedPullToRefreshView!.isHidden : false
    }
    
    public func ced_triggerPullToRefresh() {
        if let view = cedPullToRefreshView {
            UIView.animate(withDuration: 0.2, animations: { 
                view.startAnimating()
            })
        }
    }
    
    public func ced_stopPullToRefresh() {
        if let view = cedPullToRefreshView {
            UIView.animate(withDuration: 0.2, animations: { 
                view.stopAnimating()
            })
        }
    }
}

