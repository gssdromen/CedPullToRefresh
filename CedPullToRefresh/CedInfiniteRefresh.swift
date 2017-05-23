//
//  CedInfiniteRefresh.swift
//  CedPullToRefresh
//
//  Created by cedricwu on 2/24/17.
//  Copyright © 2017 CedricWu. All rights reserved.
//

import UIKit

private var infiniteRefreshViewKey = "CedRefreshFooterView"

private let observeKeyContentOffset = "contentOffset"
private let observeKeyContentSize = "contentSize"

private let defaultPullToRefreshViewHeight: CGFloat = 60

public extension UIScrollView {

    private var cedInfiniteRefreshView: CedRefreshFooterView! {
        get {
            return objc_getAssociatedObject(self, &infiniteRefreshViewKey) as? CedRefreshFooterView
        }
        set {
            willChangeValue(forKey: infiniteRefreshViewKey)
            objc_setAssociatedObject(self, &infiniteRefreshViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            didChangeValue(forKey: infiniteRefreshViewKey)
        }
    }

    public var ced_showsInfiniteScrolling: Bool {
        guard let infiniteScrollingView = cedInfiniteRefreshView else {
            return false
        }
        return !infiniteScrollingView.isHidden
    }

    public func ced_addInfiniteRefreshWith(triggerAction: @escaping (() -> Void), loadingProtocol lp: CedLoadingProtocol? = nil) {
        var loadingProtocol: CedLoadingProtocol = lp == nil ? CedRefreshDefaultFooter() : lp!

        let height = loadingProtocol.triggerOffset

        cedInfiniteRefreshView = CedRefreshFooterView(frame: CGRect(x: 0, y: contentSize.height, width: bounds.width, height: height), lp: loadingProtocol)

        addSubview(cedInfiniteRefreshView)
        cedInfiniteRefreshView.triggerAction = triggerAction
        cedInfiniteRefreshView.loadingAnimator = loadingProtocol
        cedInfiniteRefreshView.scrollViewOriginContentInset = contentInset
    }
    
    public func ced_triggerInfiniteScrolling() {
        if let view = cedInfiniteRefreshView {
            UIView.animate(withDuration: 0.2, animations: {
                view.startAnimating()
            })
        }
    }
    
    public func ced_stopInfiniteScrolling() {
        if let view = cedInfiniteRefreshView {
            UIView.animate(withDuration: 0.2, animations: {
                view.stopAnimating()
            })
        }
    }

    public func ced_needMoreData() {
        if let view = cedInfiniteRefreshView {
            view.isEmpty = false
        }
    }

    public func ced_setNoMoreData() {
        if let view = cedInfiniteRefreshView {
            view.isEmpty = true
        }
    }
}
