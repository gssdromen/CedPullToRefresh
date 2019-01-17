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

public final class CedPullToRefresh<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol CedPullToRefreshCompatible {
    associatedtype CompatibleType
    var ced: CompatibleType { get }
}

public extension CedPullToRefreshCompatible {
    public var ced: CedPullToRefresh<Self> {
        get { return CedPullToRefresh(self) }
    }
}

public extension UIScrollView {
    public var cedPullToRefreshView: CedRefreshHeaderView! {
        get {
            return objc_getAssociatedObject(self, &pullToRefreshViewKey) as? CedRefreshHeaderView
        }
        set {
            willChangeValue(forKey: pullToRefreshViewKey)
            objc_setAssociatedObject(self, &pullToRefreshViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            didChangeValue(forKey: pullToRefreshViewKey)
        }
    }
}

extension UIScrollView: CedPullToRefreshCompatible { }

extension CedPullToRefresh where Base: UIScrollView {
    // MARK: - Public Methods
    @discardableResult
    public func addPullToRefreshWith(triggerAction: @escaping (() -> Void), loadingProtocol lp: CedLoadingProtocol? = nil) -> CedRefreshHeaderView {
        var loadingProtocol: CedLoadingProtocol = lp ?? CedRefreshDefaultHeader()

        let height = loadingProtocol.triggerOffset
        let width = base.bounds.width == 0 ? UIScreen.main.bounds.width : base.bounds.width

        let headerView = CedRefreshHeaderView(frame: CGRect(x: 0, y: -height, width: width, height: height), lp: loadingProtocol)

        base.insertSubview(headerView, at: 0)
        headerView.triggerAction = triggerAction
        headerView.loadingAnimator = loadingProtocol
        headerView.scrollViewOriginContentInset = base.contentInset
        base.cedPullToRefreshView = headerView

        return headerView
    }

    public var showsPullToRefresh: Bool {
        return base.cedPullToRefreshView != nil ? base.cedPullToRefreshView!.isHidden : false
    }

    public func triggerPullToRefresh() {
        if let view = base.cedPullToRefreshView {
            UIView.animate(withDuration: 0.2, animations: {
                view.startAnimating()
            })
        }
    }

    public func stopPullToRefresh() {
        if let view = base.cedPullToRefreshView {
            UIView.animate(withDuration: 0.2, animations: {
                view.stopAnimating()
            })
        }
    }
}
