//
//  StuProSelectionViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 31/12/22.
//

import UIKit

class StuProSelectionViewController: UIViewController {
    var userDetails: UserDetails = UserDetails(name: "", email: "", phone: "")
    let signUpVC = SignUpViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(userDetails.name)
//        print(userDetails.email)
//        print(userDetails.phone)
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
    
    @IBAction func studentPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "selectionToStudentDes", sender: self)
    }
    
    @IBAction func professionalPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "selectionToProDes", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectionToStudentDes" {
            let vc = segue.destination as! StudentDescriptionViewController
            let studentData: Student = Student(name: userDetails.name, email: userDetails.email, phone: userDetails.phone)
            vc.studentDetails = studentData
        } else if segue.identifier == "selectionToProDes" {
            let vc = segue.destination as! ProfessionalDescriptionViewController
            let professionalData: Professional = Professional(name: userDetails.name, email: userDetails.email, phone: userDetails.phone)
            vc.professionalDetails = professionalData
        }
    }
}

//extension StuProSelectionViewController: SignUpViewControllerDelegate {
//    func getUserDetails(_ userData: UserDetails) {
//        self.userDetails = userData
//        print("hello")
//    }
//}
