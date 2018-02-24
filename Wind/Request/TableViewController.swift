//
//  TableViewController.swift
//  Wind
//
//  Created by tanfanfan on 2017/2/7.
//  Copyright © 2017年 tanfanfan. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var nextPageState = NextPageState<Int>()
    var data: [User] = []
    let client = URLSessionClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadNext()
    }

}


extension TableViewController: NextPageLoadable {
    func performLoad(
        successHandler: @escaping ([User], Bool, Int?) -> (),
        failHandler: @escaping () -> ()) {
        client.send(UserResquest()) { result in
            if let result = result {
                successHandler(
                    result.items,
                    result.hasNext,
                    result.items.last?.id
                )
            }
            else {
                failHandler()
            }
        }
    }
    
}


extension TableViewController {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row == data.count - 1 {
            loadNext()
        }
    }
}
