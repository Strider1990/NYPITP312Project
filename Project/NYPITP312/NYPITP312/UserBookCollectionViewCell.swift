//
//  UserBookCollectionViewCell.swift
//  NYPITP312
//
//  Created by Alex Ooi on 4/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserBookCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var donatedImage: UIImageView!
    @IBOutlet weak var donatedBookName: UILabel!
    @IBOutlet weak var donatedBookDate: UILabel!
    @IBOutlet weak var requestBtn: UIButton!
    
    var book: Book!
}
