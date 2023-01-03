//
//  StudentMainViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 04/01/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class StudentMainViewController: UIViewController {
    let db = Firestore.firestore()
    var companies: [String] = []
    @IBOutlet weak var searchCompanies: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchCompanies.delegate = self
    }
    
    func loadCompanies() {
        db.collection("CompanyList").addSnapshotListener() { (querySnapshot, err) in
            self.companies = []
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.companies.append(document.data()["company"] as! String)
                }
                for company in self.companies {
                    print(company)
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

extension StudentMainViewController: UITextFieldDelegate {
    func autoCompleteText( in textField: UITextField, using string: String, suggestionsArray: [String]) -> Bool {
        if !string.isEmpty,
            let selectedTextRange = textField.selectedTextRange,
                selectedTextRange.end == textField.endOfDocument,
            let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),
            let text = textField.text( in : prefixRange) {
            let prefix = text + string
            let matches = suggestionsArray.filter {
                $0.hasPrefix(prefix)
            }
            if (matches.count > 0) {
                textField.text = matches[0]
                if let start = textField.position(from: textField.beginningOfDocument, offset: prefix.count) {
                    textField.selectedTextRange = textField.textRange(from: start, to: textField.endOfDocument)
                    return true
                }
            }
        }
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return !autoCompleteText( in : textField, using: string, suggestionsArray: companies)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
