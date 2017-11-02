//
//  MapViewControllerExtension.swift
//  StibLifts
//
//  Created by michael moldawski on 31/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//
import CoreLocation
import Foundation
import MapKit
import FirebaseDatabase
import FirebaseAuth
import SwiftyJSON
extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate
{
    //MARK:- CLLocationManagerDelegate
    // Cette fonction est appellé à chaque fois que le user se déplace
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
        self.user?.location.latitude = myLocation.latitude
        self.user?.location.longitude = myLocation.longitude
        
        print("latitude: \(myLocation.latitude) longitude: \(myLocation.longitude)")
        FireBaseManager.storeLocation(userRefTable: self.userRefTable!, appUser: self.user!)
        locationManager.stopUpdatingLocation()
        self.getStations()
    }
    
    //MARK:- MKMapViewDelegate
    
    // Cette fonction transforme une annotation en type MKmaps qui ouvre la navigation dans maps
    func mapItem(myAnnotation: MKAnnotationView) -> MKMapItem {
        let latitude = myAnnotation.annotation?.coordinate.latitude
        let longitude = myAnnotation.annotation?.coordinate.longitude
        
        
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = myAnnotation.annotation?.title!
        
        return mapItem
        
    }
    
    // Cette fonction permet de créer une fenêtre d'information lorsqu'on clique sur une annotation point, et sauve l'information dans "annotationForAuxiliaryView"
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.annotationForAuxiliaryView = view
        self.auxiliaryView.isHidden = false
        
        if let test = view.annotation as? MyPointAnnotation
        {
            self.stationNameAuxiliaryViewLabel.text = test.station.name
            self.elevatorStatusAuxiliaryViewLabel.text = test.station.ascenseur.description
        }
        else
        {
            self.stationNameAuxiliaryViewLabel.text = "my location"
            self.elevatorStatusAuxiliaryViewLabel.text = ""
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation") as? MKPinAnnotationView
        if annotationView == nil
        {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
        }
        else
        {
            annotationView?.annotation = annotation
        }
        
        if let annotation = annotation as? MyPointAnnotation
        {
            annotationView?.pinTintColor = annotation.pinTintColor
        }
        annotationView?.canShowCallout = true
        return annotationView
    }
    
    // cette fonction recupère au démarage la liste de toutes les stations de métro
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
                            self.stationAnnotation(station: stationTemp)
                        }
                        
                    })
                }
                print(self.stations)
                
            }
            
        })
    }
    
    func stationAnnotation(station: Station?)
    {
        let annotation = MyPointAnnotation()
        annotation.station = station!
        annotation.coordinate = CLLocationCoordinate2D(latitude: (station?.location.latitude)!, longitude: (station?.location.longitude)!)
        annotation.title = station?.name
        annotation.subtitle = station?.ascenseur.description
        
        if annotation.subtitle == "true"
        {
            annotation.pinTintColor = UIColor.green
        }
        else
        {
            annotation.pinTintColor = UIColor.red
        }
        
        map.addAnnotation(annotation)
        self.keepStationsTracking()
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
                        }
                        self.updateStationOnMap()
                    })
                    
                }
                
            })
            
        }
    
    
    func updateStationOnMap()
    {
        let annotations = self.map.annotations
        self.map.removeAnnotations(annotations)
        for station in self.stations
        {
            self.stationAnnotation(station: station)
        }
    }
    
}
