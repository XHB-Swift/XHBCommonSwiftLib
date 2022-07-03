//
//  UITableView+Reactive.swift
//  
//
//  Created by 谢鸿标 on 2022/7/3.
//

import UIKit
import XHBFoundationSwiftLib

public final class AnyClosure {
    public let hash: UUID
    public let closure: Any
    
    deinit {
        #if DEBUG
        print("Released self = \(self)")
        #endif
    }
    
    public init(closure: Any) {
        self.hash = UUID()
        self.closure = closure
    }
}

extension AnyClosure: Hashable {
    public static func == (lhs: AnyClosure, rhs: AnyClosure) -> Bool {
        return lhs.hash == rhs.hash
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(hash)
    }
}

extension UITableView {
    public typealias SectionClosure = (_ tableView: UITableView) -> Int
    public typealias RowClosure = (_ tableView: UITableView, _ section: Int) -> Int
    public typealias CellClosure = (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell
}

open class UITableViewDataSourceObject: NSObject {
    
    open weak var tableView: UITableView?
    private var closures = Set<AnyClosure>()
    private static let EmptyPlaceHolder = "EmptyPlaceholder"
    
    deinit {
        closures.removeAll()
        #if DEBUG
        print("Released self = \(self)")
        #endif
    }
    
    public init(_ tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.EmptyPlaceHolder)
    }
    
    open func register(closure: AnyClosure) {
        closures.insert(closure)
    }
    
    open func register(closures: [AnyClosure]) {
        if closures.isEmpty { return }
        closures.forEach { [weak self] closure in
            self?.register(closure: closure)
        }
    }
    
    open func removeAllClosures() {
        closures.removeAll()
    }
}

extension UITableViewDataSourceObject: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let closureObject = closures.first,
              let closure = closureObject.closure as? UITableView.SectionClosure else { return 1 }
        return closure(tableView)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let closureObject = closures.first,
              let closure = closureObject.closure as? UITableView.RowClosure else { return 0 }
        return closure(tableView, section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let closureObject = closures.first,
              let closure = closureObject.closure as? UITableView.CellClosure else {
            return UITableViewCell(style: .default, reuseIdentifier: Self.EmptyPlaceHolder)
        }
        return closure(tableView, indexPath)
    }
}

fileprivate class UITableViewDataSourceObserver: ObjCDelegateObserver<UITableView, UITableViewDataSource, UITableViewDataSourceObject> {
    
    override func notify<Value>(value: Value) {
        guard let tableView = self.base as? UITableView else { return }
        tableView.reloadData()
    }
}

extension UITableView {
    
    @discardableResult
    open func subscribed<S: Collection, E, Cell: UITableViewCell>
    (items: S, for cell: Cell.Type = Cell.self, identifier: String, configuration: @escaping (IndexPath, E, Cell) -> Void)
    -> ValueObservable<S> where S.Element == E, S.Index == Int {
        let observable = specifiedValueObservable(value: items, queue: .main)
        let dataSourceObject = UITableViewDataSourceObject(self)
        let observer = UITableViewDataSourceObserver(self, dataSourceObject)
        register(cell, forCellReuseIdentifier: identifier)
        let rowClosure: RowClosure = { (tableView, section) -> Int in
            return items.count
        }
        let cellClosure: CellClosure = { (tableView, indexPath) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            if let specifiedCell = cell as? Cell {
                configuration(indexPath, items[indexPath.row], specifiedCell)
            }
            return cell
        }
        dataSourceObject.register(closures: [
            .init(closure: rowClosure),
            .init(closure: cellClosure)
        ])
        observable.add(observer: observer)
        return observable
    }
    
}
