//
//  ProfessionalDetailsViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 30/12/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SignUpLogInViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bottomView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        bottomView.layer.cornerRadius = bottomView.frame.height / 5
        
        signInButton.backgroundColor = .clear
        signInButton.layer.cornerRadius = 5
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor.systemBlue.cgColor
        
//        let currentUser = Auth.auth().currentUser
//
//        if currentUser != nil {
////            print(Auth.auth().currentUser?.email)
//
//            var docRef = db.collection("Students").document(currentUser!.uid)
//            docRef.getDocument { (document, error) in
//                if let document = document, document.exists {
//                    self.performSegue(withIdentifier: "homeToStudentMain", sender: self)
//                    return
//                }
//            }
//            docRef = db.collection("Professionals").document(currentUser!.uid)
//            docRef.getDocument { (document, error) in
//                if let document = document, document.exists {
//                    self.performSegue(withIdentifier: "homeToProfessionalMain", sender: self)
//                    return
//                }
//            }
//        }
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
