//
//  ProfessionalDetailsViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 30/12/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class HomeViewController: UIViewController {

    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerSignInSegmentedControl: UISegmentedControl!
    
    var isSignUp: Bool = true
    
    let db = Firestore.firestore()
    let imageDownSample = ImageDownSample()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let url = URL.localURLForXCAsset(name: "DisplayImage") {
            let downsampledImage = imageDownSample.downsample(imageAt: url, to: homeImageView.bounds.size)
            homeImageView.image = downsampledImage
        }
        
//        registerSignInSegmentedControl.overrideUserInterfaceStyle = .light
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        registerButton.isHidden = true
        performSegue(withIdentifier: "homeToSignUpSignIn", sender: self)
        isSignUp = true
    }
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            isSignUp = false
            performSegue(withIdentifier: "homeToSignUpSignIn", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToSignUpSignIn" {
            let vc = segue.destination as! SignUpSignInViewController
            vc.isSignUp = isSignUp
        }
    }
}

extension URL {
    static func localURLForXCAsset(name: String) -> URL? {
        let fileManager = FileManager.default
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
        let url = cacheDirectory.appendingPathComponent("\(name).png")
        let path = url.path
        if !fileManager.fileExists(atPath: path) {
            guard let image = UIImage(named: name), let data = image.pngData() else {return nil}
            fileManager.createFile(atPath: path, contents: data, attributes: nil)
        }
        return url
    }
}
