//
//  SignInViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 30/12/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SignInViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerSignInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let myColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        emailField.delegate = self
        emailField.layer.cornerRadius = 15.0
        emailField.layer.borderWidth = 2.0
        emailField.backgroundColor = myColor
        emailField.clipsToBounds = true
        
        passwordField.delegate = self
        passwordField.layer.cornerRadius = 15.0
        passwordField.layer.borderWidth = 2.0
        passwordField.backgroundColor = myColor
        passwordField.clipsToBounds = true
        
        signInButton.layer.cornerRadius = 15.0
        signInButton.clipsToBounds = true
        
        registerSignInSegmentedControl.selectedSegmentIndex = 1
        
        navigationItem.hidesBackButton = true
    }
    
    
    @IBAction func didChangeValues(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let register = mainStoryboard.instantiateViewController(withIdentifier: "Register") as! UINavigationController
            register.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(register, animated: false)
            }
        }
    }
    

    @IBAction func signIn(_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let safeError = error {
                    print(safeError)
                } else {
                    self.db.collection("Students").getDocuments() { (querySnapshot, err) in
//                        print(Auth.auth().currentUser?.uid)
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print(document.documentID)
                                if (document.data()["email"] as! String) == Auth.auth().currentUser?.email && document.data()["isStudent"] as! Bool == true {
                                    self.performSegue(withIdentifier: "loginToStudentMain", sender: self)
                                    return
                                }
                            }
                            self.performSegue(withIdentifier: "loginToProfessionalMain", sender: self)
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToStudentMain" ||
            segue.identifier == "loginToProfessionalMain" {
            let vc = segue.destination as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
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
