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

    var loading: Bool = true {
        didSet {
            print(loading)
            tableView.reloadData()
        }
    }
    
    var currentEmptyMessage: String?
    
    var projects: [Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.clearColor()
        
        refresh()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(MasterListViewController.refresh))
    }
    
    func refresh() {
        do {
            
            try WistiaKit.list(.Projects, completionHandler: { (result) in
                
                switch result {
                    
                case .Success(let items):
                    self.projects = items as! [Project]
                case .Error(let error):
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.handleError(error)
                        self.loading = false
                    })
                    
                }
                
            })
            
        } catch {
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.handleError(error)
                self.loading = false
            })
        }
    }

}

extension MasterListViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if loading {
            
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activity.startAnimating()
            tableView.backgroundView = activity
            return 0
            
        }
        
        else {
            
            tableView.backgroundView = nil
            self.tableView.separatorColor = UIColor.clearColor()
            return 1
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = projects[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !loading && projects.isEmpty {
            
            let label = UILabel()
            
            if let emptyMessage = currentEmptyMessage {
                label.text = emptyMessage
            } else {
                label.text = "No Projects"
            }
        
            label.font = UIFont.systemFontOfSize(11.0)
            
            label.textColor = UIColor.lightGrayColor()
            label.textAlignment = .Center
            tableView.backgroundView = label
        }
        return projects.count
    }
    
    
    
}


extension MasterListViewController {
    
    func handleError(error: ErrorType) {
        
        if let error = error as? CustomStringConvertible {
            let alert = UIAlertController(title: nil, message: error.description, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            self.currentEmptyMessage = error.description
        }
    }
    
}

