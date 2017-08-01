//
//  CategoryDataManager.swift
//  NYPITP312
//
//  Created by Ng Wan Ying on 2/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

//
//  CategoryDataManager.swift
//  FairpriceShareTextbook
//
//  Created by Ng Wan Ying on 24/6/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

struct Objects {
    
    var sectionName : String!
    var sectionObjects : [String]!
}


class CategoryDataManager: NSObject {
    
    // var ctvc = CategoryTableViewController()
    //var nyan = [Objects]()
    
    static var firstTime : Bool!
    static var startOfTheDay : Bool!
    static var lastDateUpdate = Date()
    
    static var firstTimeLevel : Bool!
    static var startOfTheDayLevel : Bool!
    static var lastDateUpdateLevel = Date()
    
    
    
    //  class func getCategory(heading : String, limit : String, onComplete: (([Objects]) -> Void)?){
    
    class func getCategory(heading : String, limit : String, onComplete: (([Category], [Category],[Category],[Category],[Objects]) -> Void)?){
        
        
        var textbook : [Category] = []
        var fiction : [Category] = []
        var nonfiction : [Category] = []
        var others : [Category] = []
        //        var lastDateUpdate = Date()
        
        
        //  var categoryArray = [Objects]()
        var category : [String: [String]] = [:]
        var objectArray = [Objects]()
        
        /*
         
         if (objectArray.count != 0){
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
         
         */
        
        
        
        
        
        let urlCategory = "http://13.228.39.122/FP01_654265348176237/1.0/category/list"
        
