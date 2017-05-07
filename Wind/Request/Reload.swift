//
//  Reload.swift
//  Wind
//
//  Created by tanfanfan on 2017/2/7.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import UIKit

public protocol ReloadableType {
    func reloadData()
}
extension UITableView: ReloadableType {}

extension UICollectionView: ReloadableType {}

public extension NextPageLoadable where Self: UITableViewController {
    func loadNext() {
        loadNext(reloadView: tableView)
    }
}

public extension NextPageLoadable where Self: UICollectionViewController {
    func loadNext() {
        loadNext(reloadView: collectionView!)
    }
}
