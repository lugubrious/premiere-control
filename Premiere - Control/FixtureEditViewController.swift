//
//  FixtureEditViewController.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-07.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class FixtureEditViewController: UITableViewController {
    var fixture:Fixture!
    var source: UIViewController!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let backgroundColour = UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.fixture == nil {
            self.fixture = Fixture(name: "New Fixture", address: 800, index: 0)
        }
        
        setNavigationTitle(fixture.name)
        
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60.0
        
        self.tableView.allowsSelection = false
        
        self.tableView.backgroundColor = backgroundColour
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func setNavigationTitle (name:String) {
        navigationItem.title = "Edit: \(name)"
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
        //return fixture.proprieties.count + 3
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditNameCell", forIndexPath: indexPath) as! FixtureEditNameCell
            cell.setupForFixture(self.fixture, parent: self)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditIndexCell", forIndexPath: indexPath) as! FixtureEditIndexCell
            cell.setupForFixture(self.fixture, parent: self)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditDimmerCell", forIndexPath: indexPath) as! FixtureEditDimmerCell
            cell.setupForFixture(self.fixture)
            return cell
        } else {
            let property = fixture.proprieties[indexPath.row - 3]
            let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditPropCell", forIndexPath: indexPath)
                
            return property.setUpTableCell(cell)
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
            for i in 0..<tableView.numberOfRowsInSection(0) {
                if let editor = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as? FixtureEditor {
                    editor.updateFixture(self.fixture) // Give each row an opertunity to save it's changes
                }
            }
        }
    }
}

protocol FixtureEditor {
    func updateFixture (fixture: Fixture)
}

class FixtureEditNameCell: UITableViewCell, UITextFieldDelegate, FixtureEditor {
    @IBOutlet weak var nameTextField: UITextField!
    
    var parent: FixtureEditViewController!
    func setupForFixture(fixture: Fixture, parent:FixtureEditViewController) {
        self.parent = parent
        nameTextField.delegate = self
        nameTextField.text = fixture.name
        
        nameTextField.layer.borderColor = UIColor.clearColor().CGColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.masksToBounds = true
    }
    
    // MARK: Text fied delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        parent.saveButton.enabled = false
        nameTextField.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    func checkValidEntry () {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        parent.saveButton.enabled = !text.isEmpty
        if (text.isEmpty) {
            nameTextField.layer.borderColor = UIColor.redColor().CGColor
        } else {
            parent.setNavigationTitle(text)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //Update value
        checkValidEntry()
    }
    
    func updateFixture (fixture: Fixture) {
        fixture.name = nameTextField.text!
    }
}

class FixtureEditIndexCell: UITableViewCell, UITextFieldDelegate, FixtureEditor {
    @IBOutlet weak var indexTextField: UITextField!
    
    var parent: FixtureEditViewController!
    
    func setupForFixture(fixture: Fixture, parent:FixtureEditViewController) {
        self.parent = parent
        indexTextField.text = String(fixture.index)
        indexTextField.delegate = self
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
            target: self, action: Selector("endEditing:"))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        indexTextField.inputAccessoryView = keyboardToolbar
        
        indexTextField.layer.borderColor = UIColor.clearColor().CGColor
        indexTextField.layer.borderWidth = 1
        indexTextField.layer.cornerRadius = 5
        indexTextField.layer.masksToBounds = true
    }
    
    // MARK: Text fied delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        parent.saveButton.enabled = false
        indexTextField.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    func checkValidEntry () {
        // Disable the Save button if the text field is empty.
        let index = Int(indexTextField.text ?? "")
        parent.saveButton.enabled = (index != nil)
        if (index == nil) {
            indexTextField.layer.borderColor = UIColor.redColor().CGColor
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //Update value
        checkValidEntry()
    }
    
    func updateFixture (fixture: Fixture) {
        fixture.index = Int(indexTextField.text!)!
    }
}

class FixtureEditDimmerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource, FixtureEditor {
    @IBOutlet weak var dimmerPicker: UIPickerView!
    
    var pickerData = [[Int](), [Int]()]
    var universe = 1, dimmer = 1
    
    func setupForFixture(fixture: Fixture) {
        let address = fixture.address
        universe = (address < 512) ? 1 : 2
        dimmer = (universe == 1) ? address : address - 512
        
        dimmerPicker.delegate = self
        dimmerPicker.dataSource = self

        pickerData[0] = [1,2]
        for i in 1...512 {
            pickerData[1] += [i]
        }
        
        dimmerPicker.selectRow(universe - 1, inComponent: 0, animated: false)
        dimmerPicker.selectRow(dimmer - 1, inComponent: 1, animated: false)
    }
    
    // MARK: Picker
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView === dimmerPicker {
            return pickerData.count
        } else {
            return 0
        }
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === dimmerPicker {
            return pickerData[component].count
        } else {
            return 0
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === dimmerPicker {
            return String(pickerData[component][row])
        } else {
            return nil
        }
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === dimmerPicker {
            if component == 0 {
                universe = pickerData[component][row]
            } else if component == 1 {
                dimmer = pickerData[component][row]
            }
        }
    }
    
    func updateFixture (fixture: Fixture) {
        fixture.address = (universe == 1) ? dimmer : dimmer + 512
    }
}
