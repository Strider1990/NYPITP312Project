//
//  BookCollectionViewCell.swift
//  NYPITP312
//
//  Created by Alex Ooi on 28/7/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import FirebaseAuth

class BookCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bookImg: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookDate: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var requestButton: UIButton!
    
    var bookId: String!
    var book: Book!
    
    @IBAction func requestBtn(_ sender: UIButton) {
        User.getSpecificUser(exceptID: (FIRAuth.auth()?.currentUser?.uid)!, azureId: book.donor_id!, completion: {
            user in
            
            let userInfo = ["user": user]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showUserMessages"), object: nil, userInfo: userInfo)
        })
    }
}
