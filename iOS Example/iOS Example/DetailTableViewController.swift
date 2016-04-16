//
//  DetailTableViewController.swift
//  iOS Example
//
//  Created by Jake Young on 4/16/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import UIKit
import WistiaKit

enum Section {
    case Info(String, String)
    case Children([WistiaDataItem])
}

class DetailTableViewController: UITableViewController {
    
    var detailItem: WistiaDataItem?
    
    var requestType: WistiaItemRequestType? {
        
        didSet {
            
            if let request = requestType {
            
                do {
                    
                    try WistiaKit.show(request, completionHandler: { (result) in
                        
                        switch result {
                        case .Success(let item):
                            self.detailItem = item
                        case .Error(let error):
                            self.handleError(error)
                        }
                    })
                    
                } catch {
                    
                    handleError(error)
                    
                }
                
            }
            
        }
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if let project = detailItem as? Project {
            return 2
        }
        
        if let media = detailItem as? Media {
            return 2
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let project = detailItem as? Project {
            return 2
        }
        
        if let media = detailItem as? Media {
            
            switch section {
            case 0:
                return 2
            case 1:
                return media.assets.count
            }
            
            return media.assets.count
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }

}

extension DetailTableViewController: CanHandleError {
        
        /// Helper Method for Handling Errors
        func handleError(error: ErrorType) {
            
            if let error = error as? CustomStringConvertible {
                
                // Show an alert with the error
                let alert = UIAlertController(title: nil, message: error.description, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                // Show the alert from the root view controller in case something is up with your current view controller
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            }
        }
}
