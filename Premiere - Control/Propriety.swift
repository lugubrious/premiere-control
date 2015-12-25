//
//  Propriety.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-03.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

protocol Property: NSCopying, NSCoding {
    // The weight of this property when displayed in a table view. Higher numbers are displayed first.
    var sortOrder: Int {get}
    
    // The fixture that this property belogns to
    var parent: Fixture? {get set}
    // The value of this propriety
    var value: PropertyType {get set}
    // The order of this property in the DMX packet (unlike sortOrder this should be an absolute value, nto a weigth)
    var index: Int {get set}
    // How many bits this property has (must be a multiple of 8, since DMX channels are 8 bits)
    var depth: Int {get set}
    // The maximum DMX value this propriety can have (2^depth)
    var maxValue: Int {get}
    // The name that this property should display
    var name: String {get set}
    
    // Returns the DMX values for this property
    func getDMXValues() -> [UInt8]
    func setUpTableCell(cell: UITableViewCell) -> UITableViewCell
    
    // A generic initilaiser
    init(index: Int, parent: Fixture?)
}

// The possible storage types for the value paramater
enum PropertyType {
    case Generic(Double)
    case Colour(UIColor)
    case Scroller(Int)
    case Position(Int,Int)
}