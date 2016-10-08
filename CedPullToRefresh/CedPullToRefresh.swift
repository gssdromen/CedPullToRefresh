//
//  CedPullToRefresh.swift
//  CedPullToRefresh
//
//  Created by CedricWu on 16/10/7.
//  Copyright © 2016年 CedricWu. All rights reserved.
//

import UIKit

private var pullToRefreshViewKey: Void?
private let observeKeyContentOffset = "contentOffset"
private let observeKeyFrame = "frame"

private let ICSPullToRefreshViewHeight: CGFloat = 60

public typealias ActionHandler = () -> ()

public extension UIScrollView{
    
    public var icsPullToRefreshView: ICSPullToRefreshView? {
        get {
            return objc_getAssociatedObject(self, &pullToRefreshViewKey) as? ICSPullToRefreshView
        }
        set(newValue) {
            self.willChangeValue(forKey: "ICSPullToRefreshView")
            objc_setAssociatedObject(self, &pullToRefreshViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            self.didChangeValue(forKey: "ICSPullToRefreshView")
        }
    }
    
    public var ics_showsPullToRefresh: Bool {
        return icsPullToRefreshView != nil ? icsPullToRefreshView!.isHidden : false
    }
    
    public func ics_addPullToRefreshHandler(_ actionHandler: @escaping ActionHandler){
        if icsPullToRefreshView == nil {
            icsPullToRefreshView = ICSPullToRefreshView(frame: CGRect(x: CGFloat(0), y: -ICSPullToRefreshViewHeight, width: self.bounds.width, height: ICSPullToRefreshViewHeight))
            addSubview(icsPullToRefreshView!)
            icsPullToRefreshView?.scrollViewOriginContentTopInset = contentInset.top
        }
        icsPullToRefreshView?.actionHandler = actionHandler
        ics_setShowsPullToRefresh(true)
    }
    
    public func ics_triggerPullToRefresh() {
        icsPullToRefreshView?.state = .triggered
        icsPullToRefreshView?.startAnimating()
    }
    
    public func ics_setShowsPullToRefresh(_ showsPullToRefresh: Bool) {
        if icsPullToRefreshView == nil {
            return
        }
        icsPullToRefreshView!.isHidden = !showsPullToRefresh
        if showsPullToRefresh{
            ics_addPullToRefreshObservers()
        }else{
            ics_removePullToRefreshObservers()
        }
    }
    
    func ics_addPullToRefreshObservers() {
        if icsPullToRefreshView?.isObserving != nil && !icsPullToRefreshView!.isObserving{
            addObserver(icsPullToRefreshView!, forKeyPath: observeKeyContentOffset, options:.new, context: nil)
            addObserver(icsPullToRefreshView!, forKeyPath: observeKeyFrame, options:.new, context: nil)
            icsPullToRefreshView!.isObserving = true
        }
    }
    
    func ics_removePullToRefreshObservers() {
        if icsPullToRefreshView?.isObserving != nil && icsPullToRefreshView!.isObserving{
            removeObserver(icsPullToRefreshView!, forKeyPath: observeKeyContentOffset)
            removeObserver(icsPullToRefreshView!, forKeyPath: observeKeyFrame)
            icsPullToRefreshView!.isObserving = false
        }
    }
    
    
}

open class ICSPullToRefreshView: UIView {
    open var actionHandler: ActionHandler?
    open var isObserving: Bool = false
    var triggeredByUser: Bool = false
    
    open var scrollView: UIScrollView? {
        return self.superview as? UIScrollView
    }
    
    open var scrollViewOriginContentTopInset: CGFloat = 0
    
    public enum State {
        case stopped
        case triggered
        case loading
        case all
    }
    
