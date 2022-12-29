//
//  ViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 30/12/22.
//

import UIKit

class SignUPViewController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        phoneNumberField.delegate = self
        lastNameField.delegate = self
        firstNameField.delegate = self
        firstNameField.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        
    }
    
}

extension SignUPViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return true
    }
    func switchBasedNextTextField(_ textField: UITextField) {
            switch textField {
            case firstNameField:
                lastNameField.becomeFirstResponder()
            case lastNameField:
                emailField.becomeFirstResponder()
            case emailField:
                phoneNumberField.becomeFirstResponder()
            default: break
            }
        }
}
