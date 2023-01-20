//
//  StudentMainViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 04/01/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import iOSDropDown

class StudentMainViewController: UIViewController {
    @IBOutlet weak var refererNotAvailable: UILabel!
    let db = Firestore.firestore()
    var companies: [String] = []
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchCompanies: DropDown!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let myColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
            .foregroundColor : UIColor.gray
        ]
        
        searchCompanies.layer.cornerRadius = 10.0
        searchCompanies.layer.borderWidth = 2.0
        searchCompanies.backgroundColor = myColor
        searchCompanies.clipsToBounds = true
        searchCompanies.attributedPlaceholder = NSAttributedString(string: "Get Your Referral", attributes: attributes)
        
        searchButton.layer.cornerRadius = 15.0
        searchButton.clipsToBounds = true
        
        navigationItem.hidesBackButton = true
        searchCompanies.delegate = self
        refererNotAvailable.isHidden = true
        loadCompanies()
    }
    
    func loadCompanies() {
        db.collection("CompanyList").addSnapshotListener() { (querySnapshot, err) in
            self.companies = []
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.companies.append(document.data()["company"] as! String)
                    self.searchCompanies.optionArray = self.companies
                }
                for company in self.companies {
                    print(company)
                }
            }
        }
    }

    @IBAction func submit(_ sender: UIButton) {
        if let company = searchCompanies.text {
            if companies.contains(company) {
                performSegue(withIdentifier: "searchToSendRequest", sender: self)
            } else {
                refererNotAvailable.isHidden = false
                if company != "" {
                    refererNotAvailable.text = "No Referer found for " + company
                } else {
                    refererNotAvailable.text = "Enter a Company Name"
                }
            }
        }
    }

    @IBAction func logOut(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homePage = mainStoryboard.instantiateViewController(withIdentifier: "InitialNavController") as! UINavigationController
            homePage.modalPresentationStyle = .fullScreen
            present(homePage, animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToSendRequest" {
            let vc = segue.destination as! CompanyPortalViewController
            if let company = searchCompanies.text {
                vc.currentCompany = company
            }
        }
    }
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
