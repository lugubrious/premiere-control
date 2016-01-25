//
//  Fixture.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-11-27.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class Fixture: NSObject, NSCoding, NSCopying {
    // MARK: Properties
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("fixtures")
    
    var name: String
    var address: Int
    var index: Int
    
    var properties: [Property]
    
    struct PropertyKey {
        static let nameKey = "fixtureName"
        static let addressKey = "fixtureAddress"
        static let indexKey = "fixtureIndex"
        static let propCountKey = "fixturePropertiesCount"
        static let propKey = "fixtureProperty"
    }
    
    var addressLength: Int {
        return Fixture.addressLengthForProperties(self.properties)
    }
    
    // MARK: Initilization
    
    init? (name: String, address: Int, index: Int) {
        // Initialize proprieties
        self.name = name
        self.address = address
        self.index = index
        
        self.properties = [Property]()
        
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
        let outputs = properties.sort({$0.index > $1.index})
        for output in outputs {
            let dmxValues = output.getDMXValues()
            let address = self.address + output.index
            for i in address..<address + dmxValues.count {
                Data.dmx.dimmers[i].intensity = dmxValues[i - address]
            }
        }
    }
    
    func getPropertyWithName (name: String) -> Property? {
        for prop in properties {
            if prop.name == name {
                return prop
            }
        }
        return nil
    }
    
    func getProprietyAsDouble(name: String) -> Double? {
        for prop in properties {
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
        for prop in properties {
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
        for prop in properties {
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
        for prop in properties {
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
    
    static func addressLengthForProperties(properties: [Property]) -> Int {
        var length = 0
        for i in properties {
            if i is GenericProperty || i is ScrollerProperty {
                length += (i.depth == 8) ? 1 : 2
            } else if i is ColourProperty {
                length += (i.depth == 8) ? 3 : 6
            } else if i is PositionProperty {
                length += (i.depth == 8) ? 2 : 4
            }
        }
        return length
    }
    
    // MARK: Encoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.address, forKey: PropertyKey.addressKey)
        aCoder.encodeObject(self.name, forKey: PropertyKey.nameKey)
        aCoder.encodeInteger(self.index, forKey: PropertyKey.indexKey)
        aCoder.encodeInteger(self.properties.count, forKey: PropertyKey.propCountKey)
        
        for i in 0 ..< self.properties.count {
            aCoder.encodeObject(self.properties[i], forKey: PropertyKey.propKey + String(i))
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let address = aDecoder.decodeIntegerForKey(PropertyKey.addressKey)
        let index = aDecoder.decodeIntegerForKey(PropertyKey.indexKey)
        
        self.init(name: name, address: address, index: index)
        
        let numProperties = aDecoder.decodeIntegerForKey(PropertyKey.propCountKey)
        
        self.properties = [Property]()
        for i in 0 ..< numProperties {
            let prop = aDecoder.decodeObjectForKey(PropertyKey.propKey + String(i)) as! Property
            prop.parent = self
            self.properties.append(prop)
        }
    }
    
    // MARK: Copying
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Fixture(name: self.name, address: self.address, index: self.index)!
        copy.properties = self.properties.map({($0.copyWithZone(nil)) as! Property})
        return copy
    }
}
