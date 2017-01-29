//
//  LogInViewController.swift
//  ChatDemo
//
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    @IBOutlet weak var mailAddressText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onTouchedSignUpButton(_ sender: Any) {
        if let email = mailAddressText.text, let password = passwordText.text {
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { [weak self] (user, error) in
                self?.validateAuthenticationResult(user, error: error)
            }
        }
    }
    @IBAction func onTouchedLogInButton(_ sender: Any) {
        if let email = mailAddressText.text, let password = passwordText.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { [weak self] (user, error) in
                self?.validateAuthenticationResult(user, error: error)
            }
        }
    }

    private func validateAuthenticationResult(_ user: FIRUser?, error: Error?) {
        if let error = error{
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "talkSegue", sender: self)
        }
    }
}
