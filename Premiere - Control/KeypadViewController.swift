//
//  KeypadViewController.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-07.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

//private let backgroundColour = UIColor(red:0.239, green: 0, blue: 1, alpha: 1)
private let backgroundColour = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
private let highlightedColour = UIColor(red: 0.0, green: 1.0, blue: 0.1, alpha: 1.0).CGColor

class KeypadViewController: UIViewController {
    @IBOutlet weak var displayLabel: UILabel!

    @IBOutlet weak var buttonF1: UIButton!
    @IBOutlet weak var buttonF2: UIButton!
    @IBOutlet weak var buttonF3: UIButton!
    @IBOutlet weak var buttonF4: UIButton!
    
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var buttonClear: UIButton!
    
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var buttonAnd: UIButton!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var buttonExcept: UIButton!
    
    @IBOutlet weak var buttonThru: UIButton!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var buttonAt: UIButton!
    @IBOutlet weak var buttonEnter: UIButton!
    
    var buttons = [UIButton]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.preferredContentSize = CGSize(width: 320, height: 480) // Size that the view will have when displayed as a popover on iPad, screen size of iPhone 2g/3g/3gs/4/4s
        
        self.view.backgroundColor = backgroundColour
        self.displayLabel.layer.cornerRadius = 8.0
        
        self.buttons = [self.buttonF1, self.buttonF2, self.buttonF3, self.buttonF4, self.button7, self.button8, self.button9, self.buttonClear, self.button4, self.button5, self.button6, self.buttonAnd, self.button1, self.button2, self.button3, self.buttonExcept, self.buttonThru, self.button0, self.buttonAt, self.buttonEnter]
        
        for i in self.buttons {
            i.layer.borderColor = i.tintColor.CGColor
            i.layer.borderWidth = 1.0
            i.layer.cornerRadius = 8.0
        }
        self.buttonAt.layer.borderColor = highlightedColour
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    @IBAction func done(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
