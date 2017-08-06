//
//  CategoryTableViewController.swift
//  NYPITP312
//
//  Created by Ng Wan Ying on 2/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

//
//  CategoryTableViewController.swift
//  FairpriceShareTextbook
//
//  Created by Ng Wan Ying on 19/6/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

var allCateObjectArr = [Category]()

protocol SendCategoryDelegate {
    func sendData(text:String)
    func populateData(firstTime: BooleanLiteralType)
    func storeCategory(categoryArray2: [Objects])
}

//struct Objects {
//
//    var sectionName : String!
//    var sectionObjects : [String]!
//}
//var nyan = [Objects]()

class CategoryTableViewController: UITableViewController {
    
    var delegate: SendCategoryDelegate?
    
    /*
     ======= TESTING ========
     var textbook : [String] = []
     var storybook : [String] = []
     var others : [String] = []
     var lastDateUpdate = Date()
     var startOfTheDay : BooleanLiteralType!
     var firstTime : BooleanLiteralType!
     var categoryArray = [Objects]()
     var category : [String: [String]] = [:]
     */
    var objectArray = [Objects]()
    
    
    
    /*
     var name = ["Textbooks": ["Tomato", "Potato", "Lettuce"], "Storybooks": ["Apple", "Banana"],
     "Others": []] */
    
    
    // and continue
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*    if (categoryArray.count != 0){
         firstTime = false
         }
         else{
         firstTime = true
         }
         print("ARRAY SIZE: \(objectArray.count)")
         let days=Calendar.current.dateComponents([.day], from: lastDateUpdate, to: Date())
         if (days.day != 0 ){
         startOfTheDay = true
         } else {
         startOfTheDay = false
         }
         
         print("LAST DATE UPDATE: \(lastDateUpdate)")
         print("DAYS DIFFERENCE : \(days.day!)")
         print("FIRST TIME : \(firstTime)")
         
         print(startOfTheDay)
         
         if (startOfTheDay || firstTime){
         
         let urlCategory = "http://13.228.39.122/FP01_654265348176237/1.0/category/list"
         
         HTTP.postJSON(url: urlCategory,
         json: JSON.init([
         "heading" : "Textbook",
         "limit" : "50"
         ]), onComplete: {
         json, response, error in
         
         if json != nil {
         print(json!)
         
         print(json![0]["id"])
         print(json![0]["displayorder"])
         print(json![0]["heading"])
         print(json![0]["name"])
         
         
         print("size of the array:  \(json!.count)")
         
         for var i in 0 ..< json!.count{
         self.textbook.append(json![i]["name"].string!)
         }
         
         HTTP.postJSON(url: urlCategory,
         json: JSON.init([
         "heading" : "Storybook",
         "limit" : "50"
         ]), onComplete: {
         json, response, error in
         
         if json != nil {
         print(json!)
         
         print(json![0]["id"])
         print(json![0]["displayorder"])
         print(json![0]["heading"])
         print(json![0]["name"])
         
         
         print("size of the array:  \(json!.count)")
         
         for var i in 0 ..< json!.count{
         self.storybook.append(json![i]["name"].string!)
         }
         
         
         HTTP.postJSON(url: urlCategory,
         json: JSON.init([
         "heading" : "Others",
         "limit" : "50"
         ]), onComplete: {
         json, response, error in
         
         if json != nil {
         print(json!)
         
         print(json![0]["id"])
         print(json![0]["displayorder"])
         print(json![0]["heading"])
         print(json![0]["name"])
         
         
         print("size of the array:  \(json!.count)")
         
         for var i in 0 ..< json!.count{
         self.others.append(json![i]["name"].string!)
         }
         
         self.category = [
         "Textbooks": self.textbook,
         "Storybooks": self.storybook,
         "Others" : self.others
         ]
         
         print(self.textbook.count)
         print(self.storybook.count)
         print(self.others.count)
         for (key, value) in self.category {
         print("\(key) -> \(value)")
         self.objectArray.append(Objects(sectionName: key, sectionObjects: value))
         
         self.categoryArray.append(Objects(sectionName: key, sectionObjects: value))
         
         self.delegate?.storeCategory(categoryArray: self.categoryArray)
         }
         self.firstTime = false;
         self.startOfTheDay = false;
         self.delegate?.populateData(firstTime: self.firstTime)
         
         DispatchQueue.main.async {
         //                                                                                    self.firstTime = false;
         //                                                                                    self.startOfTheDay = false;
         self.tableView.reloadData()
         }
         } else{
         print("failed api request")
         return
         }
         
         
         })
         
         } else{
         print("failed api request")
         return
         }
         })
         
         
         
         } else{
         print("failed api request")
         return
         }
         
         
         })
         
         } else {
         for var i in 0 ..< categoryArray.count {
         objectArray.append(Objects(sectionName: categoryArray[i].sectionName, sectionObjects: categoryArray[i].sectionObjects))
         }
         tableView.reloadData()
         }
         */
        
        
        
