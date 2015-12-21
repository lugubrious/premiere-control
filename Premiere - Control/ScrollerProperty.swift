//
//  ScrollerPropriety.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-07.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class ScrollerProperty: NSObject, Property {
    // MARK: Constants
    static let sortOrder = 50
    
    // MARK: Protocol Variables
    var parent: Fixture
    var value: PropertyType {
        didSet {
            switch value {
            case .Scroller(let val):
                if (0 <= val) && (val < locations) {
                    parent.update()
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
    
    private var unwrappedValue: Int? {
        switch value {
        case .Scroller(let val):
            return val
        default:
            return nil
        }
    }
    
    // MARK: Initilization
    required init (index: Int, parent: Fixture) {
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
            return [UInt8(ceil((Double(val)/100.0) * Double(maxValue)))]
        } else {
            return[0]
        }
    }
    
    func setUpTableCell(cell: UITableViewCell) -> UITableViewCell {
        return cell
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