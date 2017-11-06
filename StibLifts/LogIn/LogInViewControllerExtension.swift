//
//  LogInViewController.swift
//  StibLifts
//
//  Created by antoine schmeits on 26/10/17.
//  Copyright © 2017 antoine schmeits. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
extension LogInViewController
{
    func showAlerteVC (title: String, message: String, alertAction1: UIAlertAction, alertAction2: UIAlertAction?)
    {
        self.alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        if let alertActionTest = alertAction2
        {
            self.alertVC?.addAction(alertAction1)
            self.alertVC?.addAction(alertActionTest)
        }
            
        else
        {
            self.alertVC?.addAction(alertAction1)
        }
        
        self.present(self.alertVC!, animated: true, completion: nil)
    }
    
    func showAlerteVCMailNotVerified ()
    {
        
        self.showAlerteVC(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \((FireBaseManager.shared.currentUser?.email)!)?", alertAction1: self.alertActionYes!, alertAction2: self.alertActionNo!)
    }
    
    func initAlertActions()
    {
        self.alertActionOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {
            (_) in
            self.alertVC?.dismiss(animated: true, completion: nil)
        }
        self.alertActionYes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        {
            (_) in
            FireBaseManager.shared.currentUser?.sendEmailVerification(completion: nil)
            
            self.alertVC?.dismiss(animated: true, completion: nil)
            
            let alertExplanationVC = UIAlertController(title: "To Do", message: "Please sign out and come back after validated your email adress by following instruction sent to you by email.", preferredStyle: UIAlertControllerStyle.alert)
            let alertActionOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
            { (_) in
                self.alertVC?.dismiss(animated: true, completion: nil)
            }
            
            alertExplanationVC.addAction(alertActionOk)
            self.present(alertExplanationVC, animated: true, completion: nil)
        }
        self.alertActionNo = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            (_) in
            
            self.alertVC?.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    func logIn()
    {
        guard let email = mailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        if password == ""
        {
            self.showAlerteVC(title: "Login", message: "The Password is empty", alertAction1: self.alertActionOk!, alertAction2: nil)
        }
        else
        {
            FireBaseManager.shared.login(email: email, password: password) { (success: Bool) in
                if (success)
                {
                    self.loginActivityIndicator.startAnimating()
                    self.logInButton.isEnabled = false
                    self.user = AppUser(fireBaseUser: FireBaseManager.shared.currentUser!)
                    self.user?.updateUserFromFirebase(fireBaseUser: FireBaseManager.shared.currentUser!, handler: { response in
                        if (self.user?.userFireBase?.isEmailVerified)!
                        {
                            self.loginActivityIndicator.stopAnimating()
                            self.logInButton.isEnabled = response
                            //                        self.moveForward()
                        }
                    })
                    self.defaults.set(self.user?.email, forKey: "email")
                    self.mailTextField.isUserInteractionEnabled = false
                    self.mailTextField.backgroundColor = UIColor.darkGray
                    self.passwordTextField.isUserInteractionEnabled = false
                    self.passwordTextField.backgroundColor = UIColor.darkGray
                    
                    self.logInButton.setTitle("Continue", for: UIControlState.normal)
                    self.createAccountButton.setTitle("Sign out", for: UIControlState.normal)
                    if !(self.user?.userFireBase?.isEmailVerified)!
                    {
                        self.showAlerteVCMailNotVerified()
                        self.logInButton.isEnabled = false
                        self.logInButton.backgroundColor = UIColor.darkGray
                    }
                    
                }
            }
        }
    }
    
    func createUser()
    {
        guard let email = mailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        FireBaseManager.shared.createUser(email: email, password: password)
        { (success) in
            
            if (success)
            {
                self.user = FireBaseManager.shared.createAppUser(emailTextField: self.mailTextField)
                self.user?.userFireBase = FireBaseManager.shared.currentUser
                FireBaseManager.storeUserInDB(rootRefTable: FireBaseManager.databaseRef, appUser: self.user!)
                self.showAlerteVC(title: "User creation", message: "A verifying email has been sent to \(email). Please go to your mail to verify your adress before sign in)", alertAction1: self.alertActionOk!, alertAction2: nil)
            }
            else
            {
                guard let errorToDisplay = LogInViewController.fireBaseAuthError else{return}
                self.showAlerteVC(title: "User creation", message: "\(errorToDisplay.localizedDescription)", alertAction1: self.alertActionOk!, alertAction2: nil)
            }
            
        }
    }
    
    func moveForward()
    {
        if (user?.userFireBase?.isEmailVerified)!
        {
          self.performSegue(withIdentifier: "tabBarRootSegue", sender: nil)
        }
    }
    
    func signOut()
    {
        try! Auth.auth().signOut()
        let currentUSer = Auth.auth().currentUser
        self.user = AppUser(fireBaseUser: currentUSer )
        passwordTextField.text = ""
        
        self.mailTextField.isUserInteractionEnabled = true
        self.mailTextField.backgroundColor = UIColor.white
        
        self.passwordTextField.isUserInteractionEnabled = true
        self.passwordTextField.backgroundColor = UIColor.white
        
        self.logInButton.setTitle("Sign in", for: UIControlState.normal)
        self.logInButton.isEnabled = true
        self.logInButton.backgroundColor = UIColor.white
        
        self.createAccountButton.setTitle("Create account", for: UIControlState.normal)
    }
    
}
