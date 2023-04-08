//
//  UserInputViewControllers.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 13/01/23.
//

import UIKit
import iOSDropDown
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import UniformTypeIdentifiers

class BirthdayViewController: UIViewController {
    @IBOutlet weak var year: DropDown!
    @IBOutlet weak var month: DropDown!
    @IBOutlet weak var day: DropDown!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    let monthOptions = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleLabel.text = "What are you here for, \(userDetails.name!)?"
        
        if UserDetails.isStudent == true {
            navigationItem.title = "Step 1 of 5"
        } else {
            navigationItem.title = "Step 1 of 4"
        }
        
        let myColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
            .foregroundColor : UIColor.gray
        ]
        
        day.layer.cornerRadius = 10.0
        day.layer.borderWidth = 2.0
        day.backgroundColor = myColor
        day.clipsToBounds = true
        day.attributedPlaceholder = NSAttributedString(string: "Day", attributes: attributes)
        day.disableArrow()
        
        month.layer.cornerRadius = 10.0
        month.layer.borderWidth = 2.0
        month.backgroundColor = myColor
        month.clipsToBounds = true
        month.attributedPlaceholder = NSAttributedString(string: "Month", attributes: attributes)
        month.disableArrow()
        
        year.layer.cornerRadius = 10.0
        year.layer.borderWidth = 2.0
        year.backgroundColor = myColor
        year.clipsToBounds = true
        year.attributedPlaceholder = NSAttributedString(string: "Year", attributes: attributes)
        year.disableArrow()
        var days = ["01", "02", "03", "04", "05", "06", "07", "08", "09"]
        days.append(contentsOf: (10...31).map(String.init))
        day.optionArray = days
        month.optionArray = ["January","February","March","April","May","June","July","August","September","October","November","December"]
        year.optionArray = (1900...2050).map(String.init)
        
        continueButton.layer.cornerRadius = 15.0
        continueButton.clipsToBounds = true
    }
    
    
    @IBAction func continuePressed(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let monthStr = month.text {
            let monthPos = (monthOptions.firstIndex(of: monthStr) ?? -1) + 1
            let extractedDate = "\(day.text ?? "")-\(monthPos)-\(year.text ?? "")"
            if let date = dateFormatter.date(from: extractedDate) {
                if UserDetails.isStudent == true {
                    student.dob = dateFormatter.string(from: date)
                } else {
                    professional.dob = dateFormatter.string(from: date)
                }
                performSegue(withIdentifier: "dobToCountryCity", sender: self)
            }
            else {
                print("Date is Invalid")
            }
        }
    }
}

class CountryCityViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var country: DropDown!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = "What are you here for, \(userDetails.name!)?"
        
        if UserDetails.isStudent == true {
            navigationItem.title = "Step 2 of 5"
        } else {
            navigationItem.title = "Step 2 of 4"
        }
        
        let myColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
            .foregroundColor : UIColor.gray
        ]
        
        country.layer.cornerRadius = 10.0
        country.layer.borderWidth = 2.0
        country.backgroundColor = myColor
        country.clipsToBounds = true
        country.attributedPlaceholder = NSAttributedString(string: "Country", attributes: attributes)
        
        city.layer.cornerRadius = 10.0
        city.layer.borderWidth = 2.0
        city.backgroundColor = myColor
        city.clipsToBounds = true
        city.attributedPlaceholder = NSAttributedString(string: "City", attributes: attributes)
        
        country.optionArray = countryList
        
        continueButton.layer.cornerRadius = 15.0
        continueButton.clipsToBounds = true
        
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        if let country = country.text, let city = city.text, country != "", city != "" {
            if UserDetails.isStudent == true {
                student.country = country
                student.city = city
            } else {
                professional.country = country
                professional.city = city
            }
            performSegue(withIdentifier: "countryCityToGender", sender: self)
        }
    }
    
}

class GenderViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var nonBinaryButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    @IBOutlet weak var maleImageView: UIImageView!
    @IBOutlet weak var femaleImageView: UIImageView!
    @IBOutlet weak var nonBinaryImageView: UIImageView!
    
    var isMale: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "What are you here for, \(userDetails.name!)?"
        if UserDetails.isStudent == true {
            navigationItem.title = "Step 3 of 5"
        } else {
            navigationItem.title = "Step 3 of 4"
        }
        
        if let url = URL.localURLForXCAsset(name: "Male") {
            let downsampledImage = ImageDownSample.downsample(imageAt: url, to: maleImageView.bounds.size)
            maleImageView.image = downsampledImage
        }
        if let url = URL.localURLForXCAsset(name: "Female") {
            let downsampledImage = ImageDownSample.downsample(imageAt: url, to: femaleImageView.bounds.size)
            femaleImageView.image = downsampledImage
        }
        if let url = URL.localURLForXCAsset(name: "Prefer Not To Say") {
            let downsampledImage = ImageDownSample.downsample(imageAt: url, to: nonBinaryImageView.bounds.size)
            nonBinaryImageView.image = downsampledImage
        }
        
        maleButton.layer.cornerRadius = 15.0
        maleButton.layer.borderWidth = 2.0
        maleButton.clipsToBounds = true
        maleButton.layer.borderColor = UIColor.black.cgColor
        
        femaleButton.layer.cornerRadius = 15.0
        femaleButton.layer.borderWidth = 2.0
        femaleButton.clipsToBounds = true
        femaleButton.layer.borderColor = UIColor.black.cgColor
        
        nonBinaryButton.layer.cornerRadius = 15.0
        nonBinaryButton.layer.borderWidth = 2.0
        nonBinaryButton.clipsToBounds = true
        nonBinaryButton.layer.borderColor = UIColor.black.cgColor
        
        continueButton.layer.cornerRadius = 15.0
        continueButton.clipsToBounds = true
    }
    @IBAction func malePressed(_ sender: UIButton) {
        femaleButton.layer.borderColor = UIColor.black.cgColor
        nonBinaryButton.layer.borderColor = UIColor.black.cgColor
        maleButton.layer.borderColor = UIColor(red: 235/255, green: 69/255, blue: 102/255, alpha: 1).cgColor
        isMale = 1
    }
    
    
    @IBAction func femalePressed(_ sender: UIButton) {
        maleButton.layer.borderColor = UIColor.black.cgColor
        nonBinaryButton.layer.borderColor = UIColor.black.cgColor
        femaleButton.layer.borderColor = UIColor(red: 235/255, green: 69/255, blue: 102/255, alpha: 1).cgColor
        isMale = 0
    }
    
    
    @IBAction func nonBinaryPressed(_ sender: UIButton) {
        maleButton.layer.borderColor = UIColor.black.cgColor
        femaleButton.layer.borderColor = UIColor.black.cgColor
        nonBinaryButton.layer.borderColor = UIColor(red: 235/255, green: 69/255, blue: 102/255, alpha: 1).cgColor
        isMale = 2
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        guard let isMale = isMale else {
            return
        }
        
        if UserDetails.isStudent == true {
            if isMale == 1 {
                student.gender = "Male"
            } else if isMale == 0 {
                student.gender = "Female"
            } else {
                student.gender = "Prefer Not to Say"
            }
//            performSegue(withIdentifier: "genderToEducation", sender: self)
        } else {
            if isMale == 1 {
                professional.gender = "Male"
            } else if isMale == 0 {
                professional.gender = "Female"
            } else {
                professional.gender = "Prefer Not to Say"
            }
//            performSegue(withIdentifier: "genderToCompanyDetails", sender: self)
        }
        performSegue(withIdentifier: "genderToProfilePic", sender: self)
    }
}

class StudyHistoryViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var graduation: DropDown!
    @IBOutlet weak var course: DropDown!
    @IBOutlet weak var universityField: UITextField!
    @IBOutlet weak var cgpa: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "What are you here for, \(userDetails.name!)?"
        navigationItem.title = "Step 4 of 5"
        
        let myColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
            .foregroundColor : UIColor.gray
        ]
        
        universityField.layer.cornerRadius = 10.0
        universityField.layer.borderWidth = 2.0
        universityField.backgroundColor = myColor
        universityField.clipsToBounds = true
        universityField.attributedPlaceholder = NSAttributedString(string: "University", attributes: attributes)
        
        graduation.layer.cornerRadius = 10.0
        graduation.layer.borderWidth = 2.0
        graduation.backgroundColor = myColor
        graduation.clipsToBounds = true
        graduation.attributedPlaceholder = NSAttributedString(string: "Graduation Year", attributes: attributes)
        graduation.delegate = self
        
        course.layer.cornerRadius = 10.0
        course.layer.borderWidth = 2.0
        course.backgroundColor = myColor
        course.clipsToBounds = true
        course.attributedPlaceholder = NSAttributedString(string: "Course", attributes: attributes)
        course.delegate = self
        
        cgpa.layer.cornerRadius = 10.0
        cgpa.layer.borderWidth = 2.0
        cgpa.backgroundColor = myColor
        cgpa.clipsToBounds = true
        cgpa.attributedPlaceholder = NSAttributedString(string: "CGPA", attributes: attributes)
        
        continueButton.layer.cornerRadius = 15.0
        continueButton.clipsToBounds = true
        
        graduation.optionArray = (2010...2050).map(String.init)
        course.optionArray = [
            "BTech", "BArch", "BCA", "BSc", "MS", "MTech", "MCA", "MBA"
        ]
        
        print(student.profile?.absoluteString)
    }
    
    
    @IBAction func continuePressed(_ sender: UIButton) {
        if let university = universityField.text, let graduation = graduation.text, let course = course.text, let cgpa = cgpa.text, university != "", graduation != "", course != "" {
            student.university = university
            student.graduation = Int(graduation)
            student.course = course
            student.cgpa = Float(cgpa)
            
            performSegue(withIdentifier: "educationToDocuments", sender: self)
        }
    }
    
}

extension StudyHistoryViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
        scrollView.setContentOffset(bottomOffset, animated: false)
    }
}

class UploadDocuments: UIViewController {
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var additionalDocButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var spinner1: UIActivityIndicatorView!
    @IBOutlet weak var spinner2: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var buttonIdentifier: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Step 5 of 5"
        
        uploadButton.layer.cornerRadius = 15.0
        uploadButton.clipsToBounds = true
        
        additionalDocButton.layer.cornerRadius = 15.0
        additionalDocButton.clipsToBounds = true
        
        doneButton.layer.cornerRadius = 15.0
        doneButton.clipsToBounds = true
        
        spinner1.isHidden = true
        spinner2.isHidden = true
    }
    
    @IBAction func uploadResumePressed(_ sender: UIButton) {
        if spinner1.isAnimating == true {
            return
        }
        buttonIdentifier = 1
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func additionalUploadPressed(_ sender: Any) {
        if spinner2.isAnimating == true {
            return
        }
        buttonIdentifier = 2
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        if spinner1.isAnimating == true || spinner2.isAnimating == true {
            return
        }
        
        guard let resume = student.resume else { return }
        
        let newDocumentID = Auth.auth().currentUser?.uid
        print(newDocumentID!)
        db.collection("Students").document(newDocumentID!).setData([
            "name" : student.name!,
            "email" : student.email!,
            "phone" : student.phone!,
            "dob" : student.dob!,
            "city" : student.city!,
            "country" : student.country!,
            "gender" : student.gender!,
            "university" : student.university!,
            "course" : student.course!,
            "graduation" : student.graduation!,
            "resume" : resume.absoluteString,
            "additional" : student.additionalDoc?.absoluteString ?? "nil",
            "cgpa" : student.cgpa!,
            "profile" : student.profile?.absoluteString ?? "nil"
        ], merge: true) { error in
            if let safeError = error {
                print(safeError)
            } else {
                self.performSegue(withIdentifier: "uploadToStudentMain", sender: self)
            }
        }
    }
}

