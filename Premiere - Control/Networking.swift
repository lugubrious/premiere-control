//
//  Networking.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2016-01-09.
//  Copyright © 2016 Samuel Dewan. All rights reserved.
//

import Foundation

private var PORT = 6562

class Connection: NSObject, NSStreamDelegate {
    var inputStream : NSInputStream?
    var outputStream : NSOutputStream?
    
    var dataBuffer: [NSData] = [NSData]()
    
    var host: String
    
    init (host: String) {
        self.host = host
    }

    // Gets a lock on object before calling closure then release object
    static func syncronized (object: AnyObject, closure: ()->()) {
        objc_sync_enter(object)
        closure()
        objc_sync_exit(object)
    }
    
    // Causes any data that is in the buffer to be send asynchronously
    func send() {
        connectToHost(self.host)
    }
    
    // Get streams for a host
    func connectToHost(host: String) {
        inputStream?.close()
        outputStream?.close()
        
        inputStream = nil
        outputStream = nil
        
        NSStream.getStreamsToHostWithName(host, port: PORT, inputStream: &inputStream, outputStream: &outputStream)
        
        inputStream!.delegate = self
        outputStream!.delegate = self
        
//        setKeepAliveForStream(inputStream!)
//        setKeepAliveForStream(outputStream!)
        
        inputStream!.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream!.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
        inputStream!.open()
        outputStream!.open()
        
//        NSRunLoop.currentRunLoop().run()
    }
    
/*    private func setKeepAliveForStream (stream: NSStream) {
        var socketData: NSData?
        
        if let theStream = stream as? NSInputStream {
        socketData = CFReadStreamCopyProperty(theStream as CFReadStreamRef, kCFStreamPropertySocketNativeHandle) as? NSData
        } else if let theStream = stream as? NSOutputStream {
        socketData = CFWriteStreamCopyProperty(theStream as CFWriteStreamRef, kCFStreamPropertySocketNativeHandle) as? NSData
        }
        
        if let data = socketData {
            var socket: CFSocketNativeHandle = 0
            data.getBytes(&socket, length: sizeofValue(socket))
        
            var on: UInt32 = 1;
            if setsockopt(socket, SOL_SOCKET, SO_KEEPALIVE, &on, socklen_t(sizeofValue(on))) != 0 {
                let errmsg = String.fromCString(strerror(errno))
                print("setsockopt failed: \(errno) \(errmsg)")
            }
        }
    }*/
    
    func stream (aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        switch eventCode {
        case NSStreamEvent.HasBytesAvailable:
            print("stream has bytes")
            guard let stream = (aStream as? NSInputStream) else {return}
            let bufferSize = 512
            var buffer = Array<UInt8>(count: bufferSize, repeatedValue: 0)
            
            let bytesRead = stream.read(&buffer, maxLength: bufferSize)
            if bytesRead >= 0 {
                let output = NSString(bytes: &buffer, length: bytesRead, encoding: NSUTF8StringEncoding)
                print("Packet: \(output)")
                Communications.handleResponse(buffer);
            } else {
                print("Error reading bytes from input stream")
            }
        case NSStreamEvent.HasSpaceAvailable:
            print("stream has space")
            Connection.syncronized(dataBuffer) {
                guard let stream = (aStream as? NSOutputStream) else {return}
                if let data = self.dataBuffer.first {
                    let bufferSize = 400 // The buffer of the console is only 400 bytes long, no point sending more than that
                    var buffer = Array<UInt8>(count: bufferSize, repeatedValue: 0)
                
                    data.getBytes(&buffer, length: min(bufferSize, data.length))
            
                    stream.write(&buffer, maxLength: min(bufferSize, data.length))
                    
                    self.dataBuffer.removeAtIndex(0)
                } else {
                    var buffer = Array<UInt8>(count: 1, repeatedValue: 0)
                    stream.write(&buffer, maxLength: 0)
                }
            }
        case NSStreamEvent.ErrorOccurred:
            return
        case NSStreamEvent.EndEncountered:
            return
        case NSStreamEvent.OpenCompleted:
//            print("stream has opened")
            return
        case NSStreamEvent.None:
            return
        default:
            return
        }
    }
}