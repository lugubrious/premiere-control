//
//  ColourPropriety.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-07.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class ColourProperty: NSObject, NSCoding, Property {
    // MARK: Constants
    let sortOrder = 50
    
    // MARK: Protocol Variables
    var parent: Fixture?
    var value: PropertyType {
        didSet {
            switch value {
            case .Colour:
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
    enum ColourOutputMode : Int {
        case CMY = 0
        case RGB
        case HSI
    }
    
    /// The colour space used for DMX output
    var outputMode: ColourOutputMode
    
    /// Gets the value of this property in its raw form
    var unwrappedValue: UIColor? {
        switch value {
        case .Colour(let val):
            return val
        default:
            return nil
        }
    }
    
    /// Keys used when saving this property to a plist
    struct PropertyKey {
        static let nameKey = "colourName"
        static let valueKey = "colourValue"
        static let indexKey = "colourIndex"
        static let depthKey = "colourDepth"
        static let modeKey = "colourOutputMode"
    }
    
    // MARK: Initilization
    required init (index: Int, parent: Fixture?) {
        value = PropertyType.Colour(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        self.index = index
        self.parent = parent
        self.depth = 8
        self.outputMode = .RGB
        self.name = "Colour"
    }
    
    // MARK: Protocol Functions
    func getDMXValues() -> [UInt8] {
        if let val = unwrappedValue {
            var colour = [CGFloat](count: 3, repeatedValue: CGFloat())
            
            switch (outputMode) {
            case .RGB:
                val.getRed(&colour[0], green: &colour[1], blue: &colour[2], alpha: nil);
            case .CMY:
                // TODO: Implement HSI output
                fallthrough
            case .HSI:
                val.getHue(&colour[0], saturation: &colour[1], brightness: &colour[2], alpha: nil);
            }
            
            let max = CGFloat(maxValue)
            var values = [UInt8]()
            values += DMX.dmxValuesFromInt(Int(colour[0] * max))
            values += DMX.dmxValuesFromInt(Int(colour[1] * max))
            values += DMX.dmxValuesFromInt(Int(colour[2] * max))
            return values
        } else {
            return[0,0,0]
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
        
        aCoder.encodeInteger(self.outputMode.rawValue, forKey: PropertyKey.modeKey)
        
        switch self.value {
        case .Colour(let val):
            aCoder.encodeObject(val, forKey: PropertyKey.valueKey)
        default:
            break
        }
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let index = aDecoder.decodeIntegerForKey(PropertyKey.indexKey)
        self.init(index: index, parent: nil)
        
        self.name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        self.depth = aDecoder.decodeIntegerForKey(PropertyKey.depthKey)
        self.outputMode = ColourOutputMode(rawValue: aDecoder.decodeIntegerForKey(PropertyKey.modeKey))!
        
        let rawValue = aDecoder.decodeObjectForKey(PropertyKey.valueKey) as! UIColor
        self.value = PropertyType.Colour(rawValue)
    }
    
    // MARK: Copying
    
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = ColourProperty(index: self.index, parent: self.parent)
        copy.depth = self.depth
        copy.outputMode = self.outputMode
        copy.name = self.name
        copy.value = self.value
        return copy
    }
}