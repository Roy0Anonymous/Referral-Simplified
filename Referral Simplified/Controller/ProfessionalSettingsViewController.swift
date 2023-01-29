//
//  ProfessionalSettingsViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 20/01/23.
//

import UIKit
import FirebaseAuth
import ZIMKit

class ProfessionalSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            ZIMKitManager.shared.disconnectUser()
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homePage = mainStoryboard.instantiateViewController(withIdentifier: "InitialNavController") as! UINavigationController
            homePage.modalPresentationStyle = .fullScreen
            present(homePage, animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
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