        if (objectArray.count != 0){
            CategoryDataManager.firstTime = false
        }
        else{
            CategoryDataManager.firstTime = true
        }
        print("ARRAY SIZE: \(objectArray.count)")
        let days=Calendar.current.dateComponents([.day], from: CategoryDataManager.lastDateUpdate, to: Date())
        if (days.day != 0 ){
            CategoryDataManager.startOfTheDay = true
        } else {
            CategoryDataManager.startOfTheDay = false
        }
        
        print("LAST DATE UPDATE: \(CategoryDataManager.lastDateUpdate)")
        print("DAYS DIFFERENCE : \(days.day!)")
        print("FIRST TIME : \(CategoryDataManager.firstTime)")
        
        print(CategoryDataManager.startOfTheDay)
        
        
        if (CategoryDataManager.startOfTheDay || CategoryDataManager.firstTime){
            
            CategoryDataManager.getCategory(heading: "Textbook", limit: "50", onComplete: {
                (txtbk: [Category], fictionbk: [Category], nonfictionbk: [Category],othersbk: [Category],data : [Objects]) in
                
                self.delegate?.storeCategory(categoryArray2: data)
                self.delegate?.populateData(firstTime: CategoryDataManager.firstTime)
                for var i in 0 ..< data.count {
                    
                    self.objectArray.append(Objects(sectionName: data[i].sectionName, sectionObjects: data[i].sectionObjects))
                    
                }
                for var i in 0 ..< txtbk.count {
                    
                    var cate = Category()
                    cate.name = txtbk[i].name
                    cate.id = txtbk[i].id
                    cate.heading = txtbk[i].heading
                    cate.displayOrder = txtbk[i].displayOrder
                    
                    allCateObjectArr.append(cate)
                    
                    
                    //   allCateObjectArr.append(txtbk)
                }
                for var i in 0 ..< fictionbk.count {
                    
                    
                    var cate1 = Category()
                    cate1.name = fictionbk[i].name
                    cate1.id = fictionbk[i].id
                    cate1.heading = fictionbk[i].heading
                    cate1.displayOrder = fictionbk[i].displayOrder
                    
                    allCateObjectArr.append(cate1)
                    
                }
                for var i in 0 ..< nonfictionbk.count {
                    
                    
                    var cate2 = Category()
                    cate2.name = nonfictionbk[i].name
                    cate2.id = nonfictionbk[i].id
                    cate2.heading = nonfictionbk[i].heading
                    cate2.displayOrder = nonfictionbk[i].displayOrder
                    
                    allCateObjectArr.append(cate2)
                    
                }
                
                for var i in 0 ..< othersbk.count {
                    
                    var cate3 = Category()
                    cate3.name = othersbk[i].name
                    cate3.id = othersbk[i].id
                    cate3.heading = othersbk[i].heading
                    cate3.displayOrder = othersbk[i].displayOrder
                    
                    allCateObjectArr.append(cate3)
                    
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
                
                
                
                
            })
        } else {
            tableView.reloadData()
            
        }
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    // MARK: - Table view data source
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row]
        
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectArray[section].sectionName
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)!
        
        print(currentCell.textLabel!.text!)
        self.delegate?.sendData(text: currentCell.textLabel!.text!)
        _ = navigationController?.popViewController(animated: true)
    }
    

    
}
