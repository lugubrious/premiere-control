//
//  SubmasterTableViewCell.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-11-27.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class SubmasterTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    func setupForSubmaster (submaster: Submaster) {
        self.nameLabel.text = submaster.name
        self.indexLabel.text = "#" + String(submaster.index)
        self.valueLabel.text = String(Int(submaster.intensity * 100.0)) + "%"
        
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
