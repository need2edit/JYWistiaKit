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

    /*
 
     Empty state management.  
     Not needed if you're using something like 
     DZNEmptyDataSet on github, but this will do for now.
 
    */
    var loading: Bool = true {
        didSet {
            print(loading)
            tableView.reloadData()
        }
    }
    
    /// A way to grab error messages that leave us with an empty view.
    var currentEmptyMessage: String?
    
    
    /*
 
     
     Theres other options in Wistia Kit but 
     lets keep the data management simple for now with projects/
     
     */
    
    
    
    var projects: [Project] = []
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.clearColor()
        
        refresh()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(MasterListViewController.refresh))
    }

}


// MARK: - Loading Data and Refreshing

extension MasterListViewController {
    
    /*
     
     This refresh method wipes the projects array out each time it loads.  
     In more advanced implementations you could "load more" with paged results.
     
     */

    func refresh() {
        
        
        /*
         
         We list the projects using a completion handler with error catching.
         
         The result looks like this:
         
         public enum CollectionResult<T> {
            case Success([T])
            case Error(ErrorType)
         }
         
         ...which means you can switch on the result and handle errors accordingly.
         
         */
        
        do {
            
            
            // Fetch a list of projects.
            try WistiaKit.list(.Projects, completionHandler: { (result) in
                
                switch result {
                    
                case .Success(let items):
                    
                    /// This could be medias or projects, so we cast the result.
                    self.projects = items as! [Project]
                    
                case .Error(let error):
                    
                    /*
                     
                     Errors exist at Wistia.Error which, along with any ErrorType is handleded here.
                     
                     For more on Errors, play around with the 
                     enums of `Wistia.Error`. Example:
                     
                     throw Wistia.Error.InvalidAPIKey
                     
                     This is based on Wistia's Data API documentation.
                     
                     */
                    dispatch_async(dispatch_get_main_queue(), {
                        self.handleError(error)
                        self.loading = false
                    })
                    
                }
                
            })
            
            
            
        } catch {
            
            // Handle the error on the main queue since it may show an alert.
            dispatch_async(dispatch_get_main_queue(), {
                
                self.handleError(error)
                self.loading = false
            })
        }
    }
    
}

// MARK: UITableViewDataSource with Empty State Management

extension MasterListViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // Show an activity indicator if were loading
        if loading {
            
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activity.startAnimating()
            tableView.backgroundView = activity
            self.tableView.separatorColor = UIColor.clearColor()
            return 0
            
        }
        
        // Reset the background view and restore the separator colors
        else {
            
            tableView.backgroundView = nil
            self.tableView.separatorColor = UIColor.lightGrayColor()
            return 1
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Show a project in a cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = projects[indexPath.row].name
        return cell
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*
         
         In more advanced implementations we'd use some of the 
         data source protocols within WistiaKit for this, but 
         right now we'll handle it here.
         
         We provide a label with a message.  If an error occurs, 
         we show the error message instead of a "No Items" label.
         
         Using something like DZNEmptyDataSet on github is a 
         better way to handle this type of "empty state".
         
         */
        
        if !loading && projects.isEmpty {
            
            let label = UILabel()
            
            if let emptyMessage = currentEmptyMessage {
                label.text = emptyMessage
            } else {
                label.text = "No Projects"
            }
        
            // Some messages can be long, so let's shrink things down.
            label.font = UIFont.systemFontOfSize(11.0)
            
            label.textColor = UIColor.lightGrayColor()
            label.textAlignment = .Center
            tableView.backgroundView = label
        }
        
        return projects.count
        
    }
    
    
    
}

/// Helper Protocol for Requiring Handle Error Logic
protocol CanHandleError {
    
    /**
     Provides logic on what to do with an error.
     
     - Parameter error:   The error conforming to `ErrorType`.  Wistia Errors can be cast as `CustomStringConvertible` which adds a description.
     
     In a view controller, you might show an alert like this:
     
     ```
     if let error = error as? CustomStringConvertible {
     
        let alert = UIAlertController(title: nil, message: error.description, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
     
    }
     ```
     
     */
    func handleError(error: ErrorType)
}

extension MasterListViewController: CanHandleError {
    
    /// Helper Method for Handling Errors
    func handleError(error: ErrorType) {
        
        if let error = error as? CustomStringConvertible {
            
            // Show an alert with the error
            let alert = UIAlertController(title: nil, message: error.description, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // Show the alert from the root view controller in case something is up with your current view controller
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            
            // We also capture this in the Empty View message.
            
            self.currentEmptyMessage = error.description
        }
    }
    
}

