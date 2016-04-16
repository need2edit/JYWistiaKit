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
    case Info(rows: [Row])
    case Children(String, items: [AnyObject]?)
}

enum Row {
    case ValuePair(value: String?, label: String?)
    
    var info: (value: String?, label: String?) {
        switch self {
        case .ValuePair(value: let value, label: let label):
            return (value, label)
        }
    }
}

class DetailTableViewController: UITableViewController {
    
    var detailItem: WistiaDataItem? {
        didSet {
            if let detail = detailItem as? Project {
                self.title = "Project"
                self.tableView.reloadData()
            }
        }
    }
    
    var project: Project? { return detailItem as? Project }
    var media: Media? { return detailItem as? Media }
    
    var sections: [Section]? {
        
        guard let project = project else { return [] }
        
        return [
            .Info(rows:
                [
                    Row.ValuePair(value: "Title", label: project.name),
                    Row.ValuePair(value: "Description", label: project.description)
                ]
            ),
            .Children("Medias", items: project.medias)
        ]
        
        
    }
    
    var requestType: WistiaItemRequestType? {
        
        didSet {
            
            refresh()
            
        }
        
    }
    
    // Load the new data showing the resources.
    func refresh() {
        
        if let request = requestType {
            
            do {
                
                try WistiaKit.show(request, completionHandler: { (result) in
                    
                    switch result {
                    case .Success(let item):
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.detailItem = item
                        })
                        
                        
                    case .Error(let error):
                        self.handleError(error)
                    }
                })
                
            } catch {
                
                dispatch_async(dispatch_get_main_queue(), { 
                    self.handleError(error)
                })
                
            }
            
        }
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return sections?.count ?? 0
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let currentSection = sections?[section] {
            switch currentSection {
            case .Info(let rows):
                return rows.count
            case .Children(_, items: let items):
                return items?.count ?? 0
            }
        }
        
        return 0
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let currentSection = sections?[section] else { return nil }
        
        switch currentSection {
            case .Info:
                return nil
            case .Children(let header, items: _):
                return header
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = (indexPath.section == 0) ? "SubtitleCell" : "Cell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)

        if let currentSection = sections?[indexPath.section] {
          
        switch currentSection {
        case .Info(let rows):
            let rowInfo = rows[indexPath.row]
            cell.textLabel?.text = rowInfo.info.value
            cell.detailTextLabel?.text = rowInfo.info.label
        case .Children(_, items: let items):
            guard let item = items?[indexPath.row] as? Media else { break }
            cell.textLabel?.text = item.name
        }

        }

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
