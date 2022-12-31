//
//  SignInViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 30/12/22.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailField.becomeFirstResponder()
    }

    @IBAction func logIn(_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let safeError = error {
                    print(safeError)
                } else {
                    if Auth.auth().currentUser?.isEmailVerified == true {
                        print(Auth.auth().currentUser?.isEmailVerified as Any)
                        print("chu chu")
                    } else {
                        print("No chu chu")
                    }
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return true
    }
    
    func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
            case emailField:
                passwordField.becomeFirstResponder()
            default: break
        }
    }
}
