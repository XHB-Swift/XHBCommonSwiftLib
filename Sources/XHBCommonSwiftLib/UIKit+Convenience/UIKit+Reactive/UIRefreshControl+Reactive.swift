//
//  UIRefreshControl+Reactive.swift
//  
//
//  Created by 谢鸿标 on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UIRefreshControl {
    
    @discardableResult
    open func subscribeRefresing(action: @escaping UIControlEventsAction<UIRefreshControl>) -> ValueObservable<Bool> {
        return UIControl.subscribe(control: self,
                                   value: self.isRefreshing) { control in
            if control.isRefreshing {
                control.beginRefreshing()
            } else {
                control.endRefreshing()
            }
            action(control)
        }
    }
    
}
