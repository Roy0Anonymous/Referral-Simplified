//
//  ReferralRequestViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 29/01/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ReferralRequestViewController: UIViewController {

    @IBOutlet weak var codingProfiles: UITextView!
    @IBOutlet weak var reasonForReferral: UITextView!
    @IBOutlet weak var githubField: UITextField!
    @IBOutlet weak var linkedinField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var jobLinkField: UITextField!
    
    let db = Firestore.firestore()
    var codingEditing = false
    var reasonEditing = false
    var currentCompany: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let myColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
            .foregroundColor : UIColor.lightGray
        ]
        
        reasonForReferral.delegate = self
        reasonForReferral.layer.cornerRadius = 10.0
        reasonForReferral.layer.borderWidth = 2.0
        reasonForReferral.backgroundColor = myColor
        reasonForReferral.clipsToBounds = true
        reasonForReferral.attributedText = NSAttributedString(string: "Reason to Refer You", attributes: attributes)
        
        codingProfiles.delegate = self
        codingProfiles.layer.cornerRadius = 10.0
        codingProfiles.layer.borderWidth = 2.0
        codingProfiles.backgroundColor = myColor
        codingProfiles.clipsToBounds = true
        codingProfiles.attributedText = NSAttributedString(string: "Coding Profiles", attributes: attributes)
        
        linkedinField.layer.cornerRadius = 10.0
        linkedinField.layer.borderWidth = 2.0
        linkedinField.backgroundColor = myColor
        linkedinField.clipsToBounds = true
        linkedinField.attributedPlaceholder = NSAttributedString(string: "Linkedin", attributes: attributes)
        
        githubField.layer.cornerRadius = 10.0
        githubField.layer.borderWidth = 2.0
        githubField.backgroundColor = myColor
        githubField.clipsToBounds = true
        githubField.attributedPlaceholder = NSAttributedString(string: "Github", attributes: attributes)
        
        jobLinkField.layer.cornerRadius = 10.0
        jobLinkField.layer.borderWidth = 2.0
        jobLinkField.backgroundColor = myColor
        jobLinkField.clipsToBounds = true
        jobLinkField.attributedPlaceholder = NSAttributedString(string: "Github", attributes: attributes)
        
        submitButton.layer.cornerRadius = 15.0
        submitButton.clipsToBounds = true
    }
    
    
    @IBAction func submitPressed(_ sender: UIButton) {
        let userId = Auth.auth().currentUser?.uid
        guard let codingProfile = codingProfiles.text,
              let githubId = githubField.text,
              let linkedinId = linkedinField.text,
              let referReason = reasonForReferral.text,
              let userId = userId,
              let jobLink = jobLinkField.text else {
            return
        }
        
        db.collection(currentCompany).addDocument(data: [
            "UID" : userId,
            "Coding Profile" : codingProfile,
            "Github ID" : githubId,
            "Linkedin ID" : linkedinId,
            "Refer Reason" : referReason,
            "Job Link" : jobLink,
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

extension ReferralRequestViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
//        print(textView.tag)
        if textView.text == "Reason to Refer You" {
            reasonEditing = true
        } else {
            codingEditing = true
        }
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            let attributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
                .foregroundColor : UIColor.lightGray
            ]
            if reasonEditing == true {
                textView.attributedText = NSAttributedString(string: "Reason to Refer You", attributes: attributes)
                textView.textColor = UIColor.lightGray
                reasonEditing = false
            } else {
                textView.attributedText = NSAttributedString(string: "Coding Profiles", attributes: attributes)
                textView.textColor = UIColor.lightGray
                codingEditing = false
            }
        }
    }
}
