//
//  ScrollerPropriety.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-07.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class ScrollerProperty: NSObject, NSCoding, Property {
    // MARK: Constants
    let sortOrder = 70
    
    // MARK: Protocol Variables
    var parent: Fixture?
    var value: PropertyType {
        didSet {
            switch value {
            case .Scroller(let val):
                if (0 <= val) && (val < locations) {
                    parent?.update()
                    return
                }
                fallthrough
            default:
                value = oldValue
            }
        }
    }
    var index: Int
    var depth: Int
    var maxValue: Int {
        return Int(pow(2.0, Double(depth))) - 1
    }
    var name: String
    
    // MARK: Other Variables
    var locations: Int
    
    var unwrappedValue: Int? {
        switch value {
        case .Scroller(let val):
            return val
        default:
            return nil
        }
    }
    
    struct PropertyKey {
        static let nameKey = "scrollerName"
        static let valueKey = "scrollerValue"
        static let indexKey = "scrollerIndex"
        static let depthKey = "scrollerDepth"
        static let locationsKey = "scrollerLocations"
    }
    
    // MARK: Initilization
    required init (index: Int, parent: Fixture?) {
        value = PropertyType.Scroller(0)
        self.index = index
        self.parent = parent
        self.depth = 8
        self.locations = 10
        self.name = "Gel Scroller"
    }
    
    // MARK: Protocol Functions
    func getDMXValues() -> [UInt8] {
        if let val = unwrappedValue {
            return DMX.dmxValuesFromInt(Int(ceil((Double(val)/100.0) * Double(maxValue))))
        } else {
            return[0]
        }
    }
    
    func setUpTableCell(cell: UITableViewCell) -> UITableViewCell {
        return cell
    }
    
    // MARK: Encoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: PropertyKey.nameKey)
        aCoder.encodeInteger(self.index, forKey: PropertyKey.indexKey)
        aCoder.encodeInteger(self.depth, forKey: PropertyKey.depthKey)
        
        aCoder.encodeInteger(self.locations, forKey: PropertyKey.locationsKey)
        
        switch self.value {
        case .Scroller(let val):
            aCoder.encodeInteger(val, forKey: PropertyKey.valueKey)
        default:
            break
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let index = aDecoder.decodeIntegerForKey(PropertyKey.indexKey)
        self.init(index: index, parent: nil)
        
        self.name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        self.depth = aDecoder.decodeIntegerForKey(PropertyKey.depthKey)
        self.locations = aDecoder.decodeIntegerForKey(PropertyKey.locationsKey)
        
        let rawValue = aDecoder.decodeIntegerForKey(PropertyKey.valueKey)
        self.value = PropertyType.Scroller(rawValue)
    }
    
    // MARK: Copying
    
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = ScrollerProperty(index: self.index, parent: self.parent)
        copy.name = self.name
        copy.depth = self.depth
        copy.value = self.value
        copy.locations = self.locations
        return copy
    }
}