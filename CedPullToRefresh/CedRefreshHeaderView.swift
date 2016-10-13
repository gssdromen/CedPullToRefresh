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
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    // MARK: - Animate
    override func startPulling(offset: CGPoint) {
        super.startPulling(offset: offset)
        print("in startPulling")
    }
    
    override func releaseToRefresh(offset: CGPoint) {
        super.releaseToRefresh(offset: offset)
        print("in releaseToRefresh")
    }
    
    override func refreshing(offset: CGPoint) {
        super.refreshing(offset: offset)
        print("in refreshing")
    }
    
    override func stopped() {
        super.stopped()
        print("in stopped")
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
        self.backgroundColor = UIColor.gray
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
