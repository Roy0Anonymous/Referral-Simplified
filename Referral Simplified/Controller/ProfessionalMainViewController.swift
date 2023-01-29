//
//  ProfessionalMainViewController.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 05/01/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import ZIMKit

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
                    professional.name = (document.data()!["name"] as! String)
                    professional.company = (document.data()!["company"] as! String)
                    professional.email = (document.data()!["email"] as! String)
                    professional.phone = (document.data()!["phone"] as! String)
                    professional.dob = (document.data()!["DOB"] as! String)
                    professional.country = (document.data()!["Country"] as! String)
                    professional.city = (document.data()!["City"] as! String)
                    professional.position = (document.data()!["position"] as! String)
                    professional.gender = (document.data()!["Gender"] as! String)
                    self.loadData {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    self.connectUserAction()
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
                            let cell = CellData(name: stuData["name"] as! String, university: stuData["university"] as! String, cgpa: stuData["cgpa"] as! Float, uid: documentData["UID"] as! String)
                            self.applications.append(cell)
//                            print(documentData["UID"])
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
    
    func connectUserAction() {
        // Your ID as a user.
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let userID: String = currentUser.uid
        print(userID)
        // Your name as a user.
        let userName: String = professional.name!
        // The image you set as the user avatar must be network image. e.g., https://storage.zego.im/IMKit/avatar/avatar-0.png
        let userAvatarUrl: String = "https://storage.zego.im/IMKit/avatar/avatar-0.png"
        
        let userInfo = UserInfo(userID, userName)
        userInfo.avatarUrl = userAvatarUrl
        ZIMKitManager.shared.connectUser(userInfo: userInfo) { [weak self] error in
            //  Display the UI views after connecting the user successfully.
            if error.code == .success {
//                self?.startOneOnOneChat(userID: user)
            }
        }
    }
    
    func startOneOnOneChat(userID: String) {
        let messageVC = MessagesListVC(conversationID: userID, type: .peer)
        navigationController?.pushViewController(messageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        startOneOnOneChat(userID: applications[indexPath.row].uid)
//        print(applications[indexPath.row].uid)
        startOneOnOneChat(userID: applications[indexPath.row].uid)
    }
}
