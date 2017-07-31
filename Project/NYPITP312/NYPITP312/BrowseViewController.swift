//
//  BrowseViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 5/7/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseIdentifier = "browseCollectionCell"
    
    @IBOutlet weak var browseCollectionView: UICollectionView!
    
    var categoryList: [Category] = []
    var bookCatList: [String: [Category]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.navigationItem.title = "Browse"
        
        DispatchQueue.global(qos: .background).async {
            HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/category/list", json: JSON.init(parseJSON: "{\"heading\": \"Category\"}"), onComplete:
                {
                    json, response, error in
                    if json == nil
                    {
                        return
                    }
                    
                    for (_, v) in json! {
                        let cat: Category = Category()
                        cat.catId = v["id"].string!
                        cat.heading = v["heading"].string!
                        cat.name = v["name"].string!
                        self.categoryList.append(cat)
                    }
                    
                    DispatchQueue.main.async {
                        self.browseCollectionView.reloadData()
                    }
                    
                    for cat in self.categoryList {
                        HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/category/list", json: JSON.init(parseJSON: "{\"heading\": \"\(cat.name!)\"}"), onComplete:
                            {
                                json, response, error in
                                if json == nil {
                                    return
                                }
                                
                                // Store into booklist variable
                                var tempCatList: [Category] = []
                                for (_, v) in json! {
                                    let bookCat: Category = Category()
                                    bookCat.catId = v["id"].string!
                                    bookCat.heading = v["heading"].string!
                                    bookCat.name = v["name"].string!
                                    tempCatList.append(bookCat)
                                }
                                self.bookCatList[cat.name!] = tempCatList
                        })
                    }
            })
        }
        // Do any additional setup after loading the view.
        let par: RootNavViewController = self.parent?.parent as! RootNavViewController
        par.categoryList = self.categoryList
        
        HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/posting/add", json: JSON.init(parseJSON: "{\"token\"}"), onComplete:
            {
                json, response, error in
                if json == nil {
                    return
                }
        })

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let catView = segue.destination as! CategoryViewController
        let cell = sender as! BrowseCollectionViewCell
        
        for i in 0..<categoryList.count {
            if categoryList[i].name == cell.categoryLabel.text! {
                catView.category = categoryList[i]
            }
        }
        catView.categories[cell.categoryLabel.text!] = bookCatList[cell.categoryLabel.text!]!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BrowseCollectionViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BrowseCollectionViewCell
        
        cell.layer.backgroundColor = UIColor.black.cgColor
        cell.categoryLabel.text = categoryList[indexPath.row].name
        cell.categoryLabel.textColor = UIColor.white
        
        
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
