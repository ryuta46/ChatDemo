//
//  TalkViewController.swift
//  ChatDemo
//
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import UIKit
import FirebaseDatabase

import FirebaseMessaging

class TalkViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var talkText: UITextView!
    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    var database: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        database = Database.database().reference()

        database.observe(.childAdded, with: { [weak self] snapshot in 
            if let chunk = snapshot.value as? Dictionary<String, AnyObject> {
                if let name = chunk["name"], let message = chunk["message"] {
                    self?.talkText.text.append("\(name): \(message)\n")
                    return
                }
            }
            print("Data format is invalid.")
        })

        Messaging.messaging().subscribe(toTopic: "/topics/test")

        nameText.delegate = self
        messageText.delegate = self

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onPressedSendButton(_ sender: Any) {
        guard let name = nameText.text, let message = messageText.text else {
            fatalError("no name or message")
        }

        let chunk = ["name": name, "message": message]
        database.childByAutoId().setValue(chunk)

        talkText.resignFirstResponder()
        messageText.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
}
