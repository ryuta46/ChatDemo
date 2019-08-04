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
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
                self?.validateAuthenticationResult(authResult, error: error)
            }
        }
    }
    @IBAction func onTouchedLogInButton(_ sender: Any) {
        if let email = mailAddressText.text, let password = passwordText.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
                _ = self?.validateAuthenticationResult(authResult, error: error)
            }
        }
    }

    private func validateAuthenticationResult(_ authResult: AuthDataResult?, error: Error?) {
        if let error = error{
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "talkSegue", sender: self)
        }
    }
}
