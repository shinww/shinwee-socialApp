//
//  ViewController.swift
//  socialApp
//
//  Created by shinwee on 1/21/17.
//  Copyright © 2017 shinwee. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
            print("BERNARD: ID found in keychain")
        }

    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookBtnTapped(_ sender: RoundBtn) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Bernard: Unable to authenticate with facebook - \(error)")
            } else if result?.isCancelled == true {
                print("Bernard: User canceled facebook authentication")
            } else {
                print("Bernard: Successful authenticated with facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Bernard: Unable to authentication with firebase - \(error)")
            } else {
                print("Bernard: Success authenticated with firebase")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }

                
            }
        })
    }

    
    @IBAction func signInTapped(_ sender: FancyBtn) {
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("BERNARD: Email user authenticated with firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }

                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Bernard: Unable to authenticate with firebase using email")
                        } else {
                            print("Bernard: Successfully authenticated with firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    func completeSignIn(id: String, userData: Dictionary<String,String>) {
            DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
            let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
            print("BERNARD: Data saved to keychain \(keychainResult)")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        
    
       }

}


    




