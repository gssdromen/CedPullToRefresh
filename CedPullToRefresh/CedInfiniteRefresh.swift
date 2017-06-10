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

extension CedPullToRefresh where Base: UIScrollView {
    private var cedInfiniteRefreshView: CedRefreshFooterView! {
        get {
            return objc_getAssociatedObject(self, &infiniteRefreshViewKey) as? CedRefreshFooterView
        }
        set {
            base.willChangeValue(forKey: infiniteRefreshViewKey)
            objc_setAssociatedObject(self, &infiniteRefreshViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            base.didChangeValue(forKey: infiniteRefreshViewKey)
        }
    }

    public var showsInfiniteScrolling: Bool {
        guard let infiniteScrollingView = cedInfiniteRefreshView else {
            return false
        }
        return !infiniteScrollingView.isHidden
    }

    @discardableResult
    public func addInfiniteRefreshWith(triggerAction: @escaping (() -> Void), loadingProtocol lp: CedLoadingProtocol? = nil) -> CedRefreshFooterView {
        var loadingProtocol: CedLoadingProtocol = lp ?? CedRefreshDefaultFooter()

        let height = loadingProtocol.triggerOffset
        let width = base.bounds.width == 0 ? UIScreen.main.bounds.width : base.bounds.width

        cedInfiniteRefreshView = CedRefreshFooterView(frame: CGRect(x: 0, y: base.contentSize.height + base.contentInset.bottom, width: width, height: height), lp: loadingProtocol)

        base.addSubview(cedInfiniteRefreshView)
        cedInfiniteRefreshView.triggerAction = triggerAction
        cedInfiniteRefreshView.loadingAnimator = loadingProtocol
        cedInfiniteRefreshView.scrollViewOriginContentInset = base.contentInset

        return cedInfiniteRefreshView
    }

    public func triggerInfiniteScrolling() {
        if let view = cedInfiniteRefreshView {
            UIView.animate(withDuration: 0.2, animations: {
                view.startAnimating()
            })
        }
    }

    public func stopInfiniteScrolling() {
        if let view = cedInfiniteRefreshView {
            UIView.animate(withDuration: 0.2, animations: {
                view.stopAnimating()
            })
        }
    }

    public func needMoreData() {
        if let view = cedInfiniteRefreshView {
            view.isEmpty = false
            if let loadingAnimator = view.loadingAnimator {
                loadingAnimator.resetForMoreData()
            }
            view.loadingState = .empty
        }
    }

    public func setNoMoreData() {
        if let view = cedInfiniteRefreshView {
            view.isEmpty = true
            if let loadingAnimator = view.loadingAnimator {
                loadingAnimator.setForNoMoreData()
            }
            view.loadingState = .done
        }
    }
}
