//
//  Location.swift
//  StibLifts
//
//  Created by michael moldawski on 26/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation
struct Location
{
    var latitude: Double = 0
    var longitude: Double = 0
    
    init()
    {}
    
    init (latitude: Double, longitude: Double)
    {
        self.latitude = latitude
        self.longitude = longitude
    }
}
