//
//  CedInfiniteRefresh.swift
//  CedPullToRefresh
//
//  Created by cedricwu on 2/24/17.
//  Copyright © 2017 CedricWu. All rights reserved.
//

import UIKit

private var infiniteRefreshViewKey = "CedInfiniteRefreshView"

private let observeKeyContentOffset = "contentOffset"
private let observeKeyContentSize = "contentSize"

private let defaultPullToRefreshViewHeight: CGFloat = 60

public extension UIScrollView {

    private var cedInfiniteRefreshView: CedRefreshView? {
        get {
            return objc_getAssociatedObject(self, &infiniteRefreshViewKey) as? CedRefreshView
        }
        set {
            self.willChangeValue(forKey: infiniteRefreshViewKey)
            objc_setAssociatedObject(self, &infiniteRefreshViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            self.didChangeValue(forKey: infiniteRefreshViewKey)
        }
    }

    public var ced_showsInfiniteScrolling: Bool {
        guard let infiniteScrollingView = cedInfiniteRefreshView else {
            return false
        }
        return !infiniteScrollingView.isHidden
    }

    public func ced_addInfiniteScrollingWithHandler(actionHandler: @escaping (() -> Void)){
        if cedInfiniteRefreshView == nil {
            cedInfiniteRefreshView = CedRefreshFooterView(frame: CGRect(x: CGFloat(0), y: contentSize.height, width: bounds.width, height: defaultPullToRefreshViewHeight))
            addSubview(cedInfiniteRefreshView!)
            cedInfiniteRefreshView?.autoresizingMask = .flexibleWidth
//            cedInfiniteRefreshView?.scrollViewOriginContentBottomInset = contentInset.bottom
        }
        cedInfiniteRefreshView?.actionHandler = actionHandler
        ced_setShowsInfiniteScrolling(true)
    }

    public func ced_triggerInfiniteScrolling() {
//        cedInfiniteRefreshView?.state = .triggered
//        cedInfiniteRefreshView?.startAnimating()
    }

    public func ced_setShowsInfiniteScrolling(_ showsInfiniteScrolling: Bool) {
        guard let infiniteScrollingView = cedInfiniteRefreshView else {
            return
        }
        infiniteScrollingView.isHidden = !showsInfiniteScrolling
        if showsInfiniteScrolling {
            addInfiniteScrollingViewObservers()
        } else {
            removeInfiniteScrollingViewObservers()
            infiniteScrollingView.setNeedsLayout()
            infiniteScrollingView.frame = CGRect(x: CGFloat(0), y: contentSize.height, width: infiniteScrollingView.bounds.width, height: defaultPullToRefreshViewHeight)
        }
    }

    fileprivate func addInfiniteScrollingViewObservers() {
        guard let infiniteScrollingView = cedInfiniteRefreshView, !infiniteScrollingView.isObserving else {
            return
        }
        addObserver(infiniteScrollingView, forKeyPath: observeKeyContentOffset, options:.new, context: nil)
        addObserver(infiniteScrollingView, forKeyPath: observeKeyContentSize, options:.new, context: nil)
        infiniteScrollingView.isObserving = true
    }

    fileprivate func removeInfiniteScrollingViewObservers() {
        guard let infiniteScrollingView = cedInfiniteRefreshView, infiniteScrollingView.isObserving else {
            return
        }
        removeObserver(infiniteScrollingView, forKeyPath: observeKeyContentOffset)
        removeObserver(infiniteScrollingView, forKeyPath: observeKeyContentSize)
        infiniteScrollingView.isObserving = false
    }

}
