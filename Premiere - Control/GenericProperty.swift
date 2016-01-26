//
//  GenericPropriety.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-07.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class GenericProperty: NSObject, NSCoding, Property {
    // MARK: Constants
    let sortOrder = 30
    
    // MARK: Protocol Variables
    var parent: Fixture?
    var value: PropertyType {
        didSet {
            switch value {
            case .Generic:
                parent?.update()
                return
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
    /// Gets the value of this property in its raw form
    var unwrappedValue: Double? {
        switch value {
        case .Generic(let val):
            return val
        default:
            return nil
        }
    }
    
    /// Keys used when saving this property to a plist
    struct PropertyKey {
        static let nameKey = "genericName"
        static let valueKey = "genericValue"
        static let indexKey = "genericIndex"
        static let depthKey = "genericDepth"
    }
    
    // MARK: Initilization
    convenience init? (index: Int, parent: Fixture?, name: String, initialValue: PropertyType, depth: Int) {
        self.init(index: index, parent: parent)
        self.value = initialValue
        if !name.isEmpty {
            self.name = name
        } else {
            return nil
        }
        self.depth = depth
    }
    
    required init (index: Int, parent: Fixture?) {
        value = PropertyType.Generic(0.0)
        self.index = index
        self.parent = parent
        self.depth = 8
        self.name = "Propriety"
    }
    
    // MARK: Protocol Functions
    func getDMXValues() -> [UInt8] {
        if let val = unwrappedValue {
            return DMX.dmxValuesFromInt(Int(val * Double(maxValue)))
        } else {
            return [0]
        }
    }

    func setUpTableCell(cell: UITableViewCell) -> UITableViewCell {
        return cell
    }
    
    // MARK: Encoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: PropertyKey.nameKey)
        switch self.value {
        case .Generic(let val):
            aCoder.encodeDouble(val, forKey: PropertyKey.valueKey)
        default:
            break
        }
        aCoder.encodeInteger(self.index, forKey: PropertyKey.indexKey)
        aCoder.encodeInteger(self.depth, forKey: PropertyKey.depthKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let index = aDecoder.decodeIntegerForKey(PropertyKey.indexKey)
        let depth = aDecoder.decodeIntegerForKey(PropertyKey.depthKey)
        let rawValue = aDecoder.decodeDoubleForKey(PropertyKey.valueKey)
        let value = PropertyType.Generic(rawValue)
        
        self.init(index: index, parent: nil, name: name, initialValue: value, depth: depth)
    }
    
    // MARK: Copying
    
    /// Create a copy of this fixture
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return GenericProperty(index: self.index, parent: self.parent, name: self.name, initialValue: self.value, depth: self.depth)!
    }
}