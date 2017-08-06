//
//  BookmarkCollectionViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 6/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

private let reuseIdentifier = "BookmarkCell"

class BookmarkCollectionViewController: UICollectionViewController {

    var nav: RootNavViewController!
    var bookmarkList: [Book] = []
    var bookmarks: [String] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nav = self.parent as! RootNavViewController
        bookmarks = UserDefaults.standard.stringArray(forKey: "bookmarks") ?? [String]()
        
        let myGroup = DispatchGroup()
        
        for bookmark in bookmarks {
            myGroup.enter()
            HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/posting/get", json: JSON.init(parseJSON: "{\"id\": \"\(bookmark)\" }"), onComplete: {
                json, response, error in
                
                if json == nil
                {
                    return
                }
                
                print(json!)
                
                let book: Book = Book()
                book.id = json!["id"].string!
                book.donor = json!["by"].string ?? "No Donor"
                book.donor_id = json!["byid"].string ?? "No Donor ID"
                book.isbn = json!["isbn"].string!
                book.postdt = json!["postdt"].int!
                book.postdts = json!["postdts"].string!
                book.book_name = json!["name"].string!
                book.author = json!["author"].string!
                book.publisher = json!["publisher"].string!
                book.edition = json!["edition"].string!
                book.photos = json!["photos"].arrayValue.map {$0.stringValue}
                book.cateid = json!["cateid"].arrayValue.map {$0.stringValue}
                book.status = json!["status"].string ?? "No Status"
                book.desc = json!["desc"].string!
                book.preferredLoc = json!["preferredLoc"].string ?? "No Preferred Loc"
                do {
                    try book.data = Data(contentsOf: URL(string: "http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=postings/\(book.photos![0])_r300")!)
                } catch {
                    print("Error in data \(book.photos![0])")
                }
                self.bookmarkList.append(book)
                print(book.book_name!)
                
                myGroup.leave()
            })
            
            myGroup.notify(queue: DispatchQueue.main, execute: {
                print("My group left")
                self.collectionView?.reloadData()
            })
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return bookmarkList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BookCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookCollectionViewCell
    
        // Configure the cell
        let currBook = bookmarkList[indexPath.row]
        cell.book = currBook
        cell.bookName.text = currBook.book_name
        cell.bookId = currBook.id
        if let data = currBook.data {
            cell.bookImg.image = UIImage(data: data)
        }
        cell.bookDate.text = currBook.postdts
        if bookmarks.contains(currBook.id!) {
            cell.favouriteButton.setImage(UIImage(named: "favourite"), for: .normal)
        } else {
            cell.favouriteButton.setImage(UIImage(named: "favourite-outline"), for: .normal)
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
