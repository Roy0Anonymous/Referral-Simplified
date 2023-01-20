//
//  CompanyPortalViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 04/01/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CompanyPortalViewController: UIViewController {

    @IBOutlet weak var codingProfileField: UITextView!
    @IBOutlet weak var githubIdField: UITextField!
    @IBOutlet weak var linkedinIdField: UITextField!
    @IBOutlet weak var referReasonField: UITextView!
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var companyLabel: UILabel!
    var currentCompany: String = ""
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentView.backgroundColor = UIColor(white: 0, alpha: 0)
        companyLabel.text = "\(currentCompany) Portal"
    }
    
    @IBAction func submit(_ sender: UIButton) {
        let userId = Auth.auth().currentUser?.uid
        guard let codingProfile = codingProfileField.text,
              let githubId = githubIdField.text,
              let linkedinId = linkedinIdField.text,
              let referReason = referReasonField.text,
              let userId = userId else {
            return
        }
        
//        db.collection("Referral Requests").document(currentCompany).setData([
//            "name" : professional.name!,
//            "email" : professional.email!,
//            "phone" : professional.phone!,
//            "DOB" : professional.dob!,
//            "Country" : professional.country!,
//            "City" : professional.city!,
//            "Gender" : professional.gender!,
//            "company" : professional.company!,
//            "position" : professional.phone!
//        ], merge: true)  { error in
//            if let safeError = error {
//                print(safeError)
//            } else {
//                self.performSegue(withIdentifier: "detailsToProfessionalMain", sender: self)
//            }
//        }
        
        db.collection(currentCompany).addDocument(data: [
            "UID" : userId,
            "Coding Profile" : codingProfile,
            "Github ID" : githubId,
            "Linkedin ID" : linkedinId,
            "Refer Reason" : referReason,
            "time" : Date().timeIntervalSince1970
        ]) { err in
            if let err = err {
                let alert = UIAlertController(title: "Error Submitting Document", message: "", preferredStyle: UIAlertController.Style.alert)
                self.present(alert, animated: true, completion: {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats:false, block: {_ in
                        self.dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
                    })
                })
                print("Error adding document: \(err)")
            } else {
                let alert = UIAlertController(title: "Your Request has been Submitted", message: "", preferredStyle: UIAlertController.Style.alert)
                self.present(alert, animated: true, completion: {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats:false, block: {_ in
                        self.dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
                    })
                })
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
