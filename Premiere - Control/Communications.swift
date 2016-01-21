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
    
    
    static var connection: Connection?
    static var host = "192.168.2.10"
    
    static var timer = NSTimer()
    
    enum pollType {
        case NONE
        case ADC
        case BUTTONS
    }

    static func start() {
        connection = Connection(host: self.host)
        
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
        
        connection?.dataBuffer.append(NSData(bytes: packet, length: packet.count))
        connection?.send()
    }
    
    static func handleResponse (data: Array<UInt8>) {
        guard data.count > 1 else {return}
        
        switch data[0] {
        case 0b00000000: //ping
            let packet = [UInt8(0b00000001), UInt8(data[1])]
            connection?.dataBuffer.append(NSData(bytes: packet, length: packet.count))
            connection?.send()
        case 0b00000001: //ping response
            break
        case 0b00000010: //set
            break
        case 0b00000011: //get
            break
        case 0b00000100: //event
            break
        default:
            break
        }
    }
    
    static func processSet (data: Array<UInt8>) {
        
    }
    
    static func processGet (data: Array<UInt8>) {
        
    }
}