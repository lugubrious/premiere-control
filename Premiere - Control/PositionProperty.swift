//
//  PositionPropriety.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-07.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class PositionProperty: NSObject, NSCoding, Property {
    // MARK: Constants
    let sortOrder = 90
    
    // MARK: Protocol Variables
    var parent: Fixture?
    var value: PropertyType {
        didSet {
            switch value {
            case .Position(let pan, let tilt):
                print("\(pan),\(tilt) : Position did set //TODO") // TODO
                parent?.update()
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
    
    var unwrappedValue: (Int,Int)? {
        switch value {
        case .Position(let pan, let tilt):
            return (pan, tilt)
        default:
            return nil
        }
    }
    
    struct PropertyKey {
        static let nameKey = "positionName"
        static let valuePanKey = "positionValuePan"
        static let valueTiltKey = "positionValueTilt"
        static let indexKey = "positionIndex"
        static let depthKey = "positionDepth"
        static let locationsKey = "positionLocations"
    }
    
    // MARK: Initilization
    required init (index: Int, parent: Fixture?) {
        value = PropertyType.Position(0, 0)
        self.index = index
        self.parent = parent
        self.depth = 8
        self.name = "Position"
    }
    
    // MARK: Protocol Functions
    func getDMXValues() -> [UInt8] {
        return[0] // TODO
    }
    
    func setUpTableCell(cell: UITableViewCell) -> UITableViewCell {
        return cell
    }
    
    // MARK: Encoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: PropertyKey.nameKey)
        aCoder.encodeInteger(self.index, forKey: PropertyKey.indexKey)
        aCoder.encodeInteger(self.depth, forKey: PropertyKey.depthKey)
        
        switch self.value {
        case .Position(let pan, let tilt):
            aCoder.encodeInteger(pan, forKey: PropertyKey.valuePanKey)
            aCoder.encodeInteger(tilt, forKey: PropertyKey.valueTiltKey)
        default:
            break
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let index = aDecoder.decodeIntegerForKey(PropertyKey.indexKey)
        self.init(index: index, parent: nil)
        
        self.name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        self.depth = aDecoder.decodeIntegerForKey(PropertyKey.depthKey)
        
        let panValue = aDecoder.decodeIntegerForKey(PropertyKey.valuePanKey)
        let tiltValue = aDecoder.decodeIntegerForKey(PropertyKey.valueTiltKey)
        self.value = PropertyType.Position(panValue, tiltValue)
    }
    
    // MARK: Copying
    
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = PositionProperty(index: self.index, parent: self.parent)
        copy.value = self.value
        copy.name = self.name
        copy.depth = self.depth
        return copy
    }
}