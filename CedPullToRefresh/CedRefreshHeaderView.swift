//
//  CedRefreshHeaderView.swift
//  CedPullToRefresh
//
//  Created by gssdromen on 07/10/2016.
//  Copyright © 2016 CedricWu. All rights reserved.
//

import UIKit

class CedRefreshHeaderView: UIView, CedLoadingProtocol {
    
    internal var loadingState: LoadingState = LoadingState.Finished {
        willSet {
            if self.loadingState != newValue {
                // 更新UI
                switch newValue{
                case LoadingState.Finished:
                    self.finishRefresh()
                    break
                case LoadingState.Pulling:
                    self.startPulling()
                    break
                case LoadingState.Refreshing:
                    self.refreshing()
                    break
                case LoadingState.ReleaseToRefresh:
                    self.releaseToRefresh()
                    break
                }
            }
        }
        didSet {

        }
    }
    
    internal var triggeredByUser: Bool = false
    
    internal var actionHandler: (() -> Void)? = nil

    var needsLayout = true
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    // MARK: - CedLoadingProtocol
    func startPulling(offset: CGPoint) {
        
    }

    func releaseToRefresh(offset: CGPoint) {

    }

    func refreshing(offset: CGPoint) {

    }

    func finishRefresh(offset: CGPoint) {

    }
    
    // MARK: - Public Methods
    public func getLoadingState() -> LoadingState {
        return self.loadingState
    }
    
    public func isTriggeredByUser() -> Bool {
        return self.triggeredByUser
    }

    // MARK: - Views About
    func addMyViews() {
        self.activityIndicator.hidesWhenStopped = true
        self.addSubview(self.activityIndicator)
    }

    func layoutMyViews() {
        self.activityIndicator.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }

    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addMyViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if self.needsLayout {
            self.layoutMyViews()
            self.needsLayout = false
        }
    }
}
