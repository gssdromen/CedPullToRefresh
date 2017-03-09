//
//  CedRefreshView.swift
//  CedPullToRefresh
//
//  Created by Cedric Wu on 10/10/2016.
//  Copyright © 2016 CedricWu. All rights reserved.
//

import UIKit

public enum LoadingState {
    case done
    case pulling
    case releaseToRefresh
    case refreshing
}


public class CedRefreshView: UIView {
    internal static let observeKeyContentOffset = "contentOffset"
    internal static let observeKeyContentSize = "contentSize"

    public var triggerAction: (() -> Void)? = nil

    public var loadingView: UIView = UIView()

    public var loadingState: LoadingState = LoadingState.done {
        willSet {
            switch newValue {
            case LoadingState.done:
                break
            case LoadingState.pulling:
                break
            case LoadingState.releaseToRefresh:
                break
            case LoadingState.refreshing:
                break
            }
        }
    }

    public var isObserving: Bool = false

    public var scrollViewOriginContentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    public var loadingAnimator: CedLoadingProtocol! = nil

    public var scrollView: UIScrollView? {
        return superview as? UIScrollView
    }

    // MARK: - Public Methods
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if isObserving {
            if keyPath == CedRefreshView.observeKeyContentOffset {
                if change != nil {
                    if let point: CGPoint = (change![NSKeyValueChangeKey.newKey] as? NSValue)?.cgPointValue {
                        contentOffsetChangeAction(contentOffset: point)
                    }
                }
            } else if keyPath == CedRefreshView.observeKeyContentSize {
                contentSizeChangeAction()
            }
        }
    }

    public func startAnimating() {
        loadingState = LoadingState.refreshing
        setContentInsetForRefreshing()
        if triggerAction != nil {
            triggerAction!()
        }
    }

    public func stopAnimating() {
        loadingState = LoadingState.done
        resetContentInset()
    }

    // MARK: - Internal Methods
    func addMyViews() {
    }

    func layoutMyViews() {
    }

    func addObserver() {
    }

    func removeObserver() {
    }

    func contentSizeChangeAction() {
    }

    func contentOffsetChangeAction(contentOffset: CGPoint) {
    }

    func setContentInsetForRefreshing() {
    }

    func resetContentInset() {
    }

    func setContentInset(edgeInsets: UIEdgeInsets) {
        scrollView?.contentInset = edgeInsets
    }

    // MARK: - Life Cycle
    deinit {
        removeObserver()
    }

    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        addMyViews()
        layoutMyViews()

        removeObserver()

        DispatchQueue.main.async { [weak self] in
            self?.addObserver()
        }
    }
}
