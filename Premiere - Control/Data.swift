//
//  Data.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-12-25.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import Foundation

/// A place for all of the global data to be stored
struct Data {
    // MARK: Variables
    static var fixtures = [Fixture]()
    static var submasters = [Submaster]()
    static var cues = [Cue]()
    
    static var dmx = DMX()
    
    // MARK: Fixture functions
    
    /**
    * Find DMX addreses for wich there is no currently assigned fixture
    * - returns: A list of addresses which are safe to assign to fixtures
    */
    static func getUnusedAddresses () -> [Int] {
        var addresses = [Int]()
        addresses += (1...1024) // get a list of all the possible dimmers
        for i in Data.fixtures {
            if i.addressLength != 0 {
                // Finds the addresses used by fixture i, then removes all of them from the list of avalaiable addresses
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
    
    /**
     * Returns any fixtures with a given index
     * - parameter index: The index which the caller is looking for
     * - returns: All fixtures with the specified index
     */
    static func getFixturesWithIndex(index: Int) -> [Fixture] {
        var results = [Fixture]()
        for i in fixtures {
            if i.index == index {
                results.append(i)
            }
        }
        return results
    }
    
    /// Saves all fixtures to a plist file in the app sandbox
    static func saveFixures() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(fixtures, toFile:  Fixture.ArchiveURL.path!)
        if !isSuccessfulSave {
            // TODO: Actual error handling here
            print("failed to save fixtures")
        }
    }
    
    /**
     * Gets fixtures from the saved file
     * - returns: All of the fixtures stored in the fixtures file
     */
    static func loadFixtures() -> [Fixture]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Fixture.ArchiveURL.path!) as? [Fixture]
    }
    
    // MARK: Submaster functions
    
    // MARK: Cue functions
    
    // MARL: Other functions
    
    ///Saves all data (fixtures, submasters and cues)
    static func saveAll () {
        Data.saveFixures()
        // TODO: Ad fixtures and cues here once they are implemented
    }
}