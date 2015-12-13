//
//  Fixture.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-11-27.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class Fixture: NSObject, NSCoding {
    // MARK: Properties
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("fixtures")
    
    var name: String
    var address: Int
    var index: Int
    
    var proprieties: [Propriety]
    
    // MARK: Initilization
    
    init? (name: String, address: Int, index: Int) {
        // Initialize proprieties
        self.name = name
        self.address = address
        self.index = index
        
        self.proprieties = [Propriety]()
        
        super.init()
        
        // Initializer fails if name is empty or if index is less than zero
        if name.isEmpty || index < 0 {
            return nil
        }
    }
    
    deinit {
        print("Deinit Fixture: \(self.name)")
    }
    
    // MARK: Functions
    /**
     *  Updates the dmx values for the fixture
     */
    func update() {
        let outputs = proprieties.sort({$0.index > $1.index})
        for output in outputs {
            let dmxValues = output.getDMXValues()
            let address = self.index + output.index
            for i in address..<address + dmxValues.count {
                dmx.dimmers[i].intesity = dmxValues[i - address]
            }
        }
    }
    
    func getProprietyAsDouble(name: String) -> Double? {
        for prop in proprieties {
            if prop.name == name {
                switch prop.value {
                case.Generic(let val):
                    return val
                default:
                    return nil
                }
            }
        }
        return nil
    }
    
    func getProprietyAsInt(name: String) -> Int? {
        for prop in proprieties {
            if prop.name == name {
                switch prop.value {
                case.Scroller(let val):
                    return val
                default:
                    return nil
                }
            }
        }
        return nil
    }
    
    func getProprietyAsTuple(name: String) -> (Int,Int)? {
        for prop in proprieties {
            if prop.name == name {
                switch prop.value {
                case.Position(let val):
                    return val
                default:
                    return nil
                }
            }
        }
        return nil
    }
    
    func getProprietyAsColour(name: String) -> UIColor? {
        for prop in proprieties {
            if prop.name == name {
                switch prop.value {
                case.Colour(let val):
                    return val
                default:
                    return nil
                }
            }
        }
        return nil
    }
    
    // MARK: Encoding
    
    func encodeWithCoder(aCoder: NSCoder) {
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(name: "George", address: 0, index: 0)
    }
}
