//
//  EmailVerificationViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 30/12/22.
//

import UIKit
import FirebaseAuth

class EmailVerificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Auth.auth().currentUser?.sendEmailVerification { error in
            if let safeError = error {
                print(safeError)
            } else {
                print("Hello")
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
