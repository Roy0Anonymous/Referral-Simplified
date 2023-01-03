//
//  UserDescriptionViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 31/12/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import UniformTypeIdentifiers

class StudentDescriptionViewController: UIViewController {
    @IBOutlet weak var browseButton: UIButton!
    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var gradPicker: UIPickerView!
    @IBOutlet weak var degreeField: UITextField!
    @IBOutlet weak var univField: UITextField!
    @IBOutlet weak var browseLabel: UILabel!
    var img: UIImage?
    var studentDetails: Student = Student(name: "", email: "", phone: "")
    let gradYears = [Int](2000...2050)
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        studentDetails.isStudent = true
        gradPicker.delegate = self
        gradPicker.dataSource = self
        gradPicker.overrideUserInterfaceStyle = .dark
        dobPicker.overrideUserInterfaceStyle = .dark
        studentDetails.graduation = gradYears[0]
        browseLabel.isHidden = true
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if let univ = univField.text, let degree = degreeField.text {
            let dob = dobPicker.date
            studentDetails.university = univ
            studentDetails.degree = degree
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            studentDetails.dob = dateFormatter.string(from: dob)
            guard let resume = studentDetails.resume else { return }
            var ref: DocumentReference? = nil
            ref = db.collection("Students").addDocument(data: [
                "name" : studentDetails.name,
                "email" : studentDetails.email,
                "phone" : studentDetails.phone,
                "university" : studentDetails.university!,
                "degree" : studentDetails.degree!,
                "graduation" : studentDetails.graduation!,
                "dob" : studentDetails.dob!,
                "resume" : resume,
                "isStudent" : studentDetails.isStudent!
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    self.performSegue(withIdentifier: "detailsToStudentMain", sender: self)
                }
            }
        }
    }
    
    @IBAction func uploadResume(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
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
        let url = urls[0]
        _ = url.startAccessingSecurityScopedResource()
        let data = NSData(contentsOf: url)
        studentDetails.resume = data
        let fileName = url.lastPathComponent
        browseButton.titleLabel?.text = ""
        browseButton.tintColor = .clear
        browseLabel.text = fileName
        browseLabel.isHidden = false
        url.stopAccessingSecurityScopedResource()
    }
}
