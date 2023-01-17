//
//  UserDescriptionViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 31/12/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import UniformTypeIdentifiers
import FirebaseStorage

class StudentDescriptionViewController: UIViewController {
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var browseButton: UIButton!
    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var gradPicker: UIPickerView!
    @IBOutlet weak var degreeField: UITextField!
    @IBOutlet weak var univField: UITextField!
    @IBOutlet weak var browseLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var img: UIImage?
    var studentDetails: Student = Student(name: "", email: "", phone: "")
    let gradYears = [Int](2000...2050)
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let myColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
//        univField.delegate = self
        univField.layer.cornerRadius = 10.0
        univField.layer.borderWidth = 2.0
        univField.backgroundColor = myColor
        univField.clipsToBounds = true
        
//        degreeField.delegate = self
        degreeField.layer.cornerRadius = 10.0
        degreeField.layer.borderWidth = 2.0
        degreeField.backgroundColor = myColor
        degreeField.clipsToBounds = true
        
//        studentDetails.isStudent = true
        gradPicker.delegate = self
        gradPicker.dataSource = self
//        gradPicker.overrideUserInterfaceStyle = .dark
//        dobPicker.overrideUserInterfaceStyle = .dark
        studentDetails.graduation = gradYears[0]
        browseLabel.isHidden = true
        spinner.isHidden = true
        alertLabel.isHidden = true
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if spinner.isAnimating == true {
            alertLabel.isHidden = false
            return
        }
        alertLabel.isHidden = true
        if let univ = univField.text, let degree = degreeField.text {
            let dob = dobPicker.date
            studentDetails.university = univ
            studentDetails.degree = degree
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            studentDetails.dob = dateFormatter.string(from: dob)
            guard let resume = studentDetails.resume else { return }
            
            let newDocumentID = Auth.auth().currentUser?.uid
            print(newDocumentID!)
            db.collection("Students").document(newDocumentID!).setData([
                "name" : studentDetails.name,
                "email" : studentDetails.email,
                "phone" : studentDetails.phone,
                "university" : studentDetails.university!,
                "degree" : studentDetails.degree!,
                "graduation" : studentDetails.graduation!,
                "dob" : studentDetails.dob!,
                "resume" : resume.absoluteString
//                "isStudent" : studentDetails.isStudent!
            ], merge: true) { error in
                if let safeError = error {
                    print(safeError)
                } else {
                    self.performSegue(withIdentifier: "detailsToStudentMain", sender: self)
                }
            }
        }
    }
    
    @IBAction func uploadResume(_ sender: UIButton) {
        if spinner.isAnimating == true {
            alertLabel.isHidden = false
            return
        }
        alertLabel.isHidden = true
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsToStudentMain" {
            let vc = segue.destination as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
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

extension StudentDescriptionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gradYears.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(gradYears[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        studentDetails.graduation = gradYears[row]
    }
}

extension StudentDescriptionViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let currUrl = urls[0]
        _ = currUrl.startAccessingSecurityScopedResource()
        
        do {
            spinner.startAnimating()
            self.spinner.isHidden = false
            let data = try Data(contentsOf: currUrl)

            let storageRef = storage.reference()
            let resumeRef = storageRef.child("/\(studentDetails.email)/resume.pdf")
            resumeRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    self.alertLabel.isHidden = true
                    return
                }
                _ = metadata.size
                resumeRef.downloadURL { [self] (url, error) in
                    guard let downloadURL = url else {
                        self.spinner.stopAnimating()
                        self.spinner.isHidden = true
                        self.alertLabel.isHidden = true
                        return
                    }
                    studentDetails.resume = downloadURL
                    let fileName = currUrl.lastPathComponent
                    browseButton.titleLabel?.text = ""
                    browseLabel.text = fileName
                    browseLabel.isHidden = false
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    self.alertLabel.isHidden = true
                    self.browseButton.titleLabel?.isHidden = true
                }
            }
        } catch {
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            self.alertLabel.isHidden = true
            print(error)
        }
        
        currUrl.stopAccessingSecurityScopedResource()
        
        
        
//        let storageRef = storage.reference()
//        let resumeRef = storageRef.child("/\(studentDetails.email)/resume.pdf")
//
//        let uploadTask = resumeRef.putFile(from: url, metadata: nil) { metadata, error in
//            guard let metadata = metadata else {
//                print("fucked")
//                return
//            }
//            print("hello peo")
//            let size = metadata.size
//            resumeRef.downloadURL { (url, error) in
//                guard let downloadURL = url else {
//                    return
//                }
//                let fileName = url!.lastPathComponent
//                self.browseButton.titleLabel?.text = ""
//                self.browseButton.tintColor = .clear
//                self.browseLabel.text = fileName
//                self.browseLabel.isHidden = false
//                self.studentDetails.resume = downloadURL
//            }
//        }
    }
}
