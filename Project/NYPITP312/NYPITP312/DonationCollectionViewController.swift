//
//  DonationCollectionViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 4/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

private let reuseIdentifier = "DonationCell"

class DonationCollectionViewController: UICollectionViewController {
    
    var bookList: [Book] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let par: RootNavViewController = self.parent as! RootNavViewController
        
        DispatchQueue.global(qos: .background).async {
            HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/posting/list", json: JSON.init(parseJSON: "{\"userid\": \"\(par.login.userId!)\", \"orderbypostdt\": \"asc\"}"), onComplete: {
                json, response, error in
                
                if json == nil
                {
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

                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            })
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(DonorBookCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        return self.bookList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DonorBookCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DonorBookCollectionViewCell
    
        // Configure the cell
        cell.donorBookName.text = self.bookList[indexPath.row].book_name!
        cell.donorBookDate.text = self.bookList[indexPath.row].postdts!
        cell.donorBookImg.image = UIImage(data: self.bookList[indexPath.row].data!)
        
        cell.book = self.bookList[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookSegue" {
            let bookView = segue.destination as! BookViewController
            let cell = sender as! BookCollectionViewCell
            let indexPath = self.collectionView!.indexPath(for: cell)
            bookView.book = self.bookList[(indexPath?.row)!]
        }
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
