//
//  MapViewController.swift
//  StibLifts
//
//  Created by michael moldawski on 31/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import FirebaseAuth
import SwiftyJSON
import UIKit

class MapViewController: UIViewController {
    

    var stations = [Station]()
    var annotationForAuxiliaryView: MKAnnotationView?
    let locationManager = CLLocationManager()
    var dbRef = FireBaseManager.databaseRef
    var user: AppUser? = nil
    var usersRefTable: DatabaseReference? = nil
    var userRefTable: DatabaseReference? = nil
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var auxiliaryView: UIView!
    @IBOutlet weak var stationNameAuxiliaryViewLabel: UILabel!
    @IBOutlet weak var elevatorStatusAuxiliaryViewLabel: UILabel!

    
    
    @IBAction func goToMaps(_ sender: Any) {
        self.mapItem(myAnnotation: self.annotationForAuxiliaryView!).openInMaps(launchOptions: nil)
    }
    @IBAction func closeAuxiliaryView(_ sender: Any) {
        self.auxiliaryView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        self.map.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.usersRefTable = dbRef.child("Users")
        self.user = AppUser(fireBaseUser: FireBaseManager.shared.currentUser!)
        self.annotationForAuxiliaryView = MKAnnotationView()
        self.getStations()//à enlever
   

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.user?.updateUserFromFirebase(fireBaseUser: FireBaseManager.shared.currentUser!, handler: { response in
            if (response)
            {
                self.userRefTable = self.usersRefTable?.child((self.user?.userFireBase?.uid)!)
                self.locationManager.startUpdatingLocation()
            }
        })
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

class MyPointAnnotation : MKPointAnnotation
{
    var station = Station()
    var pinTintColor: UIColor?
}
