//
//  FixtureTableViewCell.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-07.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class FixtureTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func setup (fixture: Fixture) {
        self.nameLabel.text = fixture.name
        self.addressLabel.text = "#\(fixture.address)"
        
        if let val = fixture.getProprietyAsDouble("Intesity") {
            let intensity = val * 100
            self.valueLabel.text = "\(intensity)%"
        } else if let val = fixture.getProprietyAsInt("Scroller") {
            self.valueLabel.text = "Pos: \(val)"
        } else if let val = fixture.getProprietyAsColour("Colour") {
            // Do something fancy with colour
             self.valueLabel.text = "\(val)"
        } else if let val = fixture.getProprietyAsTuple("Position") {
            self.valueLabel.text = "(\(val.0),\(val.1))"
        } else {
            print("No value propriety found for fixture \(fixture.name)")
            self.valueLabel.text = ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
