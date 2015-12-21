//
//  FixtureDetailViewController.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-07.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class FixtureDetailViewController: UITableViewController {
    var fixture: Fixture!
    var parentCell: FixtureTableViewCell!
    
    let backgroundColour = UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if fixture == nil {
            navigationItem.title = "No Fixture Selected"
            return
        }
        
        self.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        self.navigationItem.leftItemsSupplementBackButton = true
        
        self.tableView.allowsSelection = false
        
//        self.tableView.backgroundColor = backgroundColour
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        setupRows()
    }
    
    func setupRows () {
//        print("Setting up Rows: \(fixture.name)")
        self.navigationItem.title = self.fixture.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }

    // MARK: - Navigation
    
    @IBAction func unwindToFixtureDetail(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? FixtureEditViewController, fixture =
            sourceViewController.fixture {
                self.fixture = fixture
                setupRows()
                parentCell.setup(self.fixture)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailNavView = segue.destinationViewController as! UINavigationController
        let fixtureEditViewController = detailNavView.viewControllers[0] as! FixtureEditViewController
        
        fixtureEditViewController.fixture = fixture
        fixtureEditViewController.source = self
    }

}


class FixtureGenericCell: UITableViewCell {
    var parent: FixtureDetailViewController!
    var property: GenericProperty!
    
    func setupForPropriety(property: GenericProperty, parent:FixtureDetailViewController) {
        self.parent = parent
        self.property = property
        
    }
}
