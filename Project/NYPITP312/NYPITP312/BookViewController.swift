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
    var par: RootNavViewController!
    var userDetail: UserDetail!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let token = par.login.token, userDetail == nil {
            let detail: UserDetail = UserDetail()
            DispatchQueue.global(qos: .background).async {
                HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/user/get", json: JSON.init(parseJSON: "{\"id\": \"\((self.book?.donor_id)!)\", \"token\": \"\(token)\"}"), onComplete: {
                    json, response, error in
                    
                    if json == nil
                    {
                        return
                    }
                    
                    detail.id = json!["id"].string!
                    detail.name = json!["name"].string!
                    detail.photo = json!["photo"].string!
                    do {
                        detail.photoData = try Data(contentsOf: URL(string: "http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=users/\(detail.photo!)_c150")!)
                    } catch {
                        print("Unable to load user detail photo data")
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        par = self.parent as! RootNavViewController
        
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if par.login.token == nil {
            performSegue(withIdentifier: "LoginSegue", sender: self)
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserSegue" {
            let userView = segue.destination as! UserViewController
            userView.id = book?.donor_id
            userView.name = book?.donor
            userView.userDetail = self.userDetail
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
