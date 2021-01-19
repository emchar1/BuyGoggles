//
//  LoginController.swift
//  BuyGoggles
//
//  Created by Eddie Char on 1/18/21.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginErrorLabel.alpha = 0
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        guard let email = emailField.text,
              let password = passwordField.text else {

            //Should not happen, but we'll see...
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            guard error == nil else {
                self.loginErrorLabel.alpha = 1
                UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseIn, animations: {
                    self.loginErrorLabel.alpha = 0
                }, completion: nil)

                print(error!.localizedDescription)

                return
            }
                        
            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
        }
    }

    
}
