//
//  PopoverPicker.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-30.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class PopoverPicker: NSObject, UIPopoverPresentationControllerDelegate {
    private var tableView: PickerTableViewController
    private var completion: ((Int) -> Void)?
    var data: [(name: String, secondary: String?)]
    
    init (data: [(name: String, secondary: String?)], width: Int? = nil, height: Int? = nil, completion: ((Int) -> Void)? = nil) {
        self.completion = completion
        self.data = data
        
        let storyboard = UIStoryboard(name: "Aux", bundle: nil)
        self.tableView = storyboard.instantiateViewControllerWithIdentifier("PickerTableViewController") as! PickerTableViewController
        
        super.init()
        
        self.tableView.setupForData(self.data, completion: self.completion)
        
        self.tableView.modalPresentationStyle = .Popover
        let computedHeight = height ?? min(350, (self.data.count * 44))
        self.tableView.preferredContentSize = CGSize(width: width ?? 300, height: computedHeight)
    }
    
    func showViewFromController (controller: UIViewController, sender: UIView, sourceRect: CGRect) {
        if let popoverController = self.tableView.popoverPresentationController {
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
            popoverController.sourceView = sender
            popoverController.sourceRect = sourceRect
            controller.presentViewController(self.tableView, animated: true, completion: nil)
        }
    }
}


class PickerTableViewController: UITableViewController {
    var data: [(name: String, secondary: String?)]!
    private var completion: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func setupForData(data: [(name: String, secondary: String?)], completion: ((Int) -> Void)? = nil) {
        self.data = data
        self.completion = completion
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
             return data.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("PopoverPickerCell", forIndexPath: indexPath) as! PickerTableViewCell
            let rowData = data[indexPath.row]
            cell.setupForName(rowData.name, secondary: (rowData.secondary == nil ? "" : "#" + rowData.secondary!))
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("PopoverCancelCell", forIndexPath: indexPath) as! PickerCancelCell
            cell.setupForParent(self)
            return cell
        default:
            print("Too many sections in popover picker table")
            return self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 1))!
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.completion?(indexPath.row)
    }
}

class PickerTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    func setupForName(name: String, secondary: String) {
        self.nameLabel.text = name
        self.secondaryLabel.text = secondary
    }
}

class PickerCancelCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    var parent: PickerTableViewController?
    
    func setupForParent(parent: PickerTableViewController) {
        self.parent = parent
    }
    
    @IBAction func cancelPressed(sender: UIButton, forEvent event: UIEvent) {
        self.parent?.dismissViewControllerAnimated(true, completion: nil)
    }
}