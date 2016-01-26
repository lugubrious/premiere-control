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
    var intensity: UInt8 {
        // Before updating intensity values
        willSet (newIntesity) {
            // Notify any delegates that the value has changed
            // TODO: Spawn a new thread for this?
            for delegate in delegates {
                delegate.dimmerValueChanged(self, newValue: newIntesity)
            }
        }
    }
    
    // I'm not sure if it is "Swifty" to have multiple delgates, but I want to have multiple delegates, so I do
    var delegates: [DimmerDelegate]
    
    // MARK: Initialisation
    init (index: Int) {
        self.index = index
        self.intensity = 0
        self.delegates = [DimmerDelegate]()
    }
}

protocol DimmerDelegate {
    func dimmerValueChanged(source: Dimmer, newValue: UInt8)
}