extension UploadDocuments: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let buttonIdentifier = buttonIdentifier else {
            return
        }
        let currUrl = urls[0]
        _ = currUrl.startAccessingSecurityScopedResource()
        let storageRef = storage.reference()
        let fileName = currUrl.lastPathComponent
        if buttonIdentifier == 1 {
            let resumeRef = storageRef.child("/\(student.email!)/resume.pdf")
            do {
                spinner1.startAnimating()
                spinner1.isHidden = false
                let data = try Data(contentsOf: currUrl)
                let uploadTask = resumeRef.putData(data) { (metadata, error) in
                    if let error = error {
                        print("Error uploading file: \(error)")
                    } else {
                        print("File uploaded successfully")
                        self.uploadButton.setTitle(fileName, for: .normal)
                        resumeRef.downloadURL { url, error in
                            if let error = error {
                                print("Error getting url: \(error)")
                            } else {
                                student.resume = url
                            }
                        }
                    }
                    self.spinner1.stopAnimating()
                    self.spinner1.isHidden = true
                }
            } catch {
                spinner1.stopAnimating()
                spinner1.isHidden = true
                print(error)
            }
        } else {
            let additionalRef = storageRef.child("/\(student.email!)/additional.pdf")
            do {
                spinner2.startAnimating()
                spinner2.isHidden = false
                let data = try Data(contentsOf: currUrl)
                let uploadTask = additionalRef.putData(data) { (metadata, error) in
                    if let error = error {
                        print("Error uploading file: \(error)")
                    } else {
                        print("File uploaded successfully")
                        self.additionalDocButton.setTitle(fileName, for: .normal)
                        additionalRef.downloadURL { url, error in
                            if let error = error {
                                print("Error getting url: \(error)")
                            } else {
                                student.additionalDoc = url
                            }
                        }
                    }
                    self.spinner2.stopAnimating()
                    self.spinner2.isHidden = true
                }
            } catch {
                spinner2.startAnimating()
                spinner2.isHidden = true
                print(error)
            }
        }
        currUrl.stopAccessingSecurityScopedResource()
    }
}


class CompanyDetails: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var positionField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "What are you here for, \(userDetails.name!)?"
        navigationItem.title = "Step 4 of 4"
        
        let myColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
            .foregroundColor : UIColor.gray
        ]
        
        positionField.layer.cornerRadius = 10.0
        positionField.layer.borderWidth = 2.0
        positionField.backgroundColor = myColor
        positionField.clipsToBounds = true
        positionField.attributedPlaceholder = NSAttributedString(string: "Position", attributes: attributes)
        
        companyField.layer.cornerRadius = 10.0
        companyField.layer.borderWidth = 2.0
        companyField.backgroundColor = myColor
        companyField.clipsToBounds = true
        companyField.attributedPlaceholder = NSAttributedString(string: "Company", attributes: attributes)
        
        doneButton.layer.cornerRadius = 15.0
        doneButton.clipsToBounds = true
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        
        if var company = companyField.text, let position = positionField.text, company != "", position != "" {
            professional.company = company
            professional.position = position
            let newDocumentID = Auth.auth().currentUser?.uid
            company = company.uppercased()
            db.collection("Professionals").document(newDocumentID!).setData([
                "name" : professional.name!,
                "email" : professional.email!,
                "phone" : professional.phone!,
                "DOB" : professional.dob!,
                "Country" : professional.country!,
                "City" : professional.city!,
                "Gender" : professional.gender!,
                "company" : company,
                "position" : professional.phone!,
                "profile" : professional.profile?.absoluteString ?? "nil"
            ], merge: true)  { error in
                if let safeError = error {
                    print(safeError)
                } else {
                    self.performSegue(withIdentifier: "detailsToProfessionalMain", sender: self)
                }
            }
            
            var ref: DocumentReference? = nil
            ref = db.collection("CompanyList").addDocument(data: [
                "company" : company
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
        
    }
    
}
    
