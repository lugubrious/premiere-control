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
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60.0
        
        self.tableView.allowsSelection = false
        
        self.tableView.backgroundColor = backgroundColour
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.navigationItem.title = self.fixture.name
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
        switch section {
        case 0:
            return self.fixture?.properties.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            self.fixture.properties.sortInPlace({$0.sortOrder < $1.sortOrder})
            return createCellForProperty(self.fixture.properties[indexPath.row], path: indexPath) ?? tableView.dequeueReusableCellWithIdentifier("nonexistantCell", forIndexPath: indexPath)
        } else {
            return tableView.dequeueReusableCellWithIdentifier("nonexistantCell", forIndexPath: indexPath)
        }
    }
    
    func createCellForProperty(property: Property, path: NSIndexPath) -> UITableViewCell? {
        if let prop = property as? GenericProperty {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("FixtureGenericCell", forIndexPath: path) as! FixtureGenericCell
            cell.setupForPropriety(prop, parent: self)
            return cell
        } else if let prop = property as? ColourProperty {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("FixtureColourCell", forIndexPath: path) as! FixtureColourCell
            cell.setupForPropriety(prop, parent: self)
            return cell
        } else if let prop = property as? PositionProperty {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("FixturePositionCell", forIndexPath: path) as! FixturePositionCell
            cell.setupForPropriety(prop, parent: self)
            return cell
        } else if let prop = property as? ScrollerProperty {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("FixtureScrollerCell", forIndexPath: path) as! FixtureScrollerCell
            cell.setupForPropriety(prop, parent: self)
            return cell
        } else {
            return nil
        }
    }

    // MARK: - Navigation
    
    @IBAction func unwindToFixtureDetail(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? FixtureEditViewController, fixture =
            sourceViewController.fixture {
                self.fixture = fixture
                self.navigationItem.title = self.fixture.name
                self.tableView.reloadData()
                self.parentCell.setup(self.fixture)
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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var valueLabel: UILabel!
    
    var labelText: String {
        return (self.valueSlider.value != 1.0) ? String(format: "%.1f", arguments: [self.valueSlider.value * 100.0]) + "%" : "100%"
    }
    
    func setupForPropriety(property: GenericProperty, parent:FixtureDetailViewController) {
        self.parent = parent
        self.property = property
        
        self.nameLabel.text = self.property.name
        self.valueSlider.value = Float(self.property.unwrappedValue ?? 0)
        self.valueLabel.text = labelText
    }
    
    @IBAction func valueChanged(sender: UISlider, forEvent event: UIEvent) {
        self.property.value = PropertyType.Generic(Double(self.valueSlider.value))
        self.valueLabel.text = labelText
        self.parent.parentCell.setup(parent.fixture)
    }
}

class FixtureColourCell: UITableViewCell {
    var parent: FixtureDetailViewController!
    var property: ColourProperty!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var colourView: UIView!
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!
    
    func setupForPropriety(property: ColourProperty, parent:FixtureDetailViewController) {
        self.parent = parent
        self.property = property
        
        var colour = [CGFloat](count: 3, repeatedValue: CGFloat())
        self.property.unwrappedValue!.getRed(&colour[0], green: &colour[1], blue: &colour[2], alpha: nil);
        
        self.redSlider.value = Float(colour[0])
        self.redValueLabel.text = String(Int(Float(colour[0]) * 255.0))
        self.greenSlider.value = Float(colour[1])
        self.greenValueLabel.text = String(Int(Float(colour[1]) * 255.0))
        self.blueSlider.value = Float(colour[2])
        self.blueValueLabel.text = String(Int(Float(colour[2]) * 255.0))
        
        self.colourView.backgroundColor = self.property.unwrappedValue!
        self.colourView.layer.borderWidth = 1
        self.colourView.layer.borderColor = UIColor.blackColor().CGColor
        
        self.nameLabel.text = self.property.name
    }
    
    @IBAction func redChanged(sender: UISlider, forEvent event: UIEvent) {
        self.property.value = PropertyType.Colour(UIColor(red: CGFloat(self.redSlider.value), green: CGFloat(self.greenSlider.value), blue: CGFloat(self.blueSlider.value), alpha: 1.0))
        self.colourView.backgroundColor = self.property.unwrappedValue!
        self.redValueLabel.text = String(Int(Float(self.redSlider.value * 255.0)))
        self.parent.parentCell.setup(parent.fixture)
    }
    
    @IBAction func greenChanged(sender: UISlider, forEvent event: UIEvent) {
        self.property.value = PropertyType.Colour(UIColor(red: CGFloat(self.redSlider.value), green: CGFloat(self.greenSlider.value), blue: CGFloat(self.blueSlider.value), alpha: 1.0))
        self.colourView.backgroundColor = self.property.unwrappedValue!
        self.greenValueLabel.text = String(Int(Float(self.greenSlider.value * 255.0)))
        self.parent.parentCell.setup(parent.fixture)
    }
   
    @IBAction func blueChanged(sender: UISlider, forEvent event: UIEvent) {
        self.property.value = PropertyType.Colour(UIColor(red: CGFloat(self.redSlider.value), green: CGFloat(self.greenSlider.value), blue: CGFloat(self.blueSlider.value), alpha: 1.0))
        self.colourView.backgroundColor = self.property.unwrappedValue!
        self.blueValueLabel.text = String(Int(Float(self.blueSlider.value * 255.0)))
        self.parent.parentCell.setup(parent.fixture)
    }
}

class FixturePositionCell: UITableViewCell {
    var parent: FixtureDetailViewController!
    var property: PositionProperty!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func setupForPropriety(property: PositionProperty, parent:FixtureDetailViewController) {
        self.parent = parent
        self.property = property
        
        self.nameLabel.text = self.property.name
    }
}

class FixtureScrollerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    var parent: FixtureDetailViewController!
    var property: ScrollerProperty!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valuePicker: UIPickerView!
    
    var pickerData = [Int]()
    
    func setupForPropriety(property: ScrollerProperty, parent:FixtureDetailViewController) {
        self.parent = parent
        self.property = property
        
        self.nameLabel.text = self.property.name
        
        self.pickerData.removeAll()
        for i in 1 ... self.property.locations {
            self.pickerData.append(i)
        }
        
        self.valuePicker.dataSource = self
        self.valuePicker.delegate = self
        
        self.valuePicker.selectRow(self.property.unwrappedValue!, inComponent: 0, animated: false)
    }
    
    // MARK: Picker

    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return pickerData.count
        default:
            return 0
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(pickerData[row])
        default:
            return nil
        }
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.property.value = PropertyType.Scroller(row)
            self.parent.parentCell.setup(parent.fixture)
        }
    }
}