    open var state: State = .stopped {
        willSet {
            if state != newValue {
                self.setNeedsLayout()
                switch newValue{
                case .loading:
                    setScrollViewContentInsetForLoading()
                    if state == .triggered {
                        actionHandler?()
                    }
                default:
                    break
                }
            }
        }
        didSet {
            switch state {
            case .stopped:
                resetScrollViewContentInset()
                
            default:
                break
            }
        }
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    open func startAnimating() {
        if scrollView == nil {
            return
        }
        
        animate {
            self.scrollView?.setContentOffset(CGPoint(
                x: self.scrollView!.contentOffset.x,
                y: -(self.scrollView!.contentInset.top + self.bounds.height)
            ), animated: false)
        }
        
        triggeredByUser = true
        state = .loading
    }
    
    open func stopAnimating() {
        state = .stopped
        if triggeredByUser {
            animate {
                self.scrollView?.setContentOffset(CGPoint(
                    x: self.scrollView!.contentOffset.x,
                    y: -self.scrollView!.contentInset.top
                ), animated: false)
            }
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == observeKeyContentOffset {
            if change != nil {
                let point: CGPoint = (change![NSKeyValueChangeKey.newKey] as! NSValue).cgPointValue
                srollViewDidScroll(point)
            }
        } else if keyPath == observeKeyFrame {
            setNeedsLayout()
        }
    }
    
    fileprivate func srollViewDidScroll(_ contentOffset: CGPoint?) {
        //        if contentOffset != nil {
        //            print(NSStringFromCGPoint(contentOffset!))
        //        }
        
        if scrollView == nil || contentOffset == nil{
            return
        }
        if state != .loading {
            let scrollOffsetThreshold = frame.origin.y - scrollViewOriginContentTopInset
            if !scrollView!.isDragging && state == .triggered {
                state = .loading
            } else if contentOffset!.y < scrollOffsetThreshold && scrollView!.isDragging && state == .stopped {
                state = .triggered
            } else if contentOffset!.y >= scrollOffsetThreshold && state != .stopped {
                state = .stopped
            }
        }
    }
    
    fileprivate func setScrollViewContentInset(_ contentInset: UIEdgeInsets) {
        animate {
            self.scrollView?.contentInset = contentInset
        }
    }
    
    fileprivate func resetScrollViewContentInset() {
        if scrollView == nil {
            return
        }
        var currentInset = scrollView!.contentInset
        currentInset.top = scrollViewOriginContentTopInset
        setScrollViewContentInset(currentInset)
    }
    
    fileprivate func setScrollViewContentInsetForLoading() {
        if scrollView == nil {
            return
        }
        let offset = max(scrollView!.contentOffset.y * -1, 0)
        var currentInset = scrollView!.contentInset
        currentInset.top = min(offset, scrollViewOriginContentTopInset + bounds.height)
        setScrollViewContentInset(currentInset)
    }
    
    fileprivate func animate(_ animations: @escaping () -> ()) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.allowUserInteraction, .beginFromCurrentState],
                       animations: animations
        ) { _ in
            self.setNeedsLayout()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        defaultView.frame = self.bounds
        activityIndicator.center = defaultView.center
        switch state {
        case .stopped:
            activityIndicator.stopAnimating()
        case .loading:
            activityIndicator.startAnimating()
        default:
            break
        }
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        if superview != nil && newSuperview == nil {
            if scrollView?.ics_showsPullToRefresh != nil && scrollView!.ics_showsPullToRefresh{
                scrollView?.ics_removePullToRefreshObservers()
            }
        }
    }
    
    // MARK: Basic Views
    func initViews() {
        addSubview(defaultView)
        defaultView.addSubview(activityIndicator)
    }
    
    lazy var defaultView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = false
        return activityIndicator
    }()
    
    open func setActivityIndicatorColor(_ color: UIColor) {
        activityIndicator.color = color
    }
    
    open func setActivityIndicatorStyle(_ style: UIActivityIndicatorViewStyle) {
        activityIndicator.activityIndicatorViewStyle = style
    }
    
}
