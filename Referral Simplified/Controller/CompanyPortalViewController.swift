//
//  CompanyPortalViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 04/01/23.
//

import UIKit

class CompanyPortalViewController: UIViewController {

    @IBOutlet weak var codingProfileField: UITextView!
    @IBOutlet weak var githubIdField: UITextField!
    @IBOutlet weak var linkedinIdField: UITextField!
    @IBOutlet weak var referReasonField: UITextView!
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var companyLabel: UILabel!
    var currentCompany: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentView.backgroundColor = UIColor(white: 0, alpha: 0)
        companyLabel.text = "\(currentCompany) Portal"
    }
    
    @IBAction func submit(_ sender: UIButton) {
        let alert = UIAlertController(title: "Your Request has been Submitted", message: "", preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats:false, block: {_ in
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            })
        })
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
