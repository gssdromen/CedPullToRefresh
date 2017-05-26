//
//  CedRefreshHeaderView.swift
//  CedPullToRefresh
//
//  Created by gssdromen on 07/10/2016.
//  Copyright © 2016 CedricWu. All rights reserved.
//

import UIKit

class CedRefreshHeaderView: CedRefreshView {
    var needsLayout = true

    // MARK: - Views About
    override func addMyViews() {
        addSubview(loadingAnimator.loadingView)
    }

    override func layoutMyViews() {
        loadingAnimator.loadingView.frame = bounds
    }

    override func contentOffsetChangeAction(contentOffset: CGPoint) {
        super.contentOffsetChangeAction(contentOffset: contentOffset)

        let scrollOffsetStart: CGFloat = 0
        let scrollOffsetThreshold: CGFloat = 0 - bounds.height
        let percent: CGFloat = abs(contentOffset.y - scrollOffsetStart) / bounds.height

        guard contentOffset.y < scrollOffsetStart else {
            return
        }

        if contentOffset.y > scrollOffsetThreshold { // 还没到刷新的触发线
            if loadingState == .pulling || loadingState == .done || loadingState == .releaseToRefresh {
                loadingState = .pulling
                if loadingAnimator != nil {
                    loadingAnimator.startPulling(percent: percent)
                }
            }
        } else if contentOffset.y <= scrollOffsetThreshold { // 到刷新的触发线
            if loadingState == .pulling {
                loadingState = .releaseToRefresh
                if loadingAnimator != nil {
                    loadingAnimator.releaseToRefresh(percent: percent)
                }
            }
        }
        if let sc = scrollView {
            if sc.isTracking == false && loadingState == .releaseToRefresh {
                loadingState = .refreshing
                if loadingAnimator != nil {
                    loadingAnimator.refreshing(percent: percent)
                }
                if triggerAction != nil {
                    triggerAction!()
                }
                setContentInsetForRefreshing()
            }
        }
    }

    // MARK: - 无需手势直接代码触发
    override func startAnimating() {
        super.startAnimating()

        if let sv = scrollView {
            sv.contentOffset.y = -bounds.height
        }
    }

    override func stopAnimating() {
        super.stopAnimating()

        if let sv = scrollView {
            sv.contentOffset.y = 0
        }
        if loadingAnimator != nil {
            loadingAnimator.done()
        }
    }

    // MARK: - 设置更新时的Inset
    override func setContentInsetForRefreshing() {
        super.setContentInsetForRefreshing()
        guard scrollView != nil else {
            return
        }

        let offset = max(scrollView!.contentOffset.y * -1, 0)
        var currentInset = scrollView!.contentInset
        currentInset.top = min(offset, scrollViewOriginContentInset.top + bounds.height)
        setContentInset(edgeInsets: currentInset)
    }

    override func resetContentInset() {
        super.resetContentInset()
        guard scrollView != nil else {
            return
        }

        setContentInset(edgeInsets: scrollViewOriginContentInset)
    }

    override func addObserver() {
        super.addObserver()

        if let sc = scrollView {
            if !isObserving {
                sc.addObserver(self, forKeyPath: CedRefreshView.observeKeyContentOffset, options: [.new, .initial], context: nil)
                sc.addObserver(self, forKeyPath: CedRefreshView.observeKeyContentSize, options: [.new, .initial], context: nil)
                isObserving = true
            }
        }
    }

    override func removeObserver() {
        super.removeObserver()

        if let sc = self.scrollView {
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
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if self.needsLayout {
            self.layoutMyViews()
            self.needsLayout = false
        }
    }
}
