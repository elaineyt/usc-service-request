//
//  RegisterViewController.swift
//  ServiceRequest
//
//  Created by Akhil Arun on 11/16/19.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirm_pass: UITextField!
    
    @IBOutlet var name: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func register(_ sender: Any) {
        if password.text != confirm_pass.text {
            Util.alert(title: "Passwords must match", message: "Please re-type password", presenter: self)
            return
        }
        if name.text == "" {
            Util.alert(title: "Invalid name", message: "Please enter a display name", presenter: self)
            return
        }
        /*Auth.auth().createUser(withEmail: username.text!, password: password.text!){ (result, error) in
            if error == nil {
                var ref: DatabaseReference!
                print("adding item to db")
                ref = Database.database().reference()
                let user_id = Auth.auth().currentUser?.uid
                let display_name: String = self.name.text!
                ref.child("users").child(user_id!).updateChildValues(["name": display_name])
                Cloud.currentUser = User(id: user_id!, name: display_name, requestsPosted: nil, incomingOffers: nil, outgoingOffers: nil, chats: nil)
                self.performSegue(withIdentifier: "registered", sender: self)
            } else {
                Util.alert(title: "Error", message: error?.localizedDescription ?? "Signup failed.", presenter: self)
            }
        }*/
        Cloud.signup(username: name.text!, email: username.text!, password: password.text!) { error in
            if let e = error {
                Util.alert(title: "Error", message: e.localizedDescription ?? "Signup failed.", presenter: self)
            } else {
                self.performSegue(withIdentifier: "registered", sender: self)
            }
        }
    }
}
