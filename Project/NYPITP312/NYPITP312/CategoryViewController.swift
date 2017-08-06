//
//  CategoryViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 29/7/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class CategoryViewController: UICollectionViewController {

    let reuseIdentifier = "BookCell"
    var category: Category?
    var categories: [String: [Category]] = [:]
    var bookList: [Book] = []
    @IBOutlet var bookCollectionView: UICollectionView!
    var selectedUser: User!
    var bookmarkList: [String] = []
    var nav: RootNavViewController!
    
    var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        nav = self.parent as! RootNavViewController
        var key: String
        key = Array(categories.keys)[0]
        bookList = []
        bookmarkList = UserDefaults.standard.stringArray(forKey: "bookmarks") ?? [String]()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushToUserMesssages(notification:)), name: NSNotification.Name(rawValue: "showUserMessages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinner), name: NSNotification.Name(rawValue: "showSpinner"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.bookmarkToggle(notification:)), name: NSNotification.Name(rawValue: "bookmarkToggle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loginNeeded), name: NSNotification.Name(rawValue: "loginNeeded"), object: nil)
        
        self.navigationItem.title = key
        
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        spinner.frame = self.view.frame
        spinner.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        spinner.alpha = 1.0
        self.view.addSubview(spinner)
        spinner.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        spinner.startAnimating()
        
        DispatchQueue.global(qos: .background).async {
            var catIds: [String] = []
            catIds.append((self.category?.id)!)
            
            //let cats: [Category] = self.categories[key]!
            
            print(JSON.init(parseJSON: "{\"cateid\": \(catIds), \"page\": \"0\", \"limit\": \"20\"}"))
            HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/posting/list", json: JSON.init(parseJSON: "{\"cateid\": \(catIds), \"page\": \"0\", \"limit\": \"20\"}"), onComplete:
                {
                    json, response, error in
                    
                    if json == nil {
                        return
                    }
                    
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
                    
                    // http://<server ip addr or name>/fpsatimgdev/loadimage.aspx?q=postings/filepath_r300
                    DispatchQueue.main.async {
                        spinner.stopAnimating()
                        self.bookCollectionView.reloadData()
                    }
                })
        }
        //background post JSON retrieve postingms
        //list postings as cells
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BookCollectionViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookCollectionViewCell
        
        let currBook: Book = bookList[indexPath.row]
        //print(currBook.id!)
        //cell.layer.backgroundColor = UIColor.black.cgColor
        cell.bookName.text = currBook.book_name
        cell.bookDate.text = currBook.postdts
        if let data = currBook.data {
            cell.bookImg.image = UIImage(data: data)
        }
        //cell.categoryLabel.textColor = UIColor.white
        cell.book = currBook
        if bookmarkList.contains(currBook.id!) {
            cell.favouriteButton.setImage(UIImage(named: "favourite"), for: .normal)
        } else {
            cell.favouriteButton.setImage(UIImage(named: "favourite-outline"), for: .normal)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookSegue" {
            let bookView = segue.destination as! BookViewController
            let cell = sender as! BookCollectionViewCell
            let indexPath = self.bookCollectionView.indexPath(for: cell)
            bookView.book = self.bookList[(indexPath?.row)!]
            
        } else if segue.identifier == "chatSegue" {
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.selectedUser
        }
    }
    
    func loginNeeded() {
        performSegue(withIdentifier: "LoginSegue", sender: self)
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
            self.performSegue(withIdentifier: "chatSegue", sender: self)
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
        self.bookCollectionView.reloadData()
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
