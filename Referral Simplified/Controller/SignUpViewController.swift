//
//  ViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 30/12/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SignUPViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        phoneNumberField.delegate = self
        nameField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        nameField.becomeFirstResponder()
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let safeError = error {
                    print(safeError)
                } else {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "signUpToVerify", sender: self)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUpToVerify" {
            let vc = segue.destination as! EmailVerificationViewController
            vc.email = emailField.text
            if let name = nameField.text, let email = emailField.text, let phone = phoneNumberField.text {
                let currUser = UserDetails(name: name, email: email, phone: phone)
                vc.userDetails = currUser
            }
        }
    }
}

extension SignUPViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return true
    }
    func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
            case nameField:
                emailField.becomeFirstResponder()
            case emailField:
                passwordField.becomeFirstResponder()
            case passwordField:
                phoneNumberField.becomeFirstResponder()
            default: break
        }
    }
}
