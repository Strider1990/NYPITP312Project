//
//  UserBookCollectionViewCell.swift
//  NYPITP312
//
//  Created by Alex Ooi on 4/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserBookCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var donatedImage: UIImageView!
    @IBOutlet weak var donatedBookName: UILabel!
    @IBOutlet weak var donatedBookDate: UILabel!
    @IBOutlet weak var requestBtn: UIButton!
    @IBOutlet weak var favouriteBtn: UIButton!
    
    var book: Book!
    
    @IBAction func requestBtn(_ sender: UIButton) {
        if FIRAuth.auth()?.currentUser == nil || FIRAuth.auth()?.currentUser?.uid == nil {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginNeeded"), object: nil)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showSpinner"), object: nil)
            DispatchQueue.global(qos: .background).async {
                User.getSpecificUser(exceptID: (FIRAuth.auth()?.currentUser?.uid)!, azureId: self.book.donor_id!, completion: {
                    user in
                    let userInfo = ["user": user]
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showUserMessages"), object: nil, userInfo: userInfo)
                    }
                })
            }
        }
    }
    
    @IBAction func favouriteBtn(_ sender: UIButton) {
        let id = self.book.id!
        if FIRAuth.auth()?.currentUser == nil || FIRAuth.auth()?.currentUser?.uid == nil {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginNeeded"), object: nil)
        } else {
            DispatchQueue.global(qos: .background).async {
                var bookmarks: [String] = UserDefaults.standard.stringArray(forKey: "bookmarks") ?? [String]()
                if bookmarks.contains(id) {
                    bookmarks.remove(at: bookmarks.index(of: id)!)
                    FIRDatabase.database().reference().child("bookmarks").child((FIRAuth.auth()?.currentUser?.uid)!).child(id).removeValue()
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "bookmarkToggle"), object: nil, userInfo: [id: false])
                    }
                } else {
                    bookmarks.append(id)
                    FIRDatabase.database().reference().child("bookmarks").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues([id: true])
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "bookmarkToggle"), object: nil, userInfo: [id: true])
                    }
                }
                UserDefaults.standard.set(bookmarks, forKey: "bookmarks")
            }
        }
    }

}
