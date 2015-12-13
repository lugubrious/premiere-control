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
    @IBOutlet weak var offsetStepper: UIStepper!
    @IBOutlet weak var offsetTextField: UILabel!
    
    var parent: FixtureEditViewController!
    
    func setupForFixture(fixture: Fixture, parent:FixtureEditViewController) {
        self.parent = parent
        nameTextField.text = String(fixture.index)
        nameTextField.delegate = self
        
        nameTextField.layer.borderColor = UIColor.clearColor().CGColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.masksToBounds = true
    }
    
    // MARK: Text fied delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        parent.saveButton.enabled = false
    }
    
    func checkValidEntry () {
        // Disable the Save button if the text field is empty.
        
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
    @IBAction func depthSwitched(sender: UISwitch, forEvent event: UIEvent) {
    }
    
    @IBAction func offsetStepperChanged(sender: UIStepper, forEvent event: UIEvent) {
    }
    

    
    func updateFixture (fixture: Fixture) {
        
    }
}