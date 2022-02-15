//
//  LoginViewController.swift
//  FlashChat
//
//  Created by Mustafa on 24.01.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
 
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
              // ...
                if let e = error {
                    print("Error was occured while log in app. Error is: \(e.localizedDescription)")
                }else {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
}
