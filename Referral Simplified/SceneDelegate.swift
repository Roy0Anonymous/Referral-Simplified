//
//  SceneDelegate.swift
//  Referral Simplified
//
//  Created by Rahul Roy on 30/12/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let db = Firestore.firestore()
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        Firestore.firestore().disableNetwork { (error) in
            let currentUser = Auth.auth().currentUser
            if currentUser != nil {
                var docRef = self.db.collection("Students").document(currentUser!.uid)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        print("Student me ghusa")
                        student.name = (document.data()!["name"] as! String)
                        student.university = (document.data()!["university"] as! String)
                        student.cgpa = (document.data()!["cgpa"] as! Float)
                        student.course = (document.data()!["course"] as! String)
                        student.graduation = (document.data()!["graduation"] as! Int)
                        student.gender = (document.data()!["gender"] as! String)
                        student.country = (document.data()!["country"] as! String)
                        student.city = (document.data()!["city"] as! String)
                        student.dob = (document.data()!["dob"] as! String)
                        student.phone = (document.data()!["phone"] as! String)
                        student.email = (document.data()!["email"] as! String)
                        student.additionalDoc = URL(string: (document.data()!["additional"] as! String))
                        student.resume = URL(string: (document.data()!["resume"] as! String))
                        
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "studentlNavController") as! UINavigationController
                        Firestore.firestore().enableNetwork { (error) in }
                        DispatchQueue.main.async {
                            self.window?.rootViewController = homePage
                        }
                        return
                    }
                }
                docRef = self.db.collection("Professionals").document(currentUser!.uid)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        print("Professional me ghusa")
                        
                        professional.name = (document.data()!["name"] as! String)
                        professional.company = (document.data()!["company"] as! String)
                        professional.email = (document.data()!["email"] as! String)
                        professional.phone = (document.data()!["phone"] as! String)
                        professional.dob = (document.data()!["DOB"] as! String)
                        professional.country = (document.data()!["Country"] as! String)
                        professional.city = (document.data()!["City"] as! String)
                        professional.position = (document.data()!["position"] as! String)
                        professional.gender = (document.data()!["Gender"] as! String)
                        
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "professionalNavController") as! UINavigationController
                        Firestore.firestore().enableNetwork { (error) in }
                        DispatchQueue.main.async {
                            self.window?.rootViewController = homePage
                        }
                        return
                    }
                }
            }
            Firestore.firestore().enableNetwork { (error) in }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

