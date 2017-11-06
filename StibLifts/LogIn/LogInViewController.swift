//
//  FireBaseManager.swift
//  StibLifts
//
//  Created by antoine schmeits on 26/10/17.
//  Copyright © 2017 antoine schmeits. All rights reserved.
//

import UIKit
import CoreLocation

class LogInViewController: UIViewController {
    
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    
    let defaults = UserDefaults.standard
    static var fireBaseAuthError: Error?
    var alertVC: UIAlertController?
    
    var user: AppUser? = nil
    let locationManager = CLLocationManager()
    
    
    //MARK:- AlertActions
    var alertActionOk: UIAlertAction?
    var alertActionYes: UIAlertAction?
    var alertActionNo: UIAlertAction?
    var alertActionOkSpecial: UIAlertAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logInButton.layer.cornerRadius = 15
        self.createAccountButton.layer.cornerRadius = 15
        self.initAlertActions()
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func myUnwindLoginForm (unwindSegue: UIStoryboardSegue){
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else{return}
        switch title
        {
        case "Sign In":
            logIn()
        case "Create user":
            createUser()
        case "Continue":
            moveForward()
        case "Sign out":
            signOut()
        default:
            print("default")
        }
    }
}

