//
//  CompanyPortalViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 04/01/23.
//

import UIKit

class CompanyPortalViewController: UIViewController {

    @IBOutlet weak var companyLabel: UILabel!
    var currentCompany: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        companyLabel.text = "\(currentCompany) Portal"
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
