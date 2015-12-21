//
//  FixtureEditDynamicCells.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-13.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class FixtureEditGenericCell: UITableViewCell, UITextFieldDelegate, FixtureEditor {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var depthSwitch: UISwitch!
    @IBOutlet weak var offsetLabel: UILabel!
    @IBOutlet weak var offsetStepper: UIStepper!
    
    var validData: Bool!
    
    var propriety:Propriety!
    var parent: FixtureEditViewController!
    
    func setupForPropriety(propriety: GenericPropriety, parent:FixtureEditViewController) {
        self.parent = parent
        self.propriety = propriety
        nameTextField.text = String(self.propriety.name)
        nameTextField.delegate = self
        
        self.offsetStepper.value = Double(self.propriety.index)
        self.offsetStepper.wraps = true
        offsetLabel.text = String(Int(offsetStepper.value))
        
        depthSwitch.setOn(self.propriety.depth == 16, animated: false)
        
        nameTextField.layer.borderColor = UIColor.clearColor().CGColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.masksToBounds = true
        
        checkValidEntry()
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
            parent.updateSaveButton()
            self.propriety.name = self.nameTextField.text!
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
        self.propriety.index = Int(self.offsetLabel.text!)!
    }
    
    @IBAction func depthSwitched(sender: UISwitch, forEvent event: UIEvent) {
        self.propriety.depth = self.depthSwitch.on ? 16 : 8
    }
}

class FixtureEditColourCell: UITableViewCell, UITextFieldDelegate, FixtureEditor {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var depthSwitch: UISwitch!
    @IBOutlet weak var offsetStepper: UIStepper!
    @IBOutlet weak var offsetLabel: UILabel!
    @IBOutlet weak var colourSpaceControl: UISegmentedControl!
    
    
    
    var validData: Bool!
    
    var propriety: Propriety!
    var parent: FixtureEditViewController!
    
    func setupForPropriety(propriety: ColourPropriety, parent:FixtureEditViewController) {
        self.parent = parent
        self.propriety = propriety
        nameTextField.text = String(self.propriety.name)
        nameTextField.delegate = self
        
        self.offsetStepper.value = Double(self.propriety.index)
        self.offsetStepper.wraps = true
        offsetLabel.text = String(Int(offsetStepper.value))
        
        depthSwitch.setOn(self.propriety.depth == 16, animated: false)
        
        nameTextField.layer.borderColor = UIColor.clearColor().CGColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.masksToBounds = true
        
        checkValidEntry()
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
            parent.updateSaveButton()
            self.propriety.name = self.nameTextField.text!
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
        self.propriety.index = Int(self.offsetLabel.text!)!
    }
    
    @IBAction func colourSpaceChanged(sender: UISegmentedControl, forEvent event: UIEvent) {
        let prop = self.propriety as! ColourPropriety
        switch sender.selectedSegmentIndex {
        case 0:
            prop.outputMode = .RGB
        case 1:
            prop.outputMode = .CMY
        case 2:
            prop.outputMode = .HSI
        default:
            break
        }
    }
    
    @IBAction func depthSwitched(sender: UISwitch, forEvent event: UIEvent) {
        self.propriety.depth = self.depthSwitch.on ? 16 : 8
    }
}

class FixtureEditPositionCell: UITableViewCell, UITextFieldDelegate, FixtureEditor {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var depthSwitch: UISwitch!
    @IBOutlet weak var offsetStepper: UIStepper!
    @IBOutlet weak var offsetLabel: UILabel!
    
    var validData: Bool!
    
    var propriety: Propriety!
    var parent: FixtureEditViewController!
    
    func setupForPropriety(propriety: PositionPropriety, parent:FixtureEditViewController) {
        self.parent = parent
        self.propriety = propriety
        nameTextField.text = String(self.propriety.name)
        nameTextField.delegate = self
        
        self.offsetStepper.value = Double(self.propriety.index)
        self.offsetStepper.wraps = true
        offsetLabel.text = String(Int(offsetStepper.value))
        
        depthSwitch.setOn(self.propriety.depth == 16, animated: false)
        
        nameTextField.layer.borderColor = UIColor.clearColor().CGColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.masksToBounds = true
        
        checkValidEntry()
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
            parent.updateSaveButton()
            self.propriety.name = self.nameTextField.text!
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
        self.propriety.index = Int(self.offsetLabel.text!)!
    }
    
    @IBAction func depthSwitched(sender: UISwitch, forEvent event: UIEvent) {
        self.propriety.depth = self.depthSwitch.on ? 16 : 8
    }
}

class FixtureEditScrollerCell: UITableViewCell, UITextFieldDelegate, FixtureEditor {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var depthSwitch: UISwitch!
    @IBOutlet weak var offsetStepper: UIStepper!
    @IBOutlet weak var offsetLabel: UILabel!
    @IBOutlet weak var numStepsStepper: UIStepper!
    @IBOutlet weak var numStepsLabel: UILabel!
  
    var validData: Bool!
    
    var propriety: Propriety!
    var parent: FixtureEditViewController!
    
    func setupForPropriety(propriety: ScrollerPropriety, parent:FixtureEditViewController) {
        self.parent = parent
        self.propriety = propriety
        nameTextField.text = String(self.propriety.name)
        nameTextField.delegate = self
        
        self.offsetStepper.value = Double(self.propriety.index)
        self.offsetStepper.wraps = true
        offsetLabel.text = String(Int(offsetStepper.value))
        
        self.numStepsStepper.value = Double((self.propriety as! ScrollerPropriety).locations)
        self.numStepsStepper.wraps = true
        numStepsLabel.text = String(Int(numStepsStepper.value))
        
        depthSwitch.setOn(self.propriety.depth == 16, animated: false)
        
        nameTextField.layer.borderColor = UIColor.clearColor().CGColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.masksToBounds = true
        
        checkValidEntry()
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
            parent.updateSaveButton()
            self.propriety.name = self.nameTextField.text!
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
        self.propriety.index = Int(self.offsetLabel.text!)!
    }
   
    @IBAction func numStepsStepperChanged(sender: UIStepper, forEvent event: UIEvent) {
        numStepsLabel.text = String(Int(sender.value))
        (self.propriety as! ScrollerPropriety).locations = Int(self.numStepsLabel.text!)!
    }
    
    @IBAction func depthSwitched(sender: UISwitch, forEvent event: UIEvent) {
        self.propriety.depth = self.depthSwitch.on ? 16 : 8
    }
}