//
//  UIRefreshControl+Reactive.swift
//  
//
//  Created by 谢鸿标 on 2022/7/1.
//

import UIKit
import XHBFoundationSwiftLib

extension UIRefreshControl {
    
    public var observation: AnyObservable<Bool, Never> {
        return .init(UIRefreshControl.Action<UIRefreshControl>(output: self,
                                                               events: [.valueChanged]).map {
            let isRefreshing = $0.isRefreshing
            if !isRefreshing { $0.endRefreshing() }
            return isRefreshing
        })
    }
}
