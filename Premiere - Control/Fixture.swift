//
//  Fixture.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-11-27.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

/// An abstraction representing a single stage light, anything from a bare lightbulb to a moving head
class Fixture: NSObject, NSCoding, NSCopying {
    // MARK: Properties
    
    /// Where to save the fixture data
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    /// File name for the fixture data
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("fixtures")
    
    var name: String
    var address: Int
    var index: Int
    
    /// The properties contained by this fixture
    var properties: [Property]
    
    // Keys for the properties when saved in a plist
    struct PropertyKey {
        static let nameKey = "fixtureName"
        static let addressKey = "fixtureAddress"
        static let indexKey = "fixtureIndex"
        static let propCountKey = "fixturePropertiesCount"
        static let propKey = "fixtureProperty"
    }
    
    /// Reutrns the length in addresss space of this fixture
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
        // TODO: This doesn't seem to get called often enough. Is there a memory leak somwhere, or is automatic refrence counting just slow to release te fixtures?
        print("Deinit Fixture: \(self.name)")
    }
    
    // MARK: Functions
    
    /// Updates the dmx values for the fixture
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
    
    /**
     * Get a property belonging to this fixture with a specific name
     * - parameter name: The name of the desired property
     * - return: The first property with the specified name, or nil if there is no such property
     */
    func getPropertyWithName (name: String) -> Property? {
        for prop in properties {
            if prop.name == name {
                return prop
            }
        }
        return nil
    }
    
    /**
     * Get the value of a propery belonging to this fixture as a double if possible
     * - parameter name: The name of the desired property
     * - return: The value as a double of the first property with the specified name, or nil if there is no such property or the property with the specified name does not have a double value
     */
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
    
    /**
     * Get the value of a propery belonging to this fixture as an int if possible
     * - parameter name: The name of the desired property
     * - return: The value as an int of the first property with the specified name, or nil if there is no such property or the property with the specified name does not have an integer value
     */
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
    
    /**
     * Get the value of a propery belonging to this fixture as an (Int, Int) tuple if possible
     * - parameter name: The name of the desired property
     * - return: The value as a tuple of the first property with the specified name, or nil if there is no such property or the property with the specified name does not have a tuple value
     */
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
    
    /**
     * Get the value of a propery belonging to this fixture as an UIColor if possible
     * - parameter name: The name of the desired property
     * - return: The value as a UIColor of the first property with the specified name, or nil if there is no such property or the property with the specified name does not have a colour value
     */
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
    
    /**
     * Calculate the length in addresss space of a list of properties
     * - parameter properties: The list of properties
     * - return: The length in address space of the give properties
     */
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
    
    /**
     * Use a given NSCoder to encode all of this fixtures properties
     * - parameter aCode: The NSCoder to encode with
     */
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
    
    /**
    * Create a copy of this fixture
    * - parameter zone: Unused, an Obj-C concept that does not apply in Swift
    * - return: A fixture with all of the same properites as this one
    */
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Fixture(name: self.name, address: self.address, index: self.index)!
        copy.properties = self.properties.map({($0.copyWithZone(nil)) as! Property})
        return copy
    }
}
