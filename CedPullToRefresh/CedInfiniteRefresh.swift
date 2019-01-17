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
    public var cedInfiniteRefreshView: CedRefreshFooterView! {
        get {
            return objc_getAssociatedObject(self, &infiniteRefreshViewKey) as? CedRefreshFooterView
        }
        set {
            willChangeValue(forKey: infiniteRefreshViewKey)
            objc_setAssociatedObject(self, &infiniteRefreshViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            didChangeValue(forKey: infiniteRefreshViewKey)
        }
    }
}

extension CedPullToRefresh where Base: UIScrollView {
    public var showsInfiniteScrolling: Bool {
        return base.cedInfiniteRefreshView == nil ? false : base.cedInfiniteRefreshView.isHidden
    }

    @discardableResult
    public func addInfiniteRefreshWith(triggerAction: @escaping (() -> Void), loadingProtocol lp: CedLoadingProtocol? = nil) -> CedRefreshFooterView {
        var loadingProtocol: CedLoadingProtocol = lp ?? CedRefreshDefaultFooter()

        let height = loadingProtocol.triggerOffset
        let width = base.bounds.width == 0 ? UIScreen.main.bounds.width : base.bounds.width

        let cedInfiniteRefreshView = CedRefreshFooterView(frame: CGRect(x: 0, y: base.contentSize.height + base.contentInset.bottom, width: width, height: height), lp: loadingProtocol)

        base.addSubview(cedInfiniteRefreshView)
        cedInfiniteRefreshView.triggerAction = triggerAction
        cedInfiniteRefreshView.loadingAnimator = loadingProtocol
        cedInfiniteRefreshView.scrollViewOriginContentInset = base.contentInset
        base.cedInfiniteRefreshView = cedInfiniteRefreshView

        return cedInfiniteRefreshView
    }

    public func triggerInfiniteScrolling() {
        if let view = base.cedInfiniteRefreshView {
            UIView.animate(withDuration: 0.2, animations: {
                view.startAnimating()
            })
        }
    }

    public func stopInfiniteScrolling() {
        if let view = base.cedInfiniteRefreshView {
            UIView.animate(withDuration: 0.2, animations: {
                view.stopAnimating()
            })
        }
    }

    public func needMoreData() {
        if let view = base.cedInfiniteRefreshView {
            view.isEmpty = false
            if let loadingAnimator = view.loadingAnimator {
                loadingAnimator.resetForMoreData()
            }
            view.loadingState = .empty
        }
    }

    public func setNoMoreData() {
        if let view = base.cedInfiniteRefreshView {
            view.isEmpty = true
            if let loadingAnimator = view.loadingAnimator {
                loadingAnimator.setForNoMoreData()
            }
            view.loadingState = .done
        }
    }
}
