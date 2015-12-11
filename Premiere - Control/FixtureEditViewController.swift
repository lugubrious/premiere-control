//
//  FixtureEditViewController.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-07.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class FixtureEditViewController: UITableViewController {
    var fixture:Fixture?
    var source: UIViewController!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let backgroundColour = UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let fixture = self.fixture {
            navigationItem.title = "Edit: \(fixture.name)"
        } else {
            navigationItem.title = "New Fixture"
        }
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60.0
        
        self.tableView.allowsSelection = false
        
        self.tableView.backgroundColor = backgroundColour
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
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
        if let numProps = fixture?.proprieties.count {
            //return numProps
            return 3
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditNameCell", forIndexPath: indexPath) as! FixtureEditNameCell
            cell.setup()
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditIndexCell", forIndexPath: indexPath) as! FixtureEditIndexCell
            cell.setup()
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditDimmerCell", forIndexPath: indexPath) as! FixtureEditDimmerCell
            cell.setup()
            return cell
        } else {
            if let property = fixture?.proprieties[indexPath.row - 3] {
                let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditPropCell", forIndexPath: indexPath)
                
                return property.setUpTableCell(cell)
            } else {
                return tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath)
            }
        }
    }

    
    // MARK: - Navigation

    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        if source is FixtureTableViewController {
            self.performSegueWithIdentifier("unwindToFixtureList", sender: self)
        } else if source is FixtureDetailViewController {
            self.performSegueWithIdentifier("unwindToFixtureDetail", sender: self)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if self === sender {
            // Save proprieties and set fixture
            fixture = Fixture(name: "New Fixture", address: 8, index: 90)
        }
    }
}

class FixtureEditNameCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    
    func setup() {
        nameTextField.delegate = self
    }
    
    // MARK: Text fied delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //Update value
    }
}

class FixtureEditIndexCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var indexTextField: UITextField!
    
    func setup() {
        indexTextField.delegate = self
    }
    
    // MARK: Text fied delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //Update value
    }
}

class FixtureEditDimmerCell: UITableViewCell {
    @IBOutlet weak var dimmerPicker: UIPickerView!
    
    func setup() {
        
    }
}
