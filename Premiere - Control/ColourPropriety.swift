//
//  ColourPropriety.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-07.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class ColourPropriety: Propriety {
    // MARK: Constants
    static let sortOrder = 60
    
    // MARK: Protocol Variables
    var parent: Fixture
    var value: ProprietyType {
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
        return Int(pow(2.0, Double(depth)))
    }
    var name: String
    
    // MARK: Other Variables
    enum ColourOutputMode {
        case CMY
        case RGB
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
        value = ProprietyType.Colour(UIColor.whiteColor())
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
                var colour = [UnsafeMutablePointer<CGFloat>](count: 3, repeatedValue: UnsafeMutablePointer<CGFloat>())
                val.getRed(colour[0], green: colour[1], blue: colour[2], alpha: nil);
                return [UInt8(colour[0].memory * CGFloat(maxValue)), UInt8(colour[1].memory * CGFloat(maxValue)), UInt8(colour[2].memory * CGFloat(maxValue))]
            case .CMY:
                var colour = [UnsafeMutablePointer<CGFloat>](count: 3, repeatedValue: UnsafeMutablePointer<CGFloat>())
                val.getHue(colour[0], saturation: colour[1], brightness: colour[2], alpha: nil);
                return [UInt8(colour[0].memory * CGFloat(maxValue)), UInt8(colour[1].memory * CGFloat(maxValue)), UInt8(colour[2].memory * CGFloat(maxValue))]
            }
        } else {
            return[0,0,0]
        }
    }
    
    func setUpTableCell(cell: UITableViewCell) -> UITableViewCell {
        return cell
    }
}