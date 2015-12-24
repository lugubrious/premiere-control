//
//  ColourPropriety.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-07.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class ColourProperty: NSObject, Property {
    // MARK: Constants
    static let sortOrder = 60
    
    // MARK: Protocol Variables
    var parent: Fixture
    var value: PropertyType {
        didSet {
            switch value {
            case .Colour:
                parent.update()
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
    enum ColourOutputMode {
        case CMY
        case RGB
        case HSI
    }
    
    var outputMode: ColourOutputMode
    
    private var unwrappedValue: UIColor? {
        switch value {
        case .Colour(let val):
            return val
        default:
            return nil
        }
    }
    
    // MARK: Initilization
    required init (index: Int, parent: Fixture) {
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
            switch (outputMode) {
            case .RGB:
                var colour = [CGFloat](count: 3, repeatedValue: CGFloat())
                val.getRed(&colour[0], green: &colour[1], blue: &colour[2], alpha: nil);
                
                let max = CGFloat(maxValue)
                return [UInt8(colour[0] * max), UInt8(colour[1] * max), UInt8(colour[2] * max)]
            case .CMY:
                // TODO: Implement HSI output
                fallthrough
            case .HSI:
                var colour = [CGFloat](count: 3, repeatedValue: CGFloat())
                val.getHue(&colour[0], saturation: &colour[1], brightness: &colour[2], alpha: nil);
                let max = CGFloat(maxValue)
                return [UInt8(colour[0] * max), UInt8(colour[1] * max), UInt8(colour[2] * max)]
            }
        } else {
            return[0,0,0]
        }
    }
    
    func setUpTableCell(cell: UITableViewCell) -> UITableViewCell {
        return cell
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