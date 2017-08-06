//
//  UserBookCollectionViewCell.swift
//  NYPITP312
//
//  Created by Alex Ooi on 4/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserBookCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var donatedImage: UIImageView!
    @IBOutlet weak var donatedBookName: UILabel!
    @IBOutlet weak var donatedBookDate: UILabel!
    @IBOutlet weak var requestBtn: UIButton!
    
    var book: Book!
    
    @IBAction func requestBtn(_ sender: UIButton) {
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
