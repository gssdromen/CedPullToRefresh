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

extension UIScrollView: CedPullToRefreshCompatible { }

extension CedPullToRefresh where Base: UIScrollView {
    private var cedPullToRefreshView: CedRefreshHeaderView! {
        get {
            return objc_getAssociatedObject(self, &pullToRefreshViewKey) as? CedRefreshHeaderView
        }
        set {
            base.willChangeValue(forKey: pullToRefreshViewKey)
            objc_setAssociatedObject(self, &pullToRefreshViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            base.didChangeValue(forKey: pullToRefreshViewKey)
        }
    }

    // MARK: - Public Methods
    @discardableResult
    public func addPullToRefreshWith(triggerAction: @escaping (() -> Void), loadingProtocol lp: CedLoadingProtocol? = nil) -> CedRefreshHeaderView {
        var loadingProtocol: CedLoadingProtocol = lp ?? CedRefreshDefaultHeader()

        let height = loadingProtocol.triggerOffset
        let width = base.bounds.width == 0 ? UIScreen.main.bounds.width : base.bounds.width

        cedPullToRefreshView = CedRefreshHeaderView(frame: CGRect(x: 0, y: -height, width: width, height: height), lp: loadingProtocol)

        base.insertSubview(cedPullToRefreshView, at: 0)
        cedPullToRefreshView.triggerAction = triggerAction
        cedPullToRefreshView.loadingAnimator = loadingProtocol
        cedPullToRefreshView.scrollViewOriginContentInset = base.contentInset

        return cedPullToRefreshView
    }

    public var showsPullToRefresh: Bool {
        return cedPullToRefreshView != nil ? cedPullToRefreshView!.isHidden : false
    }

    public func triggerPullToRefresh() {
        if let view = cedPullToRefreshView {
            UIView.animate(withDuration: 0.2, animations: {
                view.startAnimating()
            })
        }
    }

    public func stopPullToRefresh() {
        if let view = cedPullToRefreshView {
            UIView.animate(withDuration: 0.2, animations: {
                view.stopAnimating()
            })
        }
    }
}
