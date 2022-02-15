//
//  ViewController.swift
//  FlashChat
//
//  Created by Mustafa on 24.01.2022.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Bu alanda cocoapods kullanarak giriş ekranındaki title'ımızı hareketli bir şekilde gösteriyoruz kullanıcıya.
        titleLabel.text = K.appName
        
        
    }

}

