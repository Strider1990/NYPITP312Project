//
//  UserViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 4/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let reuseIdentifier = "BookCell"
    var id: String?
    var name: String?
    var userDetail: UserDetail!
    var selectedUser: User!
    var bookmarkList: [String] = []
    
    var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var userPhoto: UIImageView!
    
    var bookList: [Book] = []
    @IBOutlet weak var donatedCollectionView: UICollectionView!
    var par: RootNavViewController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bookmarkList = UserDefaults.standard.stringArray(forKey: "bookmarks") ?? [String]()
        self.donatedCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        par = self.parent as! RootNavViewController
        self.userPhoto.layer.cornerRadius = self.userPhoto.frame.width / 2
        self.navigationItem.title = self.name!
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushToUserMesssages(notification:)), name: NSNotification.Name(rawValue: "showUserMessages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinner), name: NSNotification.Name(rawValue: "showSpinner"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.bookmarkToggle(notification:)), name: NSNotification.Name(rawValue: "bookmarkToggle"), object: nil)
        
        DispatchQueue.global(qos: .background).async {
            HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/user/get", json: JSON.init(parseJSON: "{\"id\": \"\(self.id!)\" }"), onComplete: {
                //, \"token\": \"\(self.par.login.token!)\"
                json, response, error in
                
                if json == nil
                {
                    return
                }
                
                do {
                    if let photoStr = json!["id"].string {
                        let data = try Data(contentsOf: URL(string: "http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=users/\(photoStr)_c150")!)
                        DispatchQueue.main.async {
                            self.userPhoto.image = UIImage(data: data)
                            self.par?.navigationItem.title = json!["name"].string ?? "No name"
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.userPhoto.image = UIImage(named: "profile")
                            self.par?.navigationItem.title = json!["name"].string ?? "No name"
                        }
                    }
                } catch {
                        print("Error in data \(json!["photo"].string!)")
                }
            })
        }
        
        DispatchQueue.global(qos: .background).async {
            HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/posting/list", json: JSON.init(parseJSON: "{\"userid\": \"\(self.id!)\", \"orderbypostdt\": \"asc\"}"), onComplete: {
                json, response, error in
                
                if json == nil
                {
                    return
                }
                
                print(json!)
                
                for (_, v) in json! {
                    let book: Book = Book()
                    book.id = v["id"].string!
                    book.donor = v["by"].string ?? "No Donor"
                    book.donor_id = v["byid"].string ?? "No Donor ID"
                    book.isbn = v["isbn"].string!
                    book.postdt = v["postdt"].int!
                    book.postdts = v["postdts"].string!
                    book.book_name = v["name"].string!
                    book.author = v["author"].string!
                    book.publisher = v["publisher"].string!
                    book.edition = v["edition"].string!
                    book.photos = v["photos"].arrayValue.map {$0.stringValue}
                    book.cateid = v["cateid"].arrayValue.map {$0.stringValue}
                    book.status = v["status"].string ?? "No Status"
                    book.desc = v["desc"].string!
                    book.preferredLoc = v["preferredLoc"].string ?? "No Preferred Loc"
                    do {
                        try book.data = Data(contentsOf: URL(string: "http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=postings/\(book.photos![0])_r300")!)
                    } catch {
                        print("Error in data \(book.photos![0])")
                    }
                    self.bookList.append(book)
                }
                
                DispatchQueue.main.async {
                    print(self.bookList)
                    self.donatedCollectionView.reloadData()
                }
            })
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UserBookCollectionViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserBookCollectionViewCell
        
        let currBook = self.bookList[indexPath.row]
        cell.donatedBookName.text = currBook.book_name
        cell.donatedBookDate.text = currBook.postdts
        cell.donatedImage.image = UIImage(data: currBook.data!)
        cell.book = self.bookList[indexPath.row]
        if bookmarkList.contains(currBook.id!) {
            cell.favouriteBtn.setImage(UIImage(named: "favourite"), for: .normal)
        } else {
            cell.favouriteBtn.setImage(UIImage(named: "favourite-outline"), for: .normal)
        }
        
        return cell
    }
    
    
    func showSpinner() {
        spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        spinner.frame = self.view.frame
        spinner.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        spinner.alpha = 1.0
        self.view.addSubview(spinner)
        spinner.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        spinner.startAnimating()
    }
    
    func pushToUserMesssages(notification: NSNotification) {
        if let user = notification.userInfo?["user"] as? User {
            self.selectedUser = user
            spinner.stopAnimating()
            //self.performSegue(withIdentifier: "chatSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatSegue" {
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.selectedUser
        }
    }
    
    func bookmarkToggle(notification: NSNotification) {
        for v in notification.userInfo! {
            if (v.value as! Bool) {
                bookmarkList.append(v.key as! String)
            } else {
                if bookmarkList.contains(v.key as! String) {
                    bookmarkList.remove(at: bookmarkList.index(of: v.key as! String)!)
                }
            }
        }
        self.donatedCollectionView.reloadData()
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
