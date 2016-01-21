//
//  ConsoleConnection.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2016-01-01.
//  Copyright © 2016 Samuel Dewan. All rights reserved.
//

import Foundation

private let port: UInt16 = 6562

class ConsoleConection {
    
    var socket: TCPIPSocket
    var stream: NSFileHandle
    
    var dataBuffer: [NSData]
    
    init (address: [UInt8]) {
        self.socket = TCPIPSocket()
        
        self.socket.connect(TCPIPSocketAddress(address[0], address[1], address[2], address[3]), port)
        
        self.stream = socket.instantiateFileHandle()
        
        dataBuffer = [NSData]()
        
        self.stream.readabilityHandler = readData
        self.stream.writeabilityHandler = writeData
    }
    
    /**
     * Called whenever there is data avaliable to be read from the socket
     *
     */
    private func readData (handle: NSFileHandle!) {
        let data = handle.readDataToEndOfFile()
        
        if let str = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
            print(str)
        } else {
            print("packet is not a valid UTF-8 sequence")
        }
    }
    
    /**
     * Called whenever more data can be writen to the socket
     *
     */
    private func writeData (handle: NSFileHandle!) {
        if let data = dataBuffer.first {
            handle.writeData(data)
            dataBuffer.removeFirst()
        }
    }

    
    
    
    /*    func getLocalhostIP () -> [UInt8] {
    
    var ifaddr: UnsafeMutablePointer<ifaddrs> = nil
    if getifaddrs(&ifaddrs) == 0 {
    // Iterate through interfaces
    var ptr = ifaddr;
    while (ptr != nil) {
    let flags = Int32(ptr.memory.ifa_flags)
    var addr = ptr.memory.ifa_addr.memory
    
    if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
    
    }
    }
    
    ptr = ptr.memory.ifa_next
    }
    }
    
    return [8 as UInt8]
    }*/
}