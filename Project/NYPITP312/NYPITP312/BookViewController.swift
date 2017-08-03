//
//  BookViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 4/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    @IBOutlet weak var bookImg: UIImageView!
    @IBOutlet weak var donor: UIButton!
    @IBOutlet weak var category: UIButton!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = book?.book_name
        self.bookImg.image = UIImage(data: (book?.data!)!)
        self.donor.setTitle(book?.donor, for: .normal)
        self.conditionLabel.text = book?.desc
        self.descriptionLabel.text = "User has not added any additional description to go along with this item"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserSegue" {
            let userView = segue.destination as! UserViewController
            userView.id = book?.donor_id
            userView.name = book?.donor
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
