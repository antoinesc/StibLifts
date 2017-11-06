//
//  FireBaseManager.swift
//  StibLifts
//
//  Created by antoine schmeits on 26/10/17.
//  Copyright © 2017 antoine schmeits. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import SwiftyJSON

class FireBaseManager: NSObject
{
    static let databaseRef = Database.database().reference()
    var currentUser: User? = nil
    
    //MARK:- "Singleton"
    static let shared = FireBaseManager()
    
    func login(email: String, password: String, completion: @escaping((_ succes: Bool) -> Void))
    {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error
            {
                print(error.localizedDescription)
                LogInViewController.fireBaseAuthError = error
                completion(false)
            }
                
            else
            {
                self.currentUser = user
                completion(true)
            }
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping((_ succes: Bool) -> Void))
    {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error
            {
                print(error.localizedDescription)
                LogInViewController.fireBaseAuthError = error
                completion(false)
                
            }
            else
            {
                self.currentUser = user
                self.currentUser?.sendEmailVerification(completion: nil)
                completion(true)
            }
        }
    }
    
    static func storeUserInDB(rootRefTable: DatabaseReference, appUser: AppUser)
    {
        let usersRefTable = rootRefTable.child("Users")
        let userRefTable = usersRefTable.child((appUser.userFireBase?.uid)!)
        userRefTable.child("Email").setValue(appUser.email)
        
        FireBaseManager.storeLocation(userRefTable: userRefTable, appUser: appUser)
        
    }
    
    // Méthode utiliser pour créer le user à partir de l'email et mdp (s'utilise que lors de la création de compte)
    func createAppUser(emailTextField: UITextField) -> AppUser?
    {
        var userApp: AppUser?
        let email = emailTextField.text ?? ""
        userApp = AppUser(email: email)
        
        return userApp
    }
    
    static func storeLocation(userRefTable: DatabaseReference, appUser: AppUser)
    {
        let userLatitudeRefTable = userRefTable.child("Latitude")
        let userLongitudeRefTable = userRefTable.child("Longitude")
        userLatitudeRefTable.setValue(appUser.location.latitude)
        userLongitudeRefTable.setValue(appUser.location.longitude)
    }
    

}
