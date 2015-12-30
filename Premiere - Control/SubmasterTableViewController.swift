//
//  SubmasterTableViewController.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-11-27.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class SubmasterTableViewController: UITableViewController, UISplitViewControllerDelegate {
    private var collapseDetailViewController = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        splitViewController?.delegate = self
        
        if Data.submasters.count == 0 {
            let sub = Submaster(index: 1, name: "Sub 1")
            sub.values.append((1, 1.0))
            sub.values.append((40, 0.5))
            sub.values.append((95, 1.0))
            sub.values.append((96, 1.0))
            Data.submasters.append(sub)
        }
        
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.submasters.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SubmasterTableViewCell", forIndexPath: indexPath) as! SubmasterTableViewCell

        cell.setupForSubmaster(Data.submasters[indexPath.row])

        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            Data.submasters.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SubmasterShowDetail" {
            let detailNavView = segue.destinationViewController as! UINavigationController
            let submasterDetailViewController = detailNavView.viewControllers[0] as! SubmasterDetailViewController
            // Get the cell that generated this segue.
            if let selectedSubmasterCell = sender as? SubmasterTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedSubmasterCell)!    // Get path to the currently selected row
                let selectedSubmaster = Data.submasters[indexPath.row]   // Get the submaster that the currently selected row represents
                submasterDetailViewController.submaster = selectedSubmaster   // Set the selected submaster in the detail view controller
                submasterDetailViewController.parentCell = selectedSubmasterCell
            }
        } else if segue.identifier == "SubmasterAddItem" {
//            let detailNavView = segue.destinationViewController as! UINavigationController
//            let submasterDetailViewController = detailNavView.viewControllers[0] as! SubmasterEditViewController
//            submasterDetailViewController.source = self
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        collapseDetailViewController = false
    }
    
    
    // MARK: - UISplitViewControllerDelegate
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return collapseDetailViewController
    }
}