        //        var textbook : [String] = []
        //             var storybook : [String] = []
        //             var others : [String] = []
        //            var category : [String: [String]] = [:]
        //
        //           var objectArray = [Objects]()
        
        
        
        
        HTTP.postJSON(url: urlCategory,
                      json: JSON.init([
                        "heading" : heading,
                        "limit" : limit
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
                                    
                                    //   textbook.append(json![i]["name"].string!)
                                    var cate = Category()
                                    cate.displayOrder = json![i]["displayorder"].string!
                                    cate.name = json![i]["name"].string!
                                    cate.id = json![i]["id"].string!
                                    cate.heading = json![i]["heading"].string!
                                    textbook.append(cate)
                                    print("Textbook count \(textbook.count)")
                                    //        self.ctvc.textbook.append(json![i]["name"].string!)
                                }
                                
                                HTTP.postJSON(url: urlCategory,
                                              json: JSON.init([
                                                "heading" : "Fiction",
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
                                                            //      storybook.append(json![i]["name"].string!)
                                                            //  self.storybook.append(json![i]["name"].string!)
                                                            var cate = Category()
                                                            cate.displayOrder = json![i]["displayorder"].string!
                                                            cate.name = json![i]["name"].string!
                                                            cate.id = json![i]["id"].string!
                                                            cate.heading = json![i]["heading"].string!
                                                            fiction.append(cate)
                                                            print("storybook count \(fiction.count)")
                                                        }
                                                        HTTP.postJSON(url: urlCategory,
                                                                      json: JSON.init([
                                                                        "heading" : "Non-fiction",
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
                                                                                    
                                                                                    var cate = Category()
                                                                                    cate.displayOrder = json![i]["displayorder"].string!
                                                                                    cate.name = json![i]["name"].string!
                                                                                    cate.id = json![i]["id"].string!
                                                                                    cate.heading = json![i]["heading"].string!
                                                                                    nonfiction.append(cate)
                                                                                    print("storybook count \(nonfiction.count)")
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
                                                                                                            //     others.append(json![i]["name"].string!)
                                                                                                            var cate = Category()
                                                                                                            cate.displayOrder = json![i]["displayorder"].string!
                                                                                                            cate.name = json![i]["name"].string!
                                                                                                            cate.id = json![i]["id"].string!
                                                                                                            cate.heading = json![i]["heading"].string!
                                                                                                            others.append(cate)
                                                                                                            print("others count \(others.count)")
                                                                                                            
                                                                                                        }
                                                                                                        
                                                                                                        if onComplete != nil
                                                                                                        {
                                                                                                            var txtArr : [String] = []
                                                                                                            var fictionArr : [String] = []
                                                                                                            var nonfictionArr : [String] = []
                                                                                                            var otherArr : [String] = []
                                                                                                            for var i in 0..<textbook.count{
                                                                                                                txtArr.append(textbook[i].name!)
                                                                                                            }
                                                                                                            for var i in 0..<fiction.count{
                                                                                                                fictionArr.append(fiction[i].name!)
                                                                                                            }
                                                                                                            for var i in 0..<nonfiction.count{
                                                                                                                nonfictionArr.append(nonfiction[i].name!)
                                                                                                            }
                                                                                                            for var i in 0..<others.count{
                                                                                                                otherArr.append(others[i].name!)
                                                                                                            }
                                                                                                            
                                                                                                            category = [
                                                                                                                "Textbooks": txtArr,
                                                                                                                "Fiction": fictionArr,
                                                                                                                "Non-fiction": nonfictionArr,
                                                                                                                "Others" : otherArr
                                                                                                            ]
                                                                                                            
                                                                                                            for (key, value) in category {
                                                                                                                print("\(key) -> \(value)")
                                                                                                                objectArray.append(Objects(sectionName: key, sectionObjects: value))
                                                                                                            }
                                                                                                            onComplete!(textbook, fiction, nonfiction, others,objectArray)
                                                                                                            
                                                                                                            firstTime = false
                                                                                                            startOfTheDay = false
                                                                                                        }
                                                                                                        /*
                                                                                                         category = [
                                                                                                         "Textbooks": textbook,
                                                                                                         "Storybooks": storybook,
                                                                                                         "Others" : others
                                                                                                         ]
                                                                                                         
                                                                                                         print(textbook.count)
                                                                                                         print(storybook.count)
                                                                                                         print(others.count)
                                                                                                         for (key, value) in category {
                                                                                                         print("\(key) -> \(value)")
                                                                                                         objectArray.append(Objects(sectionName: key, sectionObjects: value))
                                                                                                         
                                                                                                         self.nyan.append(Objects(sectionName: key, sectionObjects: value))
                                                                                                         }
                                                                                                         
                                                                                                         DispatchQueue.main.async {
                                                                                                         
                                                                                                         var ctvc = CategoryTableViewController()
                                                                                                         ctvc.firstTime = false;
                                                                                                         ctvc.startOfTheDay = false;
                                                                                                         ctvc.tableView.reloadData()
                                                                                                         }
                                                                                                         */
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
                                
                                
                                
                                
                            } else{
                                print("failed api request")
                                return
                            }
                            
        })
        
    }
    
    
    
    
    
    
    /* ============= TESTING IN PROGRESS ==============
     let urlCategory = "http://13.228.39.122/FP01_654265348176237/1.0/category/list"
     
     //        var textbook : [String] = []
     //             var storybook : [String] = []
     //             var others : [String] = []
     //            var category : [String: [String]] = [:]
     //
     //           var objectArray = [Objects]()
     
     
     
     
     HTTP.postJSON(url: urlCategory,
     json: JSON.init([
     "heading" : heading,
     "limit" : limit
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
     
     //   textbook.append(json![i]["name"].string!)
     var cate = Category()
     cate.displayOrder = json![i]["displayorder"].string!
     cate.name = json![i]["name"].string!
     cate.id = json![i]["id"].string!
     cate.heading = json![i]["heading"].string!
     textbook.append(cate)
     print("Textbook count \(textbook.count)")
     //        self.ctvc.textbook.append(json![i]["name"].string!)
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
     //      storybook.append(json![i]["name"].string!)
     //  self.storybook.append(json![i]["name"].string!)
     var cate = Category()
     cate.displayOrder = json![i]["displayorder"].string!
     cate.name = json![i]["name"].string!
     cate.id = json![i]["id"].string!
     cate.heading = json![i]["heading"].string!
     storybook.append(cate)
     print("storybook count \(storybook.count)")
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
     //     others.append(json![i]["name"].string!)
     var cate = Category()
     cate.displayOrder = json![i]["displayorder"].string!
     cate.name = json![i]["name"].string!
     cate.id = json![i]["id"].string!
     cate.heading = json![i]["heading"].string!
     others.append(cate)
     print("others count \(others.count)")
     
     }
     
     if onComplete != nil
     {
     var txtArr : [String] = []
     var storyArr : [String] = []
     var otherArr : [String] = []
     for var i in 0..<textbook.count{
     txtArr.append(textbook[i].name!)
     }
     for var i in 0..<storybook.count{
     storyArr.append(storybook[i].name!)
     }
     
     for var i in 0..<others.count{
     otherArr.append(others[i].name!)
     }
     
     category = [
     "Textbooks": txtArr,
     "Storybooks": storyArr,
     "Others" : otherArr
     ]
     
     for (key, value) in category {
     print("\(key) -> \(value)")
     objectArray.append(Objects(sectionName: key, sectionObjects: value))
     }
     onComplete!(objectArray)
     
     firstTime = false
     startOfTheDay = false
     }
     /*
     category = [
     "Textbooks": textbook,
     "Storybooks": storybook,
     "Others" : others
     ]
     
     print(textbook.count)
     print(storybook.count)
     print(others.count)
     for (key, value) in category {
     print("\(key) -> \(value)")
     objectArray.append(Objects(sectionName: key, sectionObjects: value))
     
     self.nyan.append(Objects(sectionName: key, sectionObjects: value))
     }
     
     DispatchQueue.main.async {
     
     var ctvc = CategoryTableViewController()
     ctvc.firstTime = false;
     ctvc.startOfTheDay = false;
     ctvc.tableView.reloadData()
     }
     */
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
     }
     */
    
    
    
    
    
    class func getCourseLevel(heading : String, limit : String, onComplete: (([Category]) -> Void)?){
        
        let urlCategory = "http://13.228.39.122/FP01_654265348176237/1.0/category/list"
        
        var levelArr : [Category] = []
        
        HTTP.postJSON(url: urlCategory,
                      json: JSON.init([
                        "heading" : heading,
                        "limit" : limit
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
                                    var level = Category()
                                    level.displayOrder = json![i]["displayorder"].string!
                                    level.name = json![i]["name"].string!
                                    level.id = json![i]["id"].string!
                                    level.heading = json![i]["heading"].string!
                                    levelArr.append(level)
                                }
                                
                                if onComplete != nil
                                {
                                    onComplete!(levelArr)
                                    firstTimeLevel = false
                                    startOfTheDayLevel = false
                                }
                                
                            } else{
                                print("failed api request")
                                return
                            }
                            
        })
        
    }
    
    class func getCateid(name : String, limit : String, onComplete: ((Category) -> Void)?){
        let urlCategory = "http://13.228.39.122/FP01_654265348176237/1.0/category/list"
        
        
        var cate = Category()
        
        HTTP.postJSON(url: urlCategory,
                      json: JSON.init([
                        "name" : name,
                        "limit" : limit
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
                                    
                                    if json != nil {
                                        
                                        cate.displayOrder = json!["displayorder"].string
                                        cate.name = json![i]["name"].string
                                        cate.id = json![i]["id"].string
                                        cate.heading = json![i]["heading"].string
                                        
                                    }
                                }
                                
                                if onComplete != nil
                                {
                                    onComplete!(cate)
                                }
                                
                            } else{
                                print("failed api request")
                                return
                            }
                            
        })
        
    }
    
    
}
