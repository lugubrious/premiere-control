//
//  Data.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-25.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import Foundation

struct Data {
    // MARK: Variables
    static var fixtures = [Fixture]()
    static var submasters = [Submaster]()
    static var cues = [Cue]()
    
    static var dmx = DMX()
    
    // MARK: Fixture functions
    static func getUnusedAddresses () -> [Int] {
        var addresses = [Int]()
        addresses += (1...1024)
        for i in Data.fixtures {
            if i.addressLength != 0 {
                var fixtureAddresses = [Int]()
                fixtureAddresses += ((i.address) ... (i.address + i.addressLength - 1))
                for j in fixtureAddresses {
                    if let address = addresses.indexOf(j) {
                        addresses.removeAtIndex(address)
                    }
                }
            }
        }
        return addresses
    }
    
    static func getFixturesWithIndex(index: Int) -> [Fixture] {
        var results = [Fixture]()
        for i in fixtures {
            if i.index == index {
                results.append(i)
            }
        }
        return results
    }
    
    static func saveFixures() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(fixtures, toFile:  Fixture.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("failed to save fixtures")
        }
    }
    
    static func loadFixtures() -> [Fixture]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Fixture.ArchiveURL.path!) as? [Fixture]
    }
    
    // MARK: Submaster functions
    
    // MARK: Cue functions
    
    
}