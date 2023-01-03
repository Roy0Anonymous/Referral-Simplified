//
//  ProfessionalDescriptionViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 31/12/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class ProfessionalDescriptionViewController: UIViewController {
    @IBOutlet weak var positionField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    var professionalDetails: Professional = Professional(name: "", email: "", phone: "")
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        professionalDetails.isStudent = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if let company = companyField.text, let position = positionField.text {
            professionalDetails.company = company
            professionalDetails.position = position
            
            var ref: DocumentReference? = nil
            ref = db.collection("Professionals").addDocument(data: [
                "name" : professionalDetails.name,
                "email" : professionalDetails.email,
                "phone" : professionalDetails.phone,
                "company" : company,
                "position" : position,
                "isStudent" : professionalDetails.isStudent!
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
            
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
