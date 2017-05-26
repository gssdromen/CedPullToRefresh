//
//  CedRefreshDefaultHeader.swift
//  CedPullToRefreshTest
//
//  Created by Cedric Wu on 26/02/2017.
//  Copyright © 2017 Cedric Wu. All rights reserved.
//

import UIKit

class CedRefreshDefaultHeader: UIView, CedLoadingProtocol {
    
    var triggerOffset: CGFloat = 60
    var loadingView: UIView { return self }

    let statusLabel = UILabel()
    
    func startPulling(percent: CGFloat) {
        statusLabel.text = "startPulling"
    }
    
    func releaseToRefresh(percent: CGFloat) {
        statusLabel.text = "releaseToRefresh"
    }
    
    func refreshing(percent: CGFloat) {
        statusLabel.text = "refreshing"
    }
    
    func done() {
        statusLabel.text = "done"
    }

    func resetForMoreData() {
        
    }

    func setForNoMoreData() {
        statusLabel.text = "no data"
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(statusLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        statusLabel.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
