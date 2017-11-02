//
//  Store.swift
//  StibLifts
//
//  Created by michael moldawski on 31/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation
import SwiftyJSON

class Station{
    
    var name: String = ""
    var location: Location = Location()
    var storeFireBase: String=""
    var ascenseur: Bool = true
    
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
    
    init (stationFireBaseKey: String)
    {
        self.storeFireBase = stationFireBaseKey
        self.name = self.storeFireBase // La clé correspond pour le moment au nom de la station dans la DB
    }
    
    func updateStationFromDBwithKey(storeFireBaseKey: String, completion: @escaping (_ success: Bool) -> Void)
    {
        let storeRefTable = FireBaseManager.databaseRef.child("Stations").child(storeFireBaseKey)
        storeRefTable.observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value
            {
                let json = JSON(value)
                print(json)
                guard let longitude = json["Longitude"].double, let latitude = json["Latitude"].double, let ascenseur = json["ascenseur"].bool else {return}
                self.location.longitude = longitude; self.location.latitude = latitude; self.ascenseur = ascenseur
                completion(true)
            }
        }
    }
    
}
