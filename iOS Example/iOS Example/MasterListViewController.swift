//
//  ViewController.swift
//  iOS Example
//
//  Created by Jake Young on 4/15/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import UIKit
import WistiaKit

class MasterListViewController: UITableViewController {

    var projects: [Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try Wistia.list(.Projects) { (items) in
                self.projects = items as! [Project]
            }
        } catch {
            print(error)
        }
        
    }

}

extension MasterListViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    
    
}

