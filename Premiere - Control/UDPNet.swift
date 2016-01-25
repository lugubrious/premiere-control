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

class ConsoleSocket: NSObject, GCDAsyncUdpSocketDelegate {
    var IP = "192.168.2.10"
    let PORT:UInt16 = 6562
    var socket:GCDAsyncUdpSocket!
    
    init(ip: String = "192.168.2.10"){
        super.init()
        setupConnection()
    }
    
    func setupConnection(){
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        do {
            try self.socket.connectToHost(self.IP, onPort: self.PORT)
            try self.socket.beginReceiving()
        } catch _ {
            //Error!!!
        }
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!,      withFilterContext filterContext: AnyObject!) {
        let count = data.length / sizeof(UInt8)
        var bytes = [UInt8](count: count, repeatedValue: 0)
        
        data.getBytes(&bytes, length: count)
        Communications.handleResponse(bytes)
        
        print("incoming message: \(data)");
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didConnectToAddress address: NSData!) {
        print("didConnectToAddress \(address)");
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotConnect error: NSError!) {
        print("didNotConnect \(error)")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didSendDataWithTag tag: Int) {
//        print("didSendDataWithTag \(tag)")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotSendDataWithTag tag: Int, dueToError error: NSError!) {
        print("didNotSendDataWithTag \(tag)")
    }
    
    func send(bytes: Array<UInt8>) {
        let data = NSData(bytes: bytes, length: bytes.count)
        let timeout = NSTimeInterval(0.2)
        socket.sendData(data, withTimeout: timeout, tag: 0)
    }
}
