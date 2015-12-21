//
//  GenericPropriety.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-07.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class GenericPropriety: NSObject, Propriety {
    // MARK: Constants
    static let sortOrder = 30
    
    // MARK: Protocol Variables
    var parent: Fixture
    var value: ProprietyType {
        didSet {
            switch value {
            case .Generic:
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
    private var unwrappedValue: Double? {
        switch value {
        case .Generic(let val):
            return val
        default:
            return nil
        }
    }
    
    // MARK: Initilization
    convenience init? (index: Int, parent: Fixture, name: String, initialValue: ProprietyType, depth: Int) {
        self.init(index: index, parent: parent)
        self.value = initialValue
        if !name.isEmpty {
            self.name = name
        } else {
            return nil
        }
        self.depth = depth
    }
    
    required init (index: Int, parent: Fixture) {
        value = ProprietyType.Generic(0.0)
        self.index = index
        self.parent = parent
        self.depth = 8
        self.name = "Propriety"
    }
    
    // MARK: Protocol Functions
    func getDMXValues() -> [UInt8] {
        if let val = unwrappedValue {
            return [UInt8(val * Double(maxValue))]
        } else {
            return [0]
        }
    }
    
    func setUpTableCell(cell: UITableViewCell) -> UITableViewCell {
        return cell
    }
    
    // MARK: Copying
    
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return GenericPropriety(index: self.index, parent: self.parent, name: self.name, initialValue: self.value, depth: self.depth)!
    }
}