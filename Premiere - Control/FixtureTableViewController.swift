//
//  FixtureTableViewController.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-11-27.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class FixtureTableViewController: UITableViewController, UISearchResultsUpdating, UISplitViewControllerDelegate {
    private var collapseDetailViewController = true
    
    var searchResultFixtures = [Fixture]()
    
    private var fixtureArray : [Fixture] {
        let searching = (self.searchController?.active ?? false)
        return (!searching) ? Data.fixtures.sort({$0.index < $1.index}) : searchResultFixtures.sort({$0.index < $1.index})
    }
    
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load any saved fixtures, otherwise load sample data.
        if let savedFixtures = Data.loadFixtures() where savedFixtures.count != 0 {
            Data.fixtures += savedFixtures
            print("Loaded \(Data.fixtures.count) fixture(s) from non-volatile storage")
        } else {
            loadSampleFixtures()
        }
        
        self.splitViewController?.delegate = self
        
        self.searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Search"
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        let path = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.selectRowAtIndexPath(path, animated: true, scrollPosition:.Top)
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            performSegueWithIdentifier("FixtureShowDetail", sender: self.tableView.cellForRowAtIndexPath(path))
        }
        
        self.clearsSelectionOnViewWillAppear = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView?.reloadData()
    }

    func loadSampleFixtures() {
        let fix = Fixture(name: "A Fixture", address: 1, index: 1)!
        
        let intensity = GenericProperty(index: 0, parent: fix, name: "Intensity", initialValue: PropertyType.Generic(0.0), depth: 8)
        let colour = ColourProperty(index: 0, parent: fix)
        let position = PositionProperty(index: 0, parent: fix)
        let scroller = ScrollerProperty(index: 0, parent: fix)
        
        fix.properties.append(intensity!)
        fix.properties.append(colour)
        fix.properties.append(position)
        fix.properties.append(scroller)
        
        Data.fixtures.append(fix)
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
        return self.fixtureArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FixtureTableViewCell", forIndexPath: indexPath) as! FixtureTableViewCell
        
        // Fetches the appropriate fixture for the data source layout.
        let fixture = self.fixtureArray[indexPath.row]
        cell.setup(fixture)
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let fixture = self.fixtureArray[indexPath.row]

            Data.fixtures.removeAtIndex(Data.fixtures.indexOf(fixture)!)
            if let index = self.searchResultFixtures.indexOf(fixture) {
                self.searchResultFixtures.removeAtIndex(index)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            Data.saveFixures()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
    
    // MARK: Search
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchResultFixtures.removeAll(keepCapacity: false)
        
        searchResultFixtures = Data.fixtures.filter({$0.name.lowercaseString.containsString(self.searchController?.searchBar.text?.lowercaseString ?? "")})
        
        self.tableView.reloadData()
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
                let selectedFixture = self.fixtureArray[indexPath.row]   // Get the fixture that the currently selected row represents
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
                if (sourceViewController.numFixtures == 1) {
                    Data.fixtures.append(fixture)    // Add new fixture to array
                
                    let row = Data.fixtures.indexOf(fixture) ?? Data.fixtures.count
                    let newIndexPath = NSIndexPath(forRow: row, inSection: 0)    // Get the path where the data should be added
                
                    tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic) // Add data to table view
                } else {
                    let rows = addMultipleCopiesOfFixture(fixture, numCopies: sourceViewController.numFixtures)
                    var indexPaths = [NSIndexPath]()
                    for i in rows {
                        indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
                    }
                    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                }
                Data.fixtures.sortInPlace({$0.index < $1.index})   // Sort the fixtures in ascending order by index
                tableView.reloadData()  // Notify the table view that the data has changed
                Data.saveFixures()
        } else if let sourceViewController = sender.sourceViewController as? FixtureDetailViewController, fixture = sourceViewController.fixture {
                // Edited Fixture
                print("Returned from fixture \(fixture.name)")
        }
    }
    
    enum FixtureCreationError: ErrorType {
        case InsufficiantAddressSpace (neededAddresses: Int)
    }
    
    private func addMultipleCopiesOfFixture (fixture: Fixture, numCopies: Int) -> [Int] {
        var rows = [Int]()
        for i in 1 ... numCopies {
            let fix = fixture.copyWithZone(nil) as! Fixture
            fix.name = fix.name + " " + String(i)
            fix.index = fixture.index + i - 1
            fix.address = fixture.address + ((i - 1) * fixture.addressLength)
            Data.fixtures.append(fix)
            
            rows.append(Data.fixtures.indexOf(fix) ?? Data.fixtures.count)
        }
        return rows
    }
    
    // MARK: - UISplitViewControllerDelegate
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return self.collapseDetailViewController
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.collapseDetailViewController = false
    }
}
