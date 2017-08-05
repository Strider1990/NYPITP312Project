//
//  DonationCollectionViewCell.swift
//  NYPITP312
//
//  Created by Alex Ooi on 4/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class DonationCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var donationPhoto: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var donateDate: UILabel!
    
    var book: Book!
}
