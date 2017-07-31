//
//  Book.swift
//  NYPITP312
//
//  Created by Alex Ooi on 29/7/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class Book: NSObject {
    var id: String?
    var donor: String?
    var donor_id: String?
    var isbn: String?
    var postdt: Int?
    var postdts: String?
    var book_name: String?
    var author: String?
    var publisher: String?
    var edition: String?
    var photos: [String]?
    var cateid: [String]?
    var status: String?
    var preferredLoc: String?
    var desc: String?
    var data: Data?
}
