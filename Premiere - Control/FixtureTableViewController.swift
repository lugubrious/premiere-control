//
//  FixtureTableViewController.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-11-27.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class FixtureTableViewController: UITableViewController, UISplitViewControllerDelegate {
    var fixtures = [Fixture]()
    
    private var collapseDetailViewController = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleFixtures()
        
        splitViewController?.delegate = self

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
/*    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
        let path = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.selectRowAtIndexPath(path, animated: true, scrollPosition:.Top)
    }*/
    
    func loadSampleFixtures() {
        let fix = Fixture(name: "A Fixture", address: 1, index: 1)!
        
        let intensity = GenericPropriety(index: 0, parent: fix, name: "Intensity", initialValue: ProprietyType.Generic(0.0), depth: 8)
        let colour = ColourPropriety(index: 0, parent: fix)
        let position = PositionPropriety(index: 0, parent: fix)
        let scroller = ScrollerPropriety(index: 0, parent: fix)
        
        fix.proprieties.append(intensity!)
        fix.proprieties.append(colour)
        fix.proprieties.append(position)
        fix.proprieties.append(scroller)
        
        fixtures.append(fix)
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
        return fixtures.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "FixtureTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FixtureTableViewCell
        
        // Fetches the appropriate fixture for the data source layout.
        let fixture = fixtures[indexPath.row]
        cell.setup(fixture)
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            fixtures.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FixtureShowDetail" {
            let detailNavView = segue.destinationViewController as! UINavigationController
            let fixtureDetailViewController = detailNavView.viewControllers[0] as! FixtureDetailViewController
            // Get the cell that generated this segue.
            if let selectedFixtureCell = sender as? FixtureTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedFixtureCell)!    // Get path to the currently selecter row
                let selectedFixture = fixtures[indexPath.row]   // Get the fixture that the currently selected row represents
                fixtureDetailViewController.fixture = selectedFixture   // Set the selected fixture in the detail view controller
                fixtureDetailViewController.parentCell = selectedFixtureCell
            }
        } else if segue.identifier == "FixtureAddItem" {
            let detailNavView = segue.destinationViewController as! UINavigationController
            let fixtureDetailViewController = detailNavView.viewControllers[0] as! FixtureEditViewController
            fixtureDetailViewController.source = self
        }

    }
    
    @IBAction func unwindToFixtureList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? FixtureEditViewController, fixture =
            sourceViewController.fixture {
                // Add an new fixture
                let newIndexPath = NSIndexPath(forRow: fixtures.count, inSection: 0)    // Get the path where the data should be added
                fixtures.append(fixture)    // Add new fixture to array
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom) // Add data to tabel view
                fixtures.sortInPlace({$0.index < $1.index})   // Sort the fixtures in ascending order by index
                tableView.reloadData()  // Notify the table view that the data has chagned
        } else if let sourceViewController = sender.sourceViewController as? FixtureDetailViewController, fixture = sourceViewController.fixture {
                // Edited Fixture
                print("Returned from fixture \(fixture.name)")
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
