//
//  Communications.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2016-01-15.
//  Copyright © 2016 Samuel Dewan. All rights reserved.
//

import Foundation


/// Implements protocol for communicating with console
class Communications {
    // Protocol codes...
    private static let CMD_GET: UInt8 = 0b00011
    
    private static let ID_ADC: UInt8 = 0b0010
    private static let ID_BUTTON: UInt8 = 0b0011
    
    
    /// The socket which represents the low level commonuctaions system
    static var socket: ConsoleSocket!
    /// The host which the console would connect to.
    static var host = "192.168.2.10"
    // The host could be automoatically discovered with UDP mulitcast, but there is not much point since DHCP does not work on the console

    /**
     * Initilaizes the communications subsystem (hopfully)
     *
     * - remark: Must be called first!!!
     */
    static func start() {
        socket = ConsoleSocket(ip: host)
        
        // Send a brief hello message in the form of a request for an info string
        let bytes:[UInt8] = [0b00000011, 0b00000000]
        socket.send(bytes)
    }

    /**
     * Process a packet from the console
     * - parameter data: The recieved packet
     */
    static func handleData (data: Array<UInt8>) {
        guard data.count > 1 else {return}
        
        switch data[0] {
        case 0b00000000: //ping
            let packet = [UInt8(0b00000001), UInt8(data[1])]
            socket.send(packet)
        case 0b00000001: //ping response
            break
        case 0b00000010: //set
            processSet(data)
        case 0b00000011: //get
            processGet(data)
        case 0b00000100: //event
            break
        default:
            break
        }
    }
    
    /**
     * Process a set packet recived from the console
     * - parameter data: The packet from the console
     */
    static func processSet (data: Array<UInt8>) {
        switch data[1] {
        case 0b00000000: //info string
            let subData = data[2..<data.count]
            print(String(bytes: subData, encoding: NSUTF8StringEncoding))
        case 0b00000001: //dmx value
            break
        case 0b00000010: // ADC value
            let subData = Array(data[2..<data.count])
            setSubmasterValues(subData)
        case 0b00000011: // Button events
            break
        default: break
        }
    }
    
    /**
     * Process a get packet from the console
     * - parameter data: The packet from the console
     */
    static func processGet (data: Array<UInt8>) {
        // TODO: delete this comment and write some code in it's place
        // (at the moment there isn't any reason for the console to requrest data from the app, so it's not a high priority)
    }
    
    /**
     * Send a set of DMX values
     * - parameter startAddress: The address of the first dimmer for which data is being sent
     * - parameter data: The new dimmer values to be sent
     */
    static func sendDMXFromStartAddress (startAddress: UInt16, data: Array<UInt8>) {
        var packet = [UInt8(0b00000010), UInt8(0b00000001), UInt8((startAddress >> 8) & 0xff), UInt8(startAddress & 0xff)]
        packet.appendContentsOf(data)
        socket.send(packet)
    }
    
    /**
     * Update submasters to new intensity values given by the console
     * - parameter values: The new values to set
     */
    static func setSubmasterValues (values: [UInt8]) {
        for (index, value) in values.enumerate() {
            guard index < Data.submasters.count else {return} // Make sure we are not addressing non-existant submasters
            
            Data.submasters[index].intensity = (Double(value) / 255.0)
        }
    }
}