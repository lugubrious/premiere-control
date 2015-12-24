//
//  FixtureEditDynamicCells.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-13.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class FixtureEditGenericCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var depthSwitch: UISwitch!
    @IBOutlet weak var offsetLabel: UILabel!
    @IBOutlet weak var offsetStepper: UIStepper!
    
    var property:Property!
    var parent: FixtureEditViewController!
    
    func setupForProperty(propriety: GenericProperty, parent:FixtureEditViewController) {
        self.parent = parent
        self.property = propriety
        self.nameTextField.text = String(self.property.name)
        self.nameTextField.delegate = self
        
        self.offsetStepper.value = Double(self.property.index)
        self.offsetStepper.wraps = true
        self.offsetLabel.text = String(Int(offsetStepper.value))
        
        self.depthSwitch.setOn(self.property.depth == 16, animated: false)
        
        self.nameTextField.layer.borderColor = UIColor.clearColor().CGColor
        self.nameTextField.layer.borderWidth = 1
        self.nameTextField.layer.cornerRadius = 5
        self.nameTextField.layer.masksToBounds = true
        
        self.checkValidEntry()
    }
    
    // MARK: Text fied delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        self.property.name = ""
        self.parent.saveButton.enabled = false
        self.nameTextField.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    func checkValidEntry () {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        if (!text.isEmpty) {
            self.parent.updateSaveButton()
            self.property.name = self.nameTextField.text!
        } else {
            self.nameTextField.layer.borderColor = UIColor.redColor().CGColor
            self.parent.saveButton.enabled = false
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
    
    
    // MARK: Actions
    @IBAction func offsetStepperChanged(sender: UIStepper, forEvent event: UIEvent) {
        self.offsetLabel.text = String(Int(sender.value))
        self.property.index = Int(self.offsetLabel.text!)!
    }
    
    @IBAction func depthSwitched(sender: UISwitch, forEvent event: UIEvent) {
        self.property.depth = self.depthSwitch.on ? 16 : 8
    }
}

class FixtureEditColourCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var depthSwitch: UISwitch!
    @IBOutlet weak var offsetStepper: UIStepper!
    @IBOutlet weak var offsetLabel: UILabel!
    @IBOutlet weak var colourSpaceControl: UISegmentedControl!
    
    var property: ColourProperty!
    var parent: FixtureEditViewController!
    
    func setupForProperty(property: ColourProperty, parent:FixtureEditViewController) {
        self.parent = parent
        self.property = property
        self.nameTextField.text = String(self.property.name)
        self.nameTextField.delegate = self
        
        self.offsetStepper.value = Double(self.property.index)
        self.offsetStepper.wraps = true
        self.offsetLabel.text = String(Int(offsetStepper.value))
        
        self.depthSwitch.setOn(self.property.depth == 16, animated: false)
        
        switch self.property.outputMode {
        case .RGB :
            self.colourSpaceControl.selectedSegmentIndex = 0
        case .CMY:
            self.colourSpaceControl.selectedSegmentIndex = 1
        case .HSI:
            self.colourSpaceControl.selectedSegmentIndex = 2
        }
        
        self.nameTextField.layer.borderColor = UIColor.clearColor().CGColor
        self.nameTextField.layer.borderWidth = 1
        self.nameTextField.layer.cornerRadius = 5
        self.nameTextField.layer.masksToBounds = true
        
        self.checkValidEntry()
    }
    
    // MARK: Text fied delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        self.property.name = ""
        self.parent.saveButton.enabled = false
        self.nameTextField.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    func checkValidEntry () {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        if (!text.isEmpty) {
            self.parent.updateSaveButton()
            self.property.name = self.nameTextField.text!
        } else {
            self.nameTextField.layer.borderColor = UIColor.redColor().CGColor
            self.parent.saveButton.enabled = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //Update value
        self.checkValidEntry()
    }
    
    // MARK: Actions
    @IBAction func offsetStepperChanged(sender: UIStepper, forEvent event: UIEvent) {
        self.offsetLabel.text = String(Int(sender.value))
        self.property.index = Int(self.offsetLabel.text!)!
    }
    
    @IBAction func colourSpaceChanged(sender: UISegmentedControl, forEvent event: UIEvent) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.property.outputMode = .RGB
        case 1:
            self.property.outputMode = .CMY
        case 2:
            self.property.outputMode = .HSI
        default:
            break
        }
    }
    
    @IBAction func depthSwitched(sender: UISwitch, forEvent event: UIEvent) {
        self.property.depth = self.depthSwitch.on ? 16 : 8
    }
}

class FixtureEditPositionCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var depthSwitch: UISwitch!
    @IBOutlet weak var offsetStepper: UIStepper!
    @IBOutlet weak var offsetLabel: UILabel!
    
    var property: Property!
    var parent: FixtureEditViewController!
    
    func setupForProperty(property: PositionProperty, parent:FixtureEditViewController) {
        self.parent = parent
        self.property = property
        self.nameTextField.text = String(self.property.name)
        self.nameTextField.delegate = self
        
        self.offsetStepper.value = Double(self.property.index)
        self.offsetStepper.wraps = true
        self.offsetLabel.text = String(Int(offsetStepper.value))
        
        self.depthSwitch.setOn(self.property.depth == 16, animated: false)
        
        self.nameTextField.layer.borderColor = UIColor.clearColor().CGColor
        self.nameTextField.layer.borderWidth = 1
        self.nameTextField.layer.cornerRadius = 5
        self.nameTextField.layer.masksToBounds = true
        
        self.checkValidEntry()
    }
    
    // MARK: Text fied delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        self.property.name = ""
        self.parent.saveButton.enabled = false
        self.nameTextField.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    func checkValidEntry () {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        if (!text.isEmpty) {
            self.parent.updateSaveButton()
            self.property.name = self.nameTextField.text!
        } else {
            self.nameTextField.layer.borderColor = UIColor.redColor().CGColor
            self.parent.saveButton.enabled = false
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
    
    // MARK: Actions
    @IBAction func offsetStepperChanged(sender: UIStepper, forEvent event: UIEvent) {
        offsetLabel.text = String(Int(sender.value))
        self.property.index = Int(self.offsetLabel.text!)!
    }
    
    @IBAction func depthSwitched(sender: UISwitch, forEvent event: UIEvent) {
        self.property.depth = self.depthSwitch.on ? 16 : 8
    }
}

class FixtureEditScrollerCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var depthSwitch: UISwitch!
    @IBOutlet weak var offsetStepper: UIStepper!
    @IBOutlet weak var offsetLabel: UILabel!
    @IBOutlet weak var numStepsStepper: UIStepper!
    @IBOutlet weak var numStepsLabel: UILabel!

    var property: Property!
    var parent: FixtureEditViewController!
    
    func setupForProperty(property: ScrollerProperty, parent:FixtureEditViewController) {
        self.parent = parent
        self.property = property
        nameTextField.text = String(self.property.name)
        nameTextField.delegate = self
        
        self.offsetStepper.value = Double(self.property.index)
        self.offsetStepper.wraps = true
        offsetLabel.text = String(Int(offsetStepper.value))
        
        self.numStepsStepper.value = Double((self.property as! ScrollerProperty).locations)
        self.numStepsStepper.wraps = true
        numStepsLabel.text = String(Int(numStepsStepper.value))
        
        depthSwitch.setOn(self.property.depth == 16, animated: false)
        
        nameTextField.layer.borderColor = UIColor.clearColor().CGColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.masksToBounds = true
        
        checkValidEntry()
    }
    
    // MARK: Text fied delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        self.property.name = ""
        parent.saveButton.enabled = false
        nameTextField.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    func checkValidEntry () {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        if (!text.isEmpty) {
            parent.updateSaveButton()
            self.property.name = self.nameTextField.text!
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
    
    // MARK: Actions
    @IBAction func offsetStepperChanged(sender: UIStepper, forEvent event: UIEvent) {
        offsetLabel.text = String(Int(sender.value))
        self.property.index = Int(self.offsetLabel.text!)!
    }
   
    @IBAction func numStepsStepperChanged(sender: UIStepper, forEvent event: UIEvent) {
        numStepsLabel.text = String(Int(sender.value))
        (self.property as! ScrollerProperty).locations = Int(self.numStepsLabel.text!)!
    }
    
    @IBAction func depthSwitched(sender: UISwitch, forEvent event: UIEvent) {
        self.property.depth = self.depthSwitch.on ? 16 : 8
    }
}