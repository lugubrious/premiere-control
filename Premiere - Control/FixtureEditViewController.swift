//
//  FixtureEditViewController.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-07.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class FixtureEditViewController: UITableViewController {
    var fixture:Fixture!    // The fixture which this view controller is editing
    var source: UIViewController!   // The view controller that needs to be unwound to
    
    var properties: [Property]!
    var name: String!, index: Int!, address: Int!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let backgroundColour = UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fixture = self.fixture ?? Fixture(name: "New Fixture", address: 0, index: 0)
        
        self.properties = self.fixture.properties.map({$0.copyWithZone(nil) as! Property})
        self.name = self.fixture.name
        self.index = self.fixture.index
        self.address = self.fixture.address
        
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
/*        for i in 0..<self.tableView.numberOfSections {
            for j in 0..<self.tableView.numberOfRowsInSection(i) {
                if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: j, inSection: i)) as? FixtureEditor {
                    if !cell.validData {
                        saveButton.enabled = false
                        return
                    }
                }
            }
        }*/
        if self.fixture.name.isEmpty || self.fixture.index <= 0 {
            saveButton.enabled = false
            return
        }
        for i in fixture.properties {
            if i.name.isEmpty {
                saveButton.enabled = false
                return
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
            return self.properties.count
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
            return "Properties"
        case 2:
            return nil
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
            self.properties.sortInPlace({$0.index < $1.index})
            self.properties.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let name = tableView.dequeueReusableCellWithIdentifier("FixtureEditNameCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! FixtureEditNameCell
                name.setupForParent(self)
                return name
            case 1:
                let index = tableView.dequeueReusableCellWithIdentifier("FixtureEditIndexCell", forIndexPath: NSIndexPath(forRow: 1, inSection: 0)) as! FixtureEditIndexCell
                index.setupForParent(self)
                return index
            case 2:
                let dimmer = tableView.dequeueReusableCellWithIdentifier("FixtureEditDimmerCell", forIndexPath: NSIndexPath(forRow: 2, inSection: 0)) as! FixtureEditDimmerCell
                dimmer.setupForParent(self)
                return dimmer
            default:
                print("Too many rows in section 0 of fixtureEditView (row \(indexPath.row))")
                let name = tableView.dequeueReusableCellWithIdentifier("FixtureEditNameCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! FixtureEditNameCell
                name.setupForParent(self)
                return name
            }
        } else if indexPath.section == 1 {
            self.properties.sortInPlace({$0.index < $1.index})
            return createPropCell(propriety: self.properties[indexPath.row], path: indexPath)
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

    func createPropCell (propriety prop: Property, path: NSIndexPath) -> UITableViewCell {
        switch prop.value {
        case .Generic:
            let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditGenericCell", forIndexPath: path) as! FixtureEditGenericCell
            cell.setupForProperty(prop as! GenericProperty, parent: self)
            return cell
        case .Colour:
            let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditColourCell", forIndexPath: path) as! FixtureEditColourCell
            cell.setupForProperty(prop as! ColourProperty, parent: self)
            return cell
        case .Position:
            let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditPositionCell", forIndexPath: path) as! FixtureEditPositionCell
            cell.setupForProperty(prop as! PositionProperty, parent: self)
            return cell
        case .Scroller:
            let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditScrollerCell", forIndexPath: path) as! FixtureEditScrollerCell
            cell.setupForProperty(prop as! ScrollerProperty, parent: self)
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
            self.fixture.name = self.name
            self.fixture.index = self.index
            self.fixture.address = self.address
            self.fixture.properties = self.properties
        }
    }
}

class FixtureEditNameCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    
    var parent: FixtureEditViewController!
    func setupForParent(parent: FixtureEditViewController) {
        self.parent = parent
        nameTextField.delegate = self
        nameTextField.text = self.parent.name
        
        nameTextField.layer.borderColor = UIColor.clearColor().CGColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.masksToBounds = true
        checkValidEntry();
    }
    
    // MARK: Text fied delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        parent.saveButton.enabled = false
        parent.name = ""
        nameTextField.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    func checkValidEntry () {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        parent.name = text
        if (!parent.name.isEmpty) {
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
}

class FixtureEditIndexCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var indexTextField: UITextField!
    
    var parent: FixtureEditViewController!
    
    func setupForParent(parent:FixtureEditViewController) {
        self.parent = parent
        indexTextField.text = String(self.parent.index)
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
        parent.index = -1
        parent.saveButton.enabled = false
        indexTextField.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    func checkValidEntry () {
        // Disable the Save button if the text field is empty.
        if let index = Int(indexTextField.text ?? "") {
            parent.updateSaveButton()
            parent.index = index
        } else {
            parent.index = -1
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
}

class FixtureEditDimmerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var dimmerPicker: UIPickerView!
    
    var pickerData = [[Int](), [Int]()]
    var universe = 1, dimmer = 1
    
    var parent: FixtureEditViewController!
    
    func setupForParent(parent: FixtureEditViewController) {
        self.parent = parent
        let address = parent.address
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
            parent.address = (universe == 1) ? dimmer : dimmer + 512
        }
    }
}

class FixtureEditAddCell: UITableViewCell {
    @IBOutlet weak var typeControl: UISegmentedControl!
    
    var parent: FixtureEditViewController!
    
    func setupForController(parent:FixtureEditViewController) {
        self.parent = parent
    }
    
    @IBAction func addPressed(sender: UIButton, forEvent event: UIEvent) {
//        print("addPressed. Selected = \(typeControl.selectedSegmentIndex).")
        var prop: Property!
        switch typeControl.selectedSegmentIndex {
        case 0:
            prop = GenericProperty(index: getLowestUnusedIndex(), parent: parent.fixture)
        case 1:
            prop = ColourProperty(index: getLowestUnusedIndex(), parent: parent.fixture)
        case 2:
            prop = PositionProperty(index: getLowestUnusedIndex(), parent: parent.fixture)
        case 3:
            prop = ScrollerProperty(index: getLowestUnusedIndex(), parent: parent.fixture)
        default:
            return
        }
        parent.properties.append(prop)
        parent.properties.sortInPlace({$0.index < $1.index})
        let row = (getRow(propriety: prop) ?? 0)
        parent.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: 1)], withRowAnimation: .Automatic)
    }
    
    func getLowestUnusedIndex() -> Int {
        var index = 0
        for i in parent.properties {
            if (i.index <= index) {
                index = i.index + 1
            }
        }
        return index
    }
    
    func getRow (propriety prop: Property) -> Int? {
        if let p = prop as? GenericProperty {
            return parent.properties.indexOf({($0 as? GenericProperty) === p})
        } else if let p = prop as? ColourProperty {
            return parent.properties.indexOf({($0 as? ColourProperty) === p})
        } else if let p = prop as? PositionProperty {
            return parent.properties.indexOf({($0 as? PositionProperty) === p})
        } else if let p = prop as? ScrollerProperty {
            return parent.properties.indexOf({($0 as? ScrollerProperty) === p})
        } else {
            return nil
        }
    }
}