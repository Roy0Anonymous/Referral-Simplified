//
//  ProfessionalMainViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 05/01/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfessionalMainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var company: String?
    var applications: [CellData] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
            let docRef = self.db.collection("Professionals").document(currentUser!.uid)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    self.company = (document.data()!["company"] as! String)
                    self.loadData {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
    func loadData(completion: @escaping () -> Void) {
        let dbCollection = db.collection(company!).order(by: "time", descending: true)
        dbCollection.addSnapshotListener() { (querySnapshot, err) in
            self.applications = []
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let documentData = document.data()
                    let docRef = self.db.collection("Students").document(documentData["UID"] as! String)
                    docRef.getDocument { (stuData, error) in
                        if let stuData = stuData, stuData.exists {
                            let cell = CellData(name: stuData["name"] as! String, university: stuData["university"] as! String, cgpa: stuData["cgpa"] as! Float)
                            self.applications.append(cell)
                            DispatchQueue.main.async {
                                completion()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homePage = mainStoryboard.instantiateViewController(withIdentifier: "InitialNavController") as! UINavigationController
            homePage.modalPresentationStyle = .fullScreen
            present(homePage, animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension ProfessionalMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
//        print(applications.count)
//        print(indexPath.row)
        cell.selectionStyle = .none
        cell.nameLabel.text = applications[indexPath.row].name
        cell.cgpaLabel.text = String(applications[indexPath.row].cgpa)
        cell.universityLabel.text = applications[indexPath.row].university
        return cell
    }
    
}
