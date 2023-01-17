//
//  StuProSelectionViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 31/12/22.
//

import UIKit

class StuProSelectionViewController: UIViewController {
//    var userDetails: UserDetails = UserDetails(name: "", email: "", phone: "")
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var givingButton: UIButton!
    @IBOutlet weak var askingButton: UIButton!
    
    @IBOutlet weak var giveImageView: UIImageView!
    @IBOutlet weak var takeImageView: UIImageView!
    
    let imageDownSample = ImageDownSample()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.hidesBackButton = true
        
        askingButton.layer.cornerRadius = 15.0
        askingButton.layer.borderWidth = 2.0
        askingButton.clipsToBounds = true
        askingButton.layer.borderColor = UIColor.black.cgColor
        
        givingButton.layer.cornerRadius = 15.0
        givingButton.layer.borderWidth = 2.0
        givingButton.clipsToBounds = true
        givingButton.layer.borderColor = UIColor.black.cgColor
        
        continueButton.layer.cornerRadius = 15.0
        continueButton.clipsToBounds = true
        
        if let url = URL.localURLForXCAsset(name: "Giving") {
            let downsampledImage = imageDownSample.downsample(imageAt: url, to: giveImageView.bounds.size)
            giveImageView.image = downsampledImage
        }
        if let url = URL.localURLForXCAsset(name: "Taking") {
            let downsampledImage = imageDownSample.downsample(imageAt: url, to: takeImageView.bounds.size)
            takeImageView.image = downsampledImage
        }
    }
    
    @IBAction func givingPressed(_ sender: UIButton) {
        askingButton.layer.borderColor = UIColor.black.cgColor
        givingButton.layer.borderColor = UIColor(red: 235/255, green: 69/255, blue: 102/255, alpha: 1).cgColor
        
        UserDetails.isStudent = false
        
//        performSegue(withIdentifier: "selectionToStudentDes", sender: self)
    }
    
    @IBAction func askingPressed(_ sender: UIButton) {
        askingButton.layer.borderColor = UIColor(red: 235/255, green: 69/255, blue: 102/255, alpha: 1).cgColor
        givingButton.layer.borderColor = UIColor.black.cgColor
        
        UserDetails.isStudent = true
        
//        performSegue(withIdentifier: "selectionToProDes", sender: self)
    }
    
    
    @IBAction func continuePressed(_ sender: UIButton) {
        guard let isStudent = UserDetails.isStudent else {
            return
        }
        
        if isStudent == true {
            student = Student(name: userDetails.name, email: userDetails.email, phone: userDetails.phone)
        } else {
            professional = Professional(name: userDetails.name, email: userDetails.email, phone: userDetails.phone)
        }
        performSegue(withIdentifier: "selectionToDOB", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "selectionToStudentDes" {
//            let vc = segue.destination as! StudentDescriptionViewController
//            let studentData: Student = Student(name: userDetails.name, email: userDetails.email, phone: userDetails.phone)
//            vc.studentDetails = studentData
//        } else if segue.identifier == "selectionToProDes" {
//            let vc = segue.destination as! ProfessionalDescriptionViewController
//            let professionalData: Professional = Professional(name: userDetails.name, email: userDetails.email, phone: userDetails.phone)
//            vc.professionalDetails = professionalData
//        }
    }
}

//extension StuProSelectionViewController: SignUpViewControllerDelegate {
//    func getUserDetails(_ userData: UserDetails) {
//        self.userDetails = userData
//        print("hello")
//    }
//}
