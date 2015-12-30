//
//  Submaster.swift
//  Premiere - Control
//
//  Created by Samuel Dewan on 2015-11-27.
//  Copyright © 2015 Samuel Dewan. All rights reserved.
//

import UIKit

class Submaster: NSObject {
    // MARK: Properties
    var values: [(fixture:Int, value:Double)]
    var index: Int
    
    var intensity: Double {
        didSet {
            for i in values {
                let fixtures = Data.getFixturesWithIndex(i.fixture)
                for f in fixtures {
                    f.getPropertyWithName("Intensity")?.value = PropertyType.Generic(i.value * self.intensity)
                }
            }
        }
    }
    var name: String
    
    init (index: Int, name: String? = nil) {
        self.values = [(fixture:Int, value:Double)]()
        self.index = index
        self.intensity = 0.0
        self.name = name ?? "Submaster \(index)"
        
        super.init()
    }
}
