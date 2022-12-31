//
//  UserDescriptionViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 31/12/22.
//

import UIKit

class StudentDescriptionViewController: UIViewController {
    var studentDetails: Student = Student()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(studentDetails.name)
        print(studentDetails.email)
        print(studentDetails.phone)
        print(studentDetails.dob)
        print(studentDetails.graduation)
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
