//
//  LoginController.swift
//  BuyGoggles
//
//  Created by Eddie Char on 1/18/21.
//

import UIKit

class LoginController: UIViewController {
    @IBAction func loginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "LoginSegue", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
