//
//  Communications.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2016-01-15.
//  Copyright © 2016 Samuel Dewan. All rights reserved.
//

import Foundation



class Communications {
    private static let CMD_GET: UInt8 = 0b00011
    
    private static let ID_ADC: UInt8 = 0b0010
    private static let ID_BUTTON: UInt8 = 0b0011
    
    static var socket: ConsoleSocket!
    static var host = "192.168.2.10"
    
    static var timer = NSTimer()
    
    // Describes a possible type of value that could be polled
    enum pollType {
        case NONE
        case ADC
        case BUTTONS
    }

    /**
     * Initilaizes the communications subsystem (hopfully)
     *
     * @remark Must be called first!!!
     */
    static func start() {
        socket = ConsoleSocket(ip: host)
        
        let bytes:[UInt8] = [0b00000011, 0b00000000]
        socket.send(bytes)
        
//        timer = NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: "poll", userInfo: nil, repeats: true)
    }
    
    private static var lastPolled = pollType.NONE
    
    @objc static func poll () {
        switch lastPolled {
        case .NONE:
            lastPolled = .ADC
            sendGet(.ADC)
        case .ADC:
            lastPolled = .BUTTONS
            sendGet(.BUTTONS)
        case .BUTTONS :
            lastPolled = .ADC
            sendGet(.ADC)
        }
    }
    
    static func sendGet (type: pollType) {
        var packet = Array<UInt8>()
        
        packet.append(CMD_GET)
        
        switch type {
        case .NONE:
            return
        case .ADC:
            packet.append(ID_ADC)
        case .BUTTONS:
            packet.append(ID_BUTTON)
        }
        
        socket.send(packet)
    }
    
    static func handleResponse (data: Array<UInt8>) {
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
    
    static func processGet (data: Array<UInt8>) {
        
    }
    
    static func sendDMXFromStartAddress (startAddress: UInt16, data: Array<UInt8>) {
        var packet = [UInt8(0b00000010), UInt8(0b00000001), UInt8((startAddress >> 8) & 0xff), UInt8(startAddress & 0xff)]
        packet.appendContentsOf(data)
        socket.send(packet)
    }
    
    static func setSubmasterValues (values: [UInt8]) {
        for (index, value) in values.enumerate() {
            guard index < Data.submasters.count else {return}
            
            Data.submasters[index].intensity = (Double(value) / 255.0)
        }
    }
}