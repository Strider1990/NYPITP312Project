//
//  User.swift
//  NYPITP312
//
//  Created by Jervis Ang on 3/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class User: NSObject {
    
    //MARK: Properties
    let name: String
    let email: String
    let id: String
    let azureId: String
    var profilePic: UIImage
    var bookArray: [Book]
    
    //MARK: Methods
    class func registerUser(withName: String, email: String, password: String, profilePic: UIImage, azureId: String, completion: @escaping (Bool) -> Swift.Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                user?.sendEmailVerification(completion: nil)
                let storageRef = FIRStorage.storage().reference().child("usersProfilePics").child(user!.uid)
                let imageData = UIImageJPEGRepresentation(profilePic, 0.1)
                storageRef.put(imageData!, metadata: nil, completion: { (metadata, err) in
                    if err == nil {
                        let path = metadata?.downloadURL()?.absoluteString
                        let values = ["name": withName, "email": email, "profilePicLink": path!, "azureId": azureId]
                        FIRDatabase.database().reference().child("users").child(user!.uid).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
                            if errr == nil {
                                let userInfo = ["email" : email, "password" : password]
                                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                                completion(true)
                            }
                        })
                    }
                })
            }
            else {
                completion(false)
            }
        })
    }
    
    class func loginUser(withEmail: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error == nil {
                let userInfo = ["email": withEmail, "password": password]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    class func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
        do {
            try FIRAuth.auth()?.signOut()
            UserDefaults.standard.removeObject(forKey: "userInformation")
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
    class func info(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        FIRDatabase.database().reference().child("users").child(forUserID).child("credentials").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                let name = data["name"]!
                let email = data["email"]!
                let link = URL.init(string: data["profilePicLink"]!)
                let azureId = data["azureId"]!
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = User.init(name: name, email: email, id: forUserID, profilePic: profilePic!, azureId: azureId)
                        completion(user)
                    }
                }).resume()
            }
        })
    }
    
    class func downloadAllUsers(exceptID: String, completion: @escaping (User) -> Swift.Void) {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            let data = snapshot.value as! [String: Any]
            let credentials = data["credentials"] as! [String: String]
            if id != exceptID {
                let name = credentials["name"]!
                let email = credentials["email"]!
                let link = URL.init(string: credentials["profilePicLink"]!)
                let azureId = credentials["azureId"]!
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = User.init(name: name, email: email, id: id, profilePic: profilePic!, azureId: azureId)
                        completion(user)
                    }
                }).resume()
            }
        })
    }
    
    class func getSpecificUser(exceptID: String, azureId: String, completion: @escaping (User) -> Swift.Void) {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            let data = snapshot.value as! [String: Any]
            let credentials = data["credentials"] as! [String: String]
            if id != exceptID {
                if credentials["azureId"] == azureId {
                    let name = credentials["name"]!
                    let email = credentials["email"]!
                    do {
                        let data = try Data(contentsOf: URL(string: "http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=users/\(azureId)_c150")!)
                        let profilePic = UIImage(data: data)
                        let user = User(name: name, email: email, id: id, profilePic: profilePic!, azureId: azureId)
                        completion(user)
                    } catch {
                        let profilePic = UIImage(named: "profile")
                        let user = User(name: name, email: email, id: id, profilePic: profilePic!, azureId: azureId)
                        completion(user)
                    }
                }
            }
        })
    }
    
    class func checkUserVerification(completion: @escaping (Bool) -> Swift.Void) {
        FIRAuth.auth()?.currentUser?.reload(completion: { (_) in
            let status = (FIRAuth.auth()?.currentUser?.isEmailVerified)!
            completion(status)
        })
    }
    
    
    //MARK: Inits
    init(name: String, email: String, id: String, profilePic: UIImage, azureId: String) {
        self.name = name
        self.email = email
        self.id = id
        self.profilePic = profilePic
        self.azureId = azureId
        self.bookArray = []
    }
}



