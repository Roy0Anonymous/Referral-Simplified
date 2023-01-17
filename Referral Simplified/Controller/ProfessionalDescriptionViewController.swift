//
//  ProfessionalDescriptionViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 31/12/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ProfessionalDescriptionViewController: UIViewController {
    @IBOutlet weak var positionField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    var professionalDetails: Professional = Professional(name: "", email: "", phone: "")
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
//        professionalDetails.isStudent = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if let company = companyField.text, let position = positionField.text {
            professionalDetails.company = company
            professionalDetails.position = position
            
            let newDocumentID = Auth.auth().currentUser?.uid
//            print(newDocumentID!)
            db.collection("Professionals").document(newDocumentID!).setData([
                "name" : professionalDetails.name,
                "email" : professionalDetails.email,
                "phone" : professionalDetails.phone,
                "company" : company,
                "position" : position
//                "isStudent" : professionalDetails.isStudent!
            ], merge: true)  { error in
                if let safeError = error {
                    print(safeError)
                } else {
                    self.performSegue(withIdentifier: "detailsToProfessionalMain", sender: self)
                }
            }
            
            var ref: DocumentReference? = nil
            ref = db.collection("CompanyList").addDocument(data: [
                "company" : company
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsToProfessionalMain" {
            let vc = segue.destination as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
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
