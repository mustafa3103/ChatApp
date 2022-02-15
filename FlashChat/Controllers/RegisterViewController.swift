//
//  RegisterViewController.swift
//  FlashChat
//
//  Created by Mustafa on 24.01.2022.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email =  emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
              // ...
                if let e = error {
                    //Show the error.
                    print("Error was occured while register to app. Error is: \(e.localizedDescription)")
                }else {
                    //Navigate to the ChatViewController.
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
    }
}
