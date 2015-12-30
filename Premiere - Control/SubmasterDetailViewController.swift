//
//  SubmasterDetailViewController.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-29.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

private let backgroundColour = UIColor(red: 0.975, green: 0.975, blue: 0.975, alpha: 1)

class SubmasterDetailViewController: UICollectionViewController {

    var submaster: Submaster!
    var parentCell: SubmasterTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(SubmasterTombstoneCell.self, forCellWithReuseIdentifier: "SubmasterTombstone")
//        self.collectionView!.registerClass(SubmasterAddCell.self, forCellWithReuseIdentifier: "SubmasterAdd")

        // Do any additional setup after loading the view.

        self.collectionView?.backgroundColor = backgroundColour
        
        self.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.title = self.submaster?.name ?? "No Submaster Selected"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let detailNavView = segue.destinationViewController as! UINavigationController
//        let submasterEditViewController = detailNavView.viewControllers[0] as! SubmasterEditViewController
        
//        SubmasterEditViewController.submaster = self.submaster
//        SubmasterEditViewController.source = self
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (self.submaster != nil) ? 1 : 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 + (self.submaster?.values.count ?? 0)
        default:
            return 0
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == (self.submaster?.values.count ?? 0) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SubmasterAdd", forIndexPath: indexPath) as! SubmasterAddCell
            
            cell.setupForParent(self)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SubmasterTombstone", forIndexPath: indexPath) as! SubmasterTombstoneCell
            cell.setupForFixture(Data.getFixturesWithIndex(self.submaster.values[indexPath.row].fixture)[0])
            
            return cell
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        if (kind == UICollectionElementKindSectionHeader) {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "SubmasterDetailHeader", forIndexPath: indexPath) as! SubmasterHeader
            view.setupForParent(self)
            return view
        } else {
            return collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterView", forIndexPath: indexPath)
        }
    }

    // MARK: UICollectionViewDelegate

    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return true
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    func updateTombstoneValues () {
        if let cells = self.collectionView?.visibleCells() {
            for i in cells {
                if let cell = i as? SubmasterTombstoneCell {
                    cell.reloadValueText()
                }
            }
        }
    }
}

class SubmasterTombstoneCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var fixture: Fixture!
    
    func setupForFixture (fixture: Fixture) {
        self.fixture = fixture
        self.nameLabel.text = self.fixture.name
        self.indexLabel.text = "#" + String(self.fixture.index)
        self.reloadValueText()
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.layer.cornerRadius = 8.0
    }
    
    func reloadValueText () {
        self.valueLabel.text = (String(Int((self.fixture.getProprietyAsDouble("Intensity") ?? 0) * 100))) + "%"
    }
}

class SubmasterAddCell: UICollectionViewCell {
    @IBOutlet weak var addFixtureButton: UIButton!
    
    func setupForParent (parent: SubmasterDetailViewController) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.layer.cornerRadius = 8.0
    }
    
    @IBAction func addFixturePressed(sender: UIButton, forEvent event: UIEvent) {
        
    }
}

class SubmasterHeader: UICollectionReusableView {
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var valueLabel: UILabel!
    
    var submaster: Submaster!
    var parent: SubmasterDetailViewController!
    
    private var labelText: String {
        return (self.valueSlider.value != 1.0) ? String(format: "%.1f", arguments: [self.valueSlider.value * 100.0]) + "%" : "100%"
    }
    
    func setupForParent (parent: SubmasterDetailViewController) {
        self.parent = parent
        self.valueSlider.value = Float(self.parent.submaster.intensity)
        self.valueLabel.text = labelText
    }
   
    @IBAction func valueChanged(sender: UISlider, forEvent event: UIEvent) {
        self.parent.submaster.intensity = Double(self.valueSlider.value)
        self.parent.parentCell.setupForSubmaster(self.parent.submaster)
        self.parent.updateTombstoneValues()
        self.valueLabel.text = labelText
    }
    
    @IBAction func valueFinishedEditing(sender: UISlider, forEvent event: UIEvent) {
        
    }
}
