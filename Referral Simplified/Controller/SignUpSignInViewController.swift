//
//  SignUpSignInViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 10/01/23.
//
import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SignUpSignInViewController: UIViewController {

    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollView1: UIScrollView!
    @IBOutlet weak var scrollView2: UIScrollView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailLoginField: UITextField!
    @IBOutlet weak var passwordLoginField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var isSignUp: Bool?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
            .foregroundColor : UIColor.gray
        ]
        
        nameField.delegate = self
        nameField.layer.cornerRadius = 10.0
        nameField.layer.borderWidth = 2.0
        nameField.backgroundColor = myColor
        nameField.clipsToBounds = true
        nameField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: attributes)
        
        emailField.delegate = self
        emailField.layer.cornerRadius = 10.0
        emailField.layer.borderWidth = 2.0
        emailField.backgroundColor = myColor
        emailField.clipsToBounds = true
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributes)
        
        phoneNumberField.delegate = self
        phoneNumberField.layer.cornerRadius = 10.0
        phoneNumberField.layer.borderWidth = 2.0
        phoneNumberField.backgroundColor = myColor
        phoneNumberField.clipsToBounds = true
        phoneNumberField.attributedPlaceholder = NSAttributedString(string: "Phone", attributes: attributes)
        
        passwordField.delegate = self
        passwordField.layer.cornerRadius = 10.0
        passwordField.layer.borderWidth = 2.0
        passwordField.backgroundColor = myColor
        passwordField.clipsToBounds = true
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributes)
        
        emailLoginField.delegate = self
        emailLoginField.layer.cornerRadius = 10.0
        emailLoginField.layer.borderWidth = 2.0
        emailLoginField.backgroundColor = myColor
        emailLoginField.clipsToBounds = true
        emailLoginField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributes)
        
        passwordLoginField.delegate = self
        passwordLoginField.layer.cornerRadius = 10.0
        passwordLoginField.layer.borderWidth = 2.0
        passwordLoginField.backgroundColor = myColor
        passwordLoginField.clipsToBounds = true
        passwordLoginField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributes)
        
        registerButton.layer.cornerRadius = 15.0
        registerButton.clipsToBounds = true
        
        signInButton.layer.cornerRadius = 15.0
        signInButton.clipsToBounds = true
        
        navigationItem.hidesBackButton = true

        if isSignUp! == true {
            scrollView2.isHidden = true
        } else {
            segmentedControl.selectedSegmentIndex = 1
            scrollView1.isHidden = true
        }
    }
    
    
    @IBAction func didChangeValue(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.transition(with: headingLabel, duration: 0.5, options: .transitionFlipFromTop) {
                self.headingLabel.text = "Welcome Guest!"
            } completion: { _ in }
            
            UIView.transition(with: subHeadingLabel, duration: 0.5, options: .transitionFlipFromTop) {
                self.subHeadingLabel.text = "Sign up now and unlock a world of opportunities!"
            } completion: { _ in }
            
            scrollView1.isHidden = false
            scrollView2.isHidden = true
        } else {
            UIView.transition(with: headingLabel, duration: 0.5, options: .transitionFlipFromTop) {
                self.headingLabel.text = "Hello Again!"
            } completion: { _ in }
            
            UIView.transition(with: subHeadingLabel, duration: 0.5, options: .transitionFlipFromTop) {
                self.subHeadingLabel.text = "Welcome back you've been missed!"
            } completion: { _ in }
            
            scrollView1.isHidden = true
            scrollView2.isHidden = false
        }
    }
    
    
    @IBAction func register(_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text, let name = nameField.text, let phone = phoneNumberField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let safeError = error {
                    print(safeError)
                } else {
                    userDetails = UserDetails(name: name, email: email, phone: phone)
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "signUpToVerify", sender: self)
                    }
                }
            }
        }
    }
    
    
    @IBAction func signIn(_ sender: UIButton) {
        if let email = emailLoginField.text, let password = passwordLoginField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let safeError = error {
                    print(safeError)
                } else {
                    self.db.collection("Students").getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print(document.documentID)
                                if (document.data()["email"] as! String) == Auth.auth().currentUser?.email {
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //////////////////////////////
//        if segue.identifier == "signUpToVerify" {
//            let vc = segue.destination as! EmailVerificationViewController
//            vc.email = emailField.text
//            if let name = nameField.text, let email = emailField.text, let phone = phoneNumberField.text {
//                let currUser = UserDetails(name: name, email: email, phone: phone)
//                vc.userDetails = currUser
//            }
        ////////////////////////
//        if segue.identifier == "loginToStudentMain" ||
//                    segue.identifier == "loginToProfessionalMain" {
//            let vc = segue.destination as! UINavigationController
//            vc.modalPresentationStyle = .fullScreen
//        }
//    }
}

extension SignUpSignInViewController: UITextFieldDelegate {
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
        case emailLoginField:
            passwordLoginField.becomeFirstResponder()
        default: break
        }
    }
}
