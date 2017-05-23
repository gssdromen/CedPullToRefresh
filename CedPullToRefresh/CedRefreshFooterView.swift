//
//  CedRefreshFooterView.swift
//  CedPullToRefresh
//
//  Created by gssdromen on 13/10/2016.
//  Copyright © 2016 CedricWu. All rights reserved.
//

import UIKit

class CedRefreshFooterView: CedRefreshView {
    var needsLayout = true
    var isEmpty = false

    // MARK: - Views About
    override func addMyViews() {
        addSubview(loadingAnimator.loadingView)
    }

    override func layoutMyViews() {
        loadingAnimator.loadingView.frame = bounds
    }

    override func contentSizeChangeAction() {
        super.contentSizeChangeAction()

        if let scrollView = scrollView {
            frame.origin.y = scrollView.contentSize.height + scrollView.contentInset.bottom
        }
    }

    override func contentOffsetChangeAction(contentOffset: CGPoint) {
        super.contentOffsetChangeAction(contentOffset: contentOffset)

        guard scrollView != nil else {
            return
        }

        if isEmpty {
            if loadingState != .empty {
                loadingState = .empty
                loadingAnimator.empty()
            }

            return
        }

        // 未滚动时隐藏底部
        if scrollView!.contentSize.height <= 0.0 || scrollView!.contentOffset.y + scrollView!.contentInset.top <= 0.0 {
            alpha = 0.0
            return
        } else {
            alpha = 1.0
        }

        var curOffset: CGFloat = 0
        var scrollOffsetStart: CGFloat = 0
        var scrollOffsetThreshold: CGFloat = 0
        var percent: CGFloat = 0

        // 内容大于一屏幕
        if scrollView!.contentSize.height + scrollView!.contentInset.top > scrollView!.bounds.size.height {
            curOffset = scrollView!.contentOffset.y + scrollView!.bounds.size.height + scrollView!.contentInset.bottom
            scrollOffsetStart = scrollView!.contentSize.height
            scrollOffsetThreshold = scrollOffsetStart + bounds.height

            percent = abs(curOffset - scrollOffsetStart) / bounds.height

        } else {
            curOffset = scrollView!.contentOffset.y + scrollView!.contentInset.top
            scrollOffsetStart = 0
            scrollOffsetThreshold = scrollOffsetStart + bounds.height

            percent = abs(curOffset - scrollOffsetStart) / bounds.height
        }

//        print("===============")
//        print(curOffset)
//        print(scrollOffsetStart)
//        print(scrollOffsetThreshold)
//        print("===============")

        if curOffset < scrollOffsetStart {

        } else if curOffset < scrollOffsetThreshold { // 未到达刷新触发线
            if loadingState == .pulling || loadingState == .done || loadingState == .empty {
                loadingState = .pulling
                if loadingAnimator != nil {
                    loadingAnimator.startPulling(percent: percent)
                }
            }
        } else if curOffset >= scrollOffsetThreshold { // 到达刷新触发线
            if loadingState == .pulling || loadingState == .empty {
                loadingState = .releaseToRefresh
                if loadingAnimator != nil {
                    loadingAnimator.releaseToRefresh(percent: percent)
                }
            }
        }

        if scrollView!.isTracking == false && loadingState == .releaseToRefresh {
            setContentInsetForRefreshing()
            if loadingAnimator != nil {
                loadingAnimator.refreshing(percent: percent)
            }
            if triggerAction != nil {
                triggerAction!()
            }
        }
    }

    override func setContentInsetForRefreshing() {
        super.setContentInsetForRefreshing()

        guard scrollView != nil else {
            return
        }

        var currentInset = scrollView!.contentInset
        currentInset.bottom = bounds.height
        setContentInset(edgeInsets: currentInset)
    }

    override func resetContentInset() {
        super.resetContentInset()
    }

    override func addObserver() {
        super.addObserver()

        if let sc = scrollView {
            if !isObserving {
                isObserving = true
                sc.addObserver(self, forKeyPath: CedRefreshView.observeKeyContentOffset, options: [.new, .initial], context: nil)
                sc.addObserver(self, forKeyPath: CedRefreshView.observeKeyContentSize, options: [.new, .initial], context: nil)
            }
        }
    }

    override func removeObserver() {
        super.removeObserver()

        if let sc = scrollView {
            if isObserving {
                sc.removeObserver(self, forKeyPath: CedRefreshView.observeKeyContentOffset)
                sc.removeObserver(self, forKeyPath: CedRefreshView.observeKeyContentSize)
                isObserving = false
            }
        }
    }

    // MARK: - Life Cycle
    convenience init(frame: CGRect, lp: CedLoadingProtocol? = nil) {
        self.init(frame: frame)
        loadingAnimator = lp == nil ? CedRefreshDefaultFooter() : lp!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if needsLayout {
            layoutMyViews()
            needsLayout = false
        }
    }
    
}
