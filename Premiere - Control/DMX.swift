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
    
    
    // MARK: Helper functions
    static func dmxValuesFromInt(value: Int) -> [UInt8] {
        if value < 256 {
            return [UInt8(value)]
        } else if value < 65536 {
            return [UInt8(value >> 8), UInt8(value & 0xFF)]
        }  else {
            print("DMX Value too large for for 16 bits");
            return [0]
        }
    }
}