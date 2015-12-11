//
//  Dimmer.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-02.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class Dimmer: NSObject {
    // MARK: Proprieties
    
    var index: Int
    var intesity: UInt8 {
        // Before updating intesity values
        willSet (newIntesity) {
            for delegate in delegates {
                delegate.dimmerValueChanged(self, newValue: newIntesity)
            }
        }
    }
    
    var delegates: [DimmerDelegate]
    
    // MARK: Initialisation
    init (index: Int) {
        self.index = index
        self.intesity = 0
        self.delegates = [DimmerDelegate]()
    }
}

protocol DimmerDelegate {
    func dimmerValueChanged(source: Dimmer, newValue: UInt8)
}