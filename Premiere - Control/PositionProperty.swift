//
//  PositionPropriety.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-07.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class PositionProperty: NSObject, Property {
    // MARK: Constants
    static let sortOrder = 50
    
    // MARK: Protocol Variables
    var parent: Fixture
    var value: PropertyType {
        didSet {
            switch value {
            case .Position(let pan, let tilt):
                print("\(pan),\(tilt) : Position did set //TODO") // TODO
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
    
    private var unwrappedValue: (Int,Int)? {
        switch value {
        case .Position(let pan, let tilt):
            return (pan, tilt)
        default:
            return nil
        }
    }
    
    // MARK: Initilization
    required init (index: Int, parent: Fixture) {
        value = PropertyType.Position(0, 0)
        self.index = index
        self.parent = parent
        self.depth = 8
        self.name = "Position"
    }
    
    // MARK: Protocol Functions
    func getDMXValues() -> [UInt8] {
        return[0]
    }
    
    func setUpTableCell(cell: UITableViewCell) -> UITableViewCell {
        return cell
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