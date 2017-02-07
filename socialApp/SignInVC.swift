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

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    
    
    
    
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
            }
        })
    }
    
    @IBAction func signInTapped(_ sender: FancyBtn) {
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("BERNARD: Email user authenticated with firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Bernard: Unable to authenticate with firebase using email")
                        } else {
                            print("Bernard: Successfully authenticated with firebase")
                        }
                    })
                }
            })
        }
    }


        }
    
    
    
    


