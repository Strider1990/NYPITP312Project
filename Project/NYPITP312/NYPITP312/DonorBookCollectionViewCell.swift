//
//  DonorBookCollectionViewCell.swift
//  NYPITP312
//
//  Created by Alex Ooi on 4/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class DonorBookCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var donorBookImg: UIImageView!
    @IBOutlet weak var donorBookName: UILabel!
    @IBOutlet weak var donorBookDate: UILabel!
    
    var book: Book!
}
