//
//  DMX.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-02.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import Foundation

let numDimmers = 1024

var dmx = DMX()

class DMX: DimmerDelegate {
    
    var dimmers: [Dimmer]
    
    init () {
        dimmers = [Dimmer]()
        for i in 0..<1024 {
            dimmers.append(Dimmer(index: i));
            dimmers[i].delegates.append(self)
        }
    }
    
    // MARK: Functions
    func sendDMXPacket () {
        // Put network stuff here
    }
    
    // MARK: Dimmer delegate
    func dimmerValueChanged (source: Dimmer, newValue value: UInt8) {
        sendDMXPacket()
    }
}