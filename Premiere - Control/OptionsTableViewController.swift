//
//  OptionsTableViewController.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-11-29.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class OptionsTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var dimmerPicker: UIPickerView!
    @IBOutlet weak var dimmerLabel: UILabel!
    
    @IBOutlet weak var aSlider: UISlider!
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var aProgressView: UIProgressView!
    @IBOutlet weak var anotherLabel: UILabel!
    @IBOutlet weak var aButton: UIButton!
    
    @IBOutlet weak var infoSectionHeaderCell: UITableViewCell!
    @IBOutlet weak var settingsSectionHeaderCell: UITableViewCell!
    @IBOutlet weak var testsSectionHeaderCell: UITableViewCell!
    
    let tableRows = [4, 2, 5]
    let backgroundColour = UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1)

    var pickerData = [[Int](), [Int]()]
    var universe = 1, dimmer = 1
    var numSliderUpdates = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false
        
        dimmerPicker.dataSource = self
        dimmerPicker.delegate = self
        
        pickerData[0] = [1,2]
        for i in 1...512 {
            pickerData[1] += [i]
        }
        
        aLabel.text = String(Int(aSlider.value))
        dimmerLabel.text = "\(universe)•\(dimmer)"
        
        self.tableView.backgroundColor = backgroundColour
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // For each of the title cells, make the cell transparent and move the cells separator line off of the screen
        // TODO: Find a less sketchy way of getting rid of the seperator (current way may cause problems on iPad Pro or other large devices)
        infoSectionHeaderCell!.contentView.backgroundColor = backgroundColour
        infoSectionHeaderCell!.separatorInset.left=5000;
        settingsSectionHeaderCell!.contentView.backgroundColor = backgroundColour
        settingsSectionHeaderCell!.separatorInset.left=5000;
        testsSectionHeaderCell!.contentView.backgroundColor = backgroundColour
        testsSectionHeaderCell!.separatorInset.left=5000;
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView === self.tableView {
            return tableRows.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.tableView {
            return tableRows[section]
        } else {
            return 0
        }
    }
    
    // Comandeer the displaying of header/footer views in order to make them clear
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.backgroundView?.backgroundColor = UIColor.clearColor()
        header.contentView.backgroundColor = UIColor.clearColor()
        
//        header.textLabel?.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
//        header.textLabel?.frame = header.frame
//        header.textLabel?.textAlignment = NSTextAlignment.Left
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
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
            dimmerLabel.text = "\(universe)•\(dimmer)"
        }
    }
    
    // MARK: slider/stepper

    @IBAction func sliderChanged(sender: UISlider, forEvent event: UIEvent) {
        if Float(aLabel.text!) != sender.value {
            aLabel.text = String(Int(sender.value))
            aProgressView.progress = (sender.value / Float(255))
            
            numSliderUpdates++
            anotherLabel.text = String(numSliderUpdates)
        }
    }
    
    // MARK: Buttons
    
    @IBAction func resetPressed(sender: AnyObject, forEvent event: UIEvent) {
        numSliderUpdates = 0
        anotherLabel.text = String(numSliderUpdates)
    }
    
}
