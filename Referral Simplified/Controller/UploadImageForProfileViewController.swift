//
//  UploadImageForProfileViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 30/01/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class UploadImageForProfileViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var displayImage: UIImageView!
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        continueButton.layer.cornerRadius = 15.0
        continueButton.clipsToBounds = true
        
        cameraButton.layer.cornerRadius = 0.5 * cameraButton.bounds.size.width
        cameraButton.clipsToBounds = true

        if student.gender == "Male" || professional.gender == "Male" {
            if let url = URL.localURLForXCAsset(name: "boy") {
                let downsampledImage = ImageDownSample.downsample(imageAt: url, to: displayImage.bounds.size)
                displayImage.image = downsampledImage
            }
//            displayImage.image = UIImage(named: "boy")
        } else {
            if let url = URL.localURLForXCAsset(name: "girl") {
                let downsampledImage = ImageDownSample.downsample(imageAt: url, to: displayImage.bounds.size)
                displayImage.image = downsampledImage
            }
//            displayImage.image = UIImage(named: "girl")
        }
    }
    
    @IBAction func imageSelector(_ sender: UIButton) {
        DispatchQueue.main.async { [unowned self] in
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        if UserDetails.isStudent == true {
            performSegue(withIdentifier: "profilePicToEducation", sender: self)
        } else {
            performSegue(withIdentifier: "profilePicToCompanyDetails", sender: self)
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

extension UploadImageForProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        let storageRef = storage.reference()
        
        let resumeRef = storageRef.child("/\(userDetails.email!)/profile.jpg")
        let data = image.jpegData(compressionQuality: 1.0)
        guard let data = data else {
            return
        }
        DispatchQueue.main.async {
            self.displayImage.image = image
        }
        let uploadTask = resumeRef.putData(data) { (metadata, error) in
            if let error = error {
                print("Error uploading file: \(error)")
            } else {
                print("File uploaded successfully")
                resumeRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting url: \(error)")
                    } else {
                        if UserDetails.isStudent == true {
                            student.profile = url
                        } else {
                            professional.profile = url
                        }
                        print("Uploading Image")
                    }
                }
            }
        }
    }
}
