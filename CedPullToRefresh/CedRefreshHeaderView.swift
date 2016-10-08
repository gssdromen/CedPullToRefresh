//
//  CedRefreshHeaderView.swift
//  CedPullToRefresh
//
//  Created by gssdromen on 07/10/2016.
//  Copyright © 2016 CedricWu. All rights reserved.
//

import UIKit

class CedRefreshHeaderView: UIView, CedLoadingProtocol {
    
    var needsLayout = true

    // MARK: - CedLoadingProtocol
    func startPulling() {
        
    }
    
    func releaseToRefresh() {
        
    }
    
    func refreshing() {
        
    }
    
    func finishRefresh() {
        
    }
    
    // MARK:
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.needsLayout {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
