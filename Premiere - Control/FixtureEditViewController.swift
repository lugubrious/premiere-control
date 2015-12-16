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
    var proprieties: [Propriety]!
    var source: UIViewController!
    
//    var numDeletedProprieties: Int?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let backgroundColour = UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fixture = self.fixture ?? Fixture(name: "New Fixture", address: 800, index: 0)
        self.proprieties = self.fixture.proprieties
        
        setNavigationTitle(self.fixture.name)
        
//        self.navigationController?.setToolbarHidden(false, animated: true)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60.0
        
        self.tableView.allowsSelection = false
        
        self.tableView.backgroundColor = backgroundColour
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
    }
    
    func setNavigationTitle (name:String) {
        navigationItem.title = "Edit: \(name)"
    }
    
    func updateSaveButton () {
        for i in 0..<tableView.numberOfSections {
            for j in 0..<tableView.numberOfRowsInSection(i) {
                if let editor = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: j, inSection: i)) as?   FixtureEditor {
                    if !editor.validData {
                        saveButton.enabled = false
                        return
                    }
                }
            }
        }
        saveButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return fixture.proprieties.count + 3
        switch section {
        case 0:
            return 3
        case 1:
            return self.proprieties.count// - (numDeletedProprieties ?? 0)
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "General"
        case 1:
            return "Proprieties"
        case 2:
            return " "
        default:
            return nil
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == 1 ? true: false
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
 //           numDeletedProprieties = (numDeletedProprieties ?? 0) + 1
            self.proprieties.sortInPlace({$0.index < $1.index})
            self.proprieties.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditNameCell", forIndexPath: indexPath) as! FixtureEditNameCell
                cell.setupForFixture(self.fixture, parent: self)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditIndexCell", forIndexPath: indexPath) as! FixtureEditIndexCell
                cell.setupForFixture(self.fixture, parent: self)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditDimmerCell", forIndexPath: indexPath) as! FixtureEditDimmerCell
                cell.setupForFixture(self.fixture)
                return cell
            default:
                print("Too many rows in section 0 of fixtureEditView for fixture \"\(fixture.name)\"")
                let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditNameCell", forIndexPath: indexPath) as! FixtureEditNameCell
                return cell
            }
        } else if indexPath.section == 1 {
            let propriety = self.proprieties.sort({$0.index < $1.index})[indexPath.row]
            switch propriety.value {
            case .Generic:
                let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditGenericCell", forIndexPath: indexPath) as! FixtureEditGenericCell
                cell.setupForPropriety(propriety as! GenericPropriety, parent: self)
                return cell
            case .Colour:
                let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditColourCell", forIndexPath: indexPath) as! FixtureEditColourCell
                cell.setupForPropriety(propriety as! ColourPropriety, parent: self)
                return cell
            case .Position:
                let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditPositionCell", forIndexPath: indexPath) as! FixtureEditPositionCell
                cell.setupForPropriety(propriety as! PositionPropriety, parent: self)
                return cell
            case .Scroller:
                let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditScrollerCell", forIndexPath: indexPath) as! FixtureEditScrollerCell
                cell.setupForPropriety(propriety as! ScrollerPropriety, parent: self)
                return cell
            }
        } else if  indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditAddCell", forIndexPath: indexPath) as! FixtureEditAddCell
            cell.setupForController(self)
            return cell
        } else {
            print("Too many sections in fixtureEditView for fixture \"\(fixture.name)\"")
            let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditNameCell", forIndexPath: indexPath) as! FixtureEditNameCell
            return cell
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
            self.fixture.proprieties.removeAll()
            for i in 0..<tableView.numberOfSections {
                for j in 0..<tableView.numberOfRowsInSection(i) {
                    if let editor = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: j, inSection: i)) as?   FixtureEditor {
                        editor.updateFixture(self.fixture) // Give each row an opertunity to save it's changes
                    }
                }
            }
        }
    }
}

protocol FixtureEditor {
    var validData: Bool! {get}
    func updateFixture (fixture: Fixture)
}

class FixtureEditNameCell: UITableViewCell, UITextFieldDelegate, FixtureEditor {
    @IBOutlet weak var nameTextField: UITextField!
    
    var validData: Bool!
    
    var parent: FixtureEditViewController!
    func setupForFixture(fixture: Fixture, parent:FixtureEditViewController) {
        self.parent = parent
        nameTextField.delegate = self
        nameTextField.text = fixture.name
        
        nameTextField.layer.borderColor = UIColor.clearColor().CGColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.masksToBounds = true
        checkValidEntry();
    }
    
    // MARK: Text fied delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        validData = false
        parent.saveButton.enabled = false
        nameTextField.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    func checkValidEntry () {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        validData = !text.isEmpty
        if (validData!) {
            parent.setNavigationTitle(text)
            parent.updateSaveButton()
        } else {
            nameTextField.layer.borderColor = UIColor.redColor().CGColor
            parent.saveButton.enabled = false
            
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
    
    var validData: Bool!
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
        
        checkValidEntry();
    }
    
    // MARK: Text fied delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        validData = false
        parent.saveButton.enabled = false
        indexTextField.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    func checkValidEntry () {
        // Disable the Save button if the text field is empty.
        let index = Int(indexTextField.text ?? "")
        validData = (index != nil)
        if (validData!) {
             parent.updateSaveButton()
        } else {
            indexTextField.layer.borderColor = UIColor.redColor().CGColor
            parent.saveButton.enabled = false
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
    
    var validData: Bool!
    var pickerData = [[Int](), [Int]()]
    var universe = 1, dimmer = 1
    
    func setupForFixture(fixture: Fixture) {
        let address = fixture.address
        universe = (address < 512) ? 1 : 2
        dimmer = (universe == 1) ? address : address - 512
        
        dimmerPicker.delegate = self
        dimmerPicker.dataSource = self
        
        validData = true

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

class FixtureEditAddCell: UITableViewCell {
    @IBOutlet weak var typeControl: UISegmentedControl!
    
    var parent: FixtureEditViewController!
    
    func setupForController(parent:FixtureEditViewController) {
        self.parent = parent
    }
    
    @IBAction func addPressed(sender: UIButton, forEvent event: UIEvent) {
        print("addPressed. Selected = \(typeControl.selectedSegmentIndex).")
        var prop: Propriety!
        switch typeControl.selectedSegmentIndex {
        case 0:
            prop = GenericPropriety(index: 5, parent: parent.fixture)
        case 1:
            prop = ColourPropriety(index: 0, parent: parent.fixture)
        case 2:
            prop = PositionPropriety(index: 0, parent: parent.fixture)
        case 3:
            prop = ScrollerPropriety(index: 0, parent: parent.fixture)
        default:
            return
        }
        
        parent.proprieties.append(prop)
        parent.proprieties.sortInPlace({$0.index < $1.index})
        let row = (getRow(propriety: prop) ?? 0)
        parent.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: 1)], withRowAnimation: .Automatic)
    }
    
    func getRow (propriety prop: Propriety) -> Int? {
        if let p = prop as? GenericPropriety {
            return parent.proprieties.indexOf({($0 as? GenericPropriety) === p})
        } else if let p = prop as? ColourPropriety {
            return parent.proprieties.indexOf({($0 as? ColourPropriety) === p})
        } else if let p = prop as? PositionPropriety {
            return parent.proprieties.indexOf({($0 as? PositionPropriety) === p})
        } else if let p = prop as? ScrollerPropriety {
            return parent.proprieties.indexOf({($0 as? ScrollerPropriety) === p})
        } else {
            return nil
        }
    }
}