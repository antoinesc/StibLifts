//
//  ListStationsViewControllerExtension.swift
//  StibLifts
//
//  Created by michael moldawski on 1/11/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import SwiftyJSON

extension ListStationsViewController: UITableViewDataSource, UITableViewDelegate
{
    
    //Mark : - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     //La méthode ci-dessous est utilisée par la méthode suivante
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stations.count
    }

    //La méthode ci-dessous est utiliser pour implémenter, et mettre à jours, la table view avec le tableau de data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCellId", for: indexPath) as! StationTableViewCell
        
        cell.station = stations[indexPath.row]
        return cell
    }
    
    func getStations()
    {
        FireBaseManager.databaseRef.child("Stations").observe(DataEventType.value, with: { snapshot in
            
            if let value = snapshot.value
            {
                let json = JSON(value)
                print(json)
                for (key,_) in json
                {
                    let stationTemp: Station = Station(stationFireBaseKey: key)
                    stationTemp.updateStationFromDBwithKey(storeFireBaseKey: key, completion: { (success: Bool) in
                        if (success)
                        {
                            self.stations.append(stationTemp)
                            self.tableView.reloadData()
                        }
                    })
                }
                self.keepStationsTracking()
                print(self.stations)
                
            }
        })
    }
    
    func keepStationsTracking()
    {
        
        FireBaseManager.databaseRef.child("Stations").observe(DataEventType.childChanged, with: { snapshot in
            
            if let value = snapshot.value
            {
                let json = JSON(value)
                print(json)
                let key = snapshot.key
                let newTempStation = Station(stationFireBaseKey: key)
                newTempStation.updateStationFromDBwithKey(storeFireBaseKey: key, completion: {(success: Bool) in
                    if (success)
                    {
                        
                        var i = 0
                        for station in self.stations
                        {
                            if newTempStation.name == station.name
                            {
                                self.stations[i] = newTempStation
                            }
                            i += 1
                        }
                        i = 0
                        self.tableView.reloadData()
                    }
                })
                
            }
            
        })
    }
    
    //Mark : - TableViewDelegate
    // la fonction ci-dessous permet de redimensionner la hauteur des cellules
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
