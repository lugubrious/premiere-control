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
    
    var isNewFixture = false
    var numFixtures = 1
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let backgroundColour = UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isNewFixture = self.fixture == nil

        self.fixture = self.fixture ?? Fixture(name: "New Fixture", address: 1, index: 0)
        
        self.properties = self.fixture.properties.map({$0.copyWithZone(nil) as! Property})
        self.name = self.fixture.name
        self.index = self.fixture.index
        self.address = self.fixture.address
        
        setNavigationTitle(self.fixture.name)
        
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
        if self.fixture.name.isEmpty || self.fixture.index < 0 {
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
            return self.isNewFixture ? 2 : 1
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
            switch indexPath.row {
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("FixtureAddMultipleCell", forIndexPath: indexPath) as! FixtureAddMultipleCell
                cell.setupForController(self)
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("FixtureEditAddCell", forIndexPath: indexPath) as! FixtureEditAddCell
                cell.setupForController(self)
                return cell
            }
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
            // Returning from adding new fixture
            let freeAddresses = Data.getUnusedAddresses()
            let numAddresses = Fixture.addressLengthForProperties(self.properties) * self.numFixtures
            
            if freeAddresses.count < numAddresses || !isAddressBlockFreeStartingAt(self.address, addresses: numAddresses, avaliable: freeAddresses){
                // There is not enough space, panic
                createAlertWithTitle("Insufficient Addresses", error: "There where not enough free addresses to create all of the fixtures");
            } else {
                self.performSegueWithIdentifier("unwindToFixtureList", sender: self)
            }
        } else if source is FixtureDetailViewController {
            // Returning from edit
            self.performSegueWithIdentifier("unwindToFixtureDetail", sender: self)
        }
    }
    
    private func createAlertWithTitle (title: String, error: String) {
        let alertController = UIAlertController(title: title, message: error, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: {(_) in })
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: {})
    }
    
    func isAddressBlockFreeStartingAt (start: Int, addresses: Int, avaliable: [Int]) -> Bool {
        if addresses == 0 {
            return true
        }
        var requiredAddresses = [Int]()
        requiredAddresses += (start ... (addresses + start - 1))
        for i in requiredAddresses {
            if !avaliable.contains(i) {
                return false
            }
        }
        return true
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
        self.universe = (self.parent.address < 512) ? 1 : 2
        self.dimmer = (self.universe == 1) ? self.parent.address : self.parent.address - 512
        
        self.dimmerPicker.delegate = self
        self.dimmerPicker.dataSource = self

        var avaliableAddresses = Data.getUnusedAddresses()
        let addressLength = Fixture.addressLengthForProperties(self.parent.properties)
        if (!(parent.isNewFixture || (addressLength == 0))) {
            avaliableAddresses += (self.parent.address ... (self.parent.address - 1 + addressLength))
        }
        
        for i in avaliableAddresses {
            let uni = (i <= 512) ? 1 : 2
            let dim = (uni == 1) ? i : i - 512
            self.pickerData[uni - 1].append(dim)
        }
        
        self.pickerData[0].sortInPlace({$0 < $1})
        self.pickerData[1].sortInPlace({$0 < $1})
        
        self.dimmerPicker.selectRow(self.universe - 1, inComponent: 0, animated: false)
        let row = self.parent.isNewFixture ? 0 : self.pickerData[universe - 1].indexOf(self.dimmer)!
        self.dimmerPicker.selectRow(row, inComponent: 1, animated: false)
        
        if self.parent.isNewFixture {
            self.universe = 1
            self.dimmer = pickerData[universe - 1][row]
            self.parent.address = (universe == 1) ? dimmer : dimmer + 512
        }
    }
    
    // MARK: Picker
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView === dimmerPicker {
            return 2
        } else {
            return 0
        }
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === dimmerPicker {
            switch component {
            case 0:
                return 2
            case 1:
                return pickerData[dimmerPicker.selectedRowInComponent(0)].count
            default:
                return 0
            }
        } else {
            return 0
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === dimmerPicker {
            switch component {
            case 0:
                return String(row + 1)
            case 1:
                return String(pickerData[universe - 1][row])
            default:
                return nil
            }
        } else {
            return nil
        }
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === dimmerPicker {
            if component == 0 {
                self.universe = row + 1
                pickerView.reloadComponent(1)
            } else if component == 1 {
                self.dimmer = pickerData[universe - 1][row]
            }
            self.parent.address = (universe == 1) ? dimmer : dimmer + 512
        }
    }
}

class FixtureEditAddCell: UITableViewCell {
    var parent: FixtureEditViewController!
    
    func setupForController(parent:FixtureEditViewController) {
        self.parent = parent
    }
    
    @IBAction func addPressed(sender: UIButton, forEvent event: UIEvent) {
        var data = [(name: String, secondary: String?)]()
        data.append((name: "Generic", nil))
        data.append((name: "Colour", nil))
        data.append((name: "Position", nil))
        data.append((name: "Scroller", nil))
        let popover = PopoverPicker(data: data, width: 200, height: nil, completion: addPopoverReturned)
        
        let location = event.allTouches()?.first?.locationInView(sender)
        let x = location?.x ?? 0, y = location?.y ?? 0
        
        popover.showViewFromController(self.parent, sender: sender, sourceRect: CGRect(x: x, y: y, width: 1, height: 1))
    }
    
    func addPopoverReturned (selectedRow: Int) {
        var prop: Property!
        switch selectedRow {
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

class FixtureAddMultipleCell: UITableViewCell {
    var parent: FixtureEditViewController!
    
    @IBOutlet weak var numFixtureStepper: UIStepper!
    @IBOutlet weak var numFixturesLabel: UILabel!
    
    
    func setupForController(parent:FixtureEditViewController) {
        self.parent = parent
        self.numFixtureStepper.value = Double(self.parent.numFixtures)
        self.numFixturesLabel.text = String(self.parent.numFixtures)
    }
    
    @IBAction func numFixturesChanged(sender: UIStepper, forEvent event: UIEvent) {
        self.parent.numFixtures = Int(self.numFixtureStepper.value)
        self.numFixturesLabel.text = String(self.parent.numFixtures)
    }
}