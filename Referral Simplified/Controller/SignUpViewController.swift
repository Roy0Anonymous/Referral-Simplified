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

class SignUpViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        nameField.delegate = self
        nameField.layer.cornerRadius = 10.0
        nameField.layer.borderWidth = 2.0
//        nameField.layer.borderColor = myColor.cgColor
        nameField.backgroundColor = myColor
        nameField.clipsToBounds = true
        
        emailField.delegate = self
        emailField.layer.cornerRadius = 10.0
        emailField.layer.borderWidth = 2.0
        emailField.backgroundColor = myColor
        emailField.clipsToBounds = true
        
        phoneNumberField.delegate = self
        phoneNumberField.layer.cornerRadius = 10.0
        phoneNumberField.layer.borderWidth = 2.0
        phoneNumberField.backgroundColor = myColor
        phoneNumberField.clipsToBounds = true
        
        passwordField.layer.cornerRadius = 10.0
        passwordField.layer.borderWidth = 2.0
        passwordField.backgroundColor = myColor
        passwordField.clipsToBounds = true
        
        registerButton.layer.cornerRadius = 15.0
        registerButton.clipsToBounds = true
        
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didChangeValue(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let signIn = mainStoryboard.instantiateViewController(withIdentifier: "SignIn") as! UINavigationController
            signIn.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(signIn, animated: false)
            }
        }
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

extension SignUpViewController: UITextFieldDelegate {
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
