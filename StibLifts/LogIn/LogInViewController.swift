//
//  FireBaseManager.swift
//  StibLifts
//
//  Created by michael moldawski on 26/10/17.
//  Copyright © 2017 anthoine schmets. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    
    let defaults = UserDefaults.standard
    static var fireBaseAuthError: Error?
    var alertVC: UIAlertController?
    
    
    
    @IBAction func createUser(_ sender: UIButton) {
        guard let email = mailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        FireBaseManager.shared.createUser(email: email, password: password)
        { (success) in
            
            if (success)
            {
//                FireBaseManager.storeUserInDB(appUser: self.user!)
            }
            else
            {
                guard let errorToDisplay = LogInViewController.fireBaseAuthError else{return}
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logInButton.layer.cornerRadius = 15
        self.createAccountButton.layer.cornerRadius = 15
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

