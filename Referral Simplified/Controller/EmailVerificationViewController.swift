//
//  EmailVerificationViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 30/12/22.
//

import UIKit
import FirebaseAuth

class EmailVerificationViewController: UIViewController {
    var email: String?
    var userDetails: UserDetails = UserDetails(name: "", email: "", phone: "")
    @IBOutlet weak var messageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        messageLabel.text = "A Verification Email has been sent to your email \(self.email ?? "EMAIL_ID") and is valid for 05:00"
        
//        Auth.auth().currentUser?.sendEmailVerification { error in
//            if let safeError = error {
//                print(safeError)
//            } else {
//                var secondsRemaining = 300
//                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//                    if secondsRemaining > 0 && Auth.auth().currentUser?.isEmailVerified == false {
//                        Auth.auth().currentUser?.reload()
//                        let currTime = self.getTime(for: secondsRemaining)
//                        self.messageLabel.text = "A Verification Email has been sent to your email \(self.email ?? "EMAIL_ID") and is valid for \(String(format: "%02d", currTime[0])):\(String(format: "%02d", currTime[1]))"
//                        secondsRemaining -= 1
//                    } else if Auth.auth().currentUser?.isEmailVerified == true {
//                        timer.invalidate()
                        self.performSegue(withIdentifier: "verifyToSelector", sender: self)
//                    } else {
//                        let user = Auth.auth().currentUser
//                        user?.delete { error in
//                            if let safeError = error {
//                                print(safeError)
//                            } else {
//                                print("Email not verified")
//                                self.navigationController?.popViewController(animated: true)
//                            }
//                        }
//                        timer.invalidate()
//                    }
//                }
//            }
//        }
    }
    func getTime(for secondsRemaining: Int) -> [Int] {
        let minutes = secondsRemaining / 60
        let seconds = Int(round(((Float(secondsRemaining) / 60).truncatingRemainder(dividingBy: 1) * 60) * 100) / 100)
        return [minutes, seconds]
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verifyToSelector" {
            let vc = segue.destination as! StuProSelectionViewController
            vc.userDetails = userDetails
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
