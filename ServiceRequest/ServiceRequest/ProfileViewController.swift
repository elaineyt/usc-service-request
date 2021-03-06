//
//  ProfileViewController.swift
//  ServiceRequest
//
//  Created by Satoshi Nakamura on 11/24/19.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet var username: UITextView!
    @IBOutlet var edit_or_finish: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    
    var beforeEdit = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // if the user is not logged in, then
        if Cloud.currentUser == nil{
            self.presentLoginPage()
            return
        }
        
        // set USERNAME to loggedin user name
        let name = Cloud.currentUser?.name;
        username.text = name
        cancelBtn.isHidden = true
    }
    
    func presentLoginPage(){
        self.dismiss(animated: true, completion: nil)
        
    }

    // If its in editing, then finish editing
    @IBAction func editOrFinishEditingUsername(_ sender: UIButton) {
        if (edit_or_finish.titleLabel?.text == "Edit") {
            username.isEditable = true
            edit_or_finish.setTitle("Finish",for: .normal)
            edit_or_finish.titleLabel?.text = "Finish"
            beforeEdit = username.text
            cancelBtn.isHidden = false
            
            username.becomeFirstResponder()
        }else {
            // Finished editing username
            username.isEditable = false
            edit_or_finish.setTitle("Edit",for: .normal)
            cancelBtn.isHidden = true
            
            if username.text != beforeEdit {
                Cloud.changeUsername(newName: username.text)
            }
            
        }
    }

    
    @IBAction func logout(_ sender: UIButton) {
        Cloud.logout()
        // pull up login page
        self.presentLoginPage()
    }
    
    @IBAction func cancelEditing(_ sender: UIButton){
        cancelBtn.isHidden = true
        
        username.text = beforeEdit
        username.isEditable = false
        edit_or_finish.setTitle("Edit",for: .normal)
    }

}
