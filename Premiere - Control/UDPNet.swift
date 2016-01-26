//
//  UDPNet.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2016-01-21.
//  Copyright © 2016 Samuel Dewan. All rights reserved.
//
//  This code is based off of examples from the CocoaAsyncSocket project as well as other internet sources
//

import Foundation
import CocoaAsyncSocket

/// The lowerish level networking code
class ConsoleSocket: NSObject, GCDAsyncUdpSocketDelegate {
    
    /// The ip address to which the socket will connect
    var ip: String
    /// The port that the socket will connect on
    let PORT:UInt16 = 6562
    /// The lower level socket
    var socket:GCDAsyncUdpSocket!
    
    init(ip: String = "192.168.2.10"){
        self.ip = ip
        super.init()
        setupConnection()
    }
    
    /**
     * Connect the the socket
     */
    func setupConnection(){
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        do {
            try self.socket.connectToHost(self.ip, onPort: self.PORT)
            try self.socket.beginReceiving()
        } catch _ {
            //Error!!!
            fatalError("Network connection threw")
        }
    }
    
    /**
     * Handle data recieved from a socket
     * - parameter sock: The socket which initiated this event
     * - parameter didReceiveData: Data
     * - parameter fromAddress: Address that data was recived from
     * - parameter withFilterContext: Context (unused)
     */
    func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!,      withFilterContext filterContext: AnyObject!) {
        let count = data.length / sizeof(UInt8)
        var bytes = [UInt8](count: count, repeatedValue: 0)
        
        data.getBytes(&bytes, length: count)
        Communications.handleData(bytes)
        
        print("incoming message: \(data)");
    }
    
    /**
     * Handle the socket connecting to an address
     * - parameter sock: The socket which initiated this event
     * - parameter didConnectToAddress: The address connected to
     */
    func udpSocket(sock: GCDAsyncUdpSocket!, didConnectToAddress address: NSData!) {
        print("didConnectToAddress \(address)");
    }
    
    /**
     * Handle an error in connecting to the host
     * - parameter sock: The socket which initiated this event
     * - parameter error: The error
     */
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotConnect error: NSError!) {
        print("didNotConnect \(error)")
    }
    
    /**
     * Called when data is sucessfully sent
     * - parameter sock: The socket which initiated this event
     * - parameter didSendDataWithTag: The tag assigned to the data at the time it was sent
     */
    func udpSocket(sock: GCDAsyncUdpSocket!, didSendDataWithTag tag: Int) {
//        print("didSendDataWithTag \(tag)")
    }
    
    /**
     * Called when data is not sucessfully sent
     * - parameter sock: The socket which initiated this event
     * - parameter didNotSendDataWithTag: The tag assigned to the data at the time it was sent
     * - parameter dueToError: The error
     */
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotSendDataWithTag tag: Int, dueToError error: NSError!) {
        print("didNotSendDataWithTag \(tag)")
    }
    
    /**
     * Send data to the socket
     * - parameter bytes: The data to be sent
     */
    func send(bytes: Array<UInt8>) {
        let data = NSData(bytes: bytes, length: bytes.count)
        let timeout = NSTimeInterval(0.2)
        socket.sendData(data, withTimeout: timeout, tag: 0)
    }
}
