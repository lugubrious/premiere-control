//
//  DMX.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-02.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import Foundation

let numDimmers = 1024

class DMX: DimmerDelegate {
    var dimmers: [Dimmer]
    
    init () {
        dimmers = [Dimmer]()
        // Initialize two universes worth of dimmers
        for i in 0...1023 {
            dimmers.append(Dimmer(index: i));
            dimmers[i].delegates.append(self)
        }
    }
    
    // MARK: Functions
    
    /**
     * Send all of the DMX values to the console
     */
    func sendDMXPacket () {
        // Packet is broken into 4 parts to make sure that it fits into the console's buffer
        Communications.sendDMXFromStartAddress(0, data: getDmxValuesAsBytesFromStartAddress(0, numValues:  256))
        Communications.sendDMXFromStartAddress(0, data: getDmxValuesAsBytesFromStartAddress(256, numValues:  256))
        Communications.sendDMXFromStartAddress(0, data: getDmxValuesAsBytesFromStartAddress(512, numValues:  256))
        Communications.sendDMXFromStartAddress(0, data: getDmxValuesAsBytesFromStartAddress(768, numValues:  256))
    }
    
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
    
    // MARK: Dimmer delegate
    /**
     * handle an updated DMX value
     * - parameter source: The dimmer that changed
     * - parameter newValue: The updated value
     */
    func dimmerValueChanged (source: Dimmer, newValue value: UInt8) {
        let index = dimmers.indexOf(source)!
        Communications.sendDMXFromStartAddress(UInt16(source.index), data: getDmxValuesAsBytesFromStartAddress(index, numValues: 1))
    }

    /**
     * Get an array of dmx values starting at a specific address
     * - parameter startAddress: The first dimmer to get
     * - parameter numValues: The number of dimmers to get
     * - returns: The values currently assigned to the specified dimmers
     */
    func getDmxValuesAsBytesFromStartAddress (startAddress: Int, numValues: Int) -> [UInt8] {
        var data = [UInt8]()
        for (index, dimmer) in dimmers.enumerate() {
            if (index - startAddress) >= numValues {
                break
            } else if index >= startAddress {
                data.append(dimmer.intensity)
            }
        }
        return data
    }
}