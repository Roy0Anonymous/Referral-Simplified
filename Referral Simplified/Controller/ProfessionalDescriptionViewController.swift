//
//  ProfessionalDescriptionViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 31/12/22.
//

import UIKit

class ProfessionalDescriptionViewController: UIViewController {
    var professionalDetails: Professional = Professional()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(professionalDetails.name)
        print(professionalDetails.email)
        print(professionalDetails.phone)
        print(professionalDetails.company)
        // Do any additional setup after loading the view.
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
