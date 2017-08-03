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
    
    @IBOutlet weak var userPhoto: UIImageView!
    
    var bookList: [Book] = []
    @IBOutlet weak var donatedCollectionView: UICollectionView!
    var par: RootNavViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        par = self.parent as! RootNavViewController
        self.userPhoto.layer.cornerRadius = self.userPhoto.frame.width / 2
        self.navigationItem.title = self.name!
        
        DispatchQueue.global(qos: .background).async {
            HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/user/get", json: JSON.init(parseJSON: "{\"id\": \"\(self.id!)\", \"token\": \"\(self.par.login.token!)\"}"), onComplete: {
                json, response, error in
                
                if json == nil
                {
                    return
                }
                
                DispatchQueue.main.async {
                    self.par?.navigationItem.title = json!["name"].string ?? "No name"
                    do {
                        if let photoStr = json!["photo"].string {
                            let data = try Data(contentsOf: URL(string: "http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=users/\(photoStr)_c150")!)
                            self.userPhoto.image = UIImage(data: data)
                        } else {
                            self.userPhoto.image = UIImage(named: "profile")
                        }
                    } catch {
                        print("Error in data \(json!["photo"].string!)")
                    }
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
        
        cell.donatedBookName.text = self.bookList[indexPath.row].book_name
        cell.donatedBookDate.text = self.bookList[indexPath.row].postdts
        cell.donatedImage.image = UIImage(data: self.bookList[indexPath.row].data!)
        
        return cell
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
