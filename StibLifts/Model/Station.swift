//
//  Store.swift
//  StibLifts
//
//  Created by michael moldawski on 31/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation

class Store{
    
    var name: String = ""
    var location: Location = Location()
    
    init(){}
    
    init(name: String)
    {
        self.name = name
    }
    
    
    init (name: String, location: Location )
    {
        self.name = name
        self.location = location
    }
}
