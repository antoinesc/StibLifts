//
//  AppUser.swift
//  StibLifts
//
//  Created by antoine schmeits on 26/10/17.
//  Copyright © 2017 antoine schmeits. All rights reserved.
//
import Foundation
import FirebaseAuth
import FirebaseDatabase
import SwiftyJSON

class AppUser
{
    var email: String = ""
    var location: Location = Location()
    var userFireBase: User? = nil
    
    init()
    {}
    
    init?(fireBaseUser: User?)
    {
        if let fireBaseUserTest = fireBaseUser
        {
            self.email = (fireBaseUserTest.email)!
            self.userFireBase = fireBaseUser
        }
        else
        {
            return nil
        }
    }
    
    init(email: String)
    {
        self.email = email
    }
    
    // Cette méthode permet de récupérer les infos du user depuis FireBase
    func updateUserFromFirebase(fireBaseUser: User?, handler: @escaping (Bool) -> Void)
    {
        let usersRefTable = Database.database().reference().child("Users")
        let userRefTable = usersRefTable.child((fireBaseUser?.uid)!)
        userRefTable.observeSingleEvent(of:.value, with: { (snapshot) in
            if let value = snapshot.value
            {
                let response = true
                let json = JSON(value)
                print(json)
                guard let userEmail = json["Email"].string, let latitude = json["Latitude"].double, let longitude = json["Longitude"].double  else {return}
                self.email = userEmail
                self.location.latitude = latitude
                self.location.longitude = longitude
                
                
                DispatchQueue.main.async {
                    handler(response)
                }
            }
        })
    }
    
}
