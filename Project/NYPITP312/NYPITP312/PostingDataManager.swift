//
//  PostingDataManager.swift
//  NYPITP312
//
//  Created by Ng Wan Ying on 2/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

//
//  PostingDataManager.swift
//  FairpriceShareTextbook
//
//  Created by KIM FOONG CHOW on 28/5/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class PostingDataManager: NSObject {
    
    static var userToken : String!
    
    static var userBookDataExist : Bool = false
    static var userCategoryDataExist : Bool = false
    static var userCourselevelDataExist : Bool = false
    static var userPictureDataExist : Bool = false
    
    class func createPostingData(token: String,cateid: [String],name: String,isbn: String, desc: String,
                                 author: String, publisher: String, edition: String,
                                 photos: [String],loc: String, tags: String, onComplete: (() -> Void)?){
        let url = "http://13.228.39.122/FP01_654265348176237/1.0/posting/add"
        
        
        if ISBNDataManager.success
        {
            // ...
        }
        
        HTTP.postJSON(url: url,
                      json: JSON.init([
                        "token" : token,
                        "cateid" : cateid,
                        "name" : name,
                        "isbn" : isbn,
                        "desc" : desc,
                        "author" :author,
                        "publisher" : publisher,
                        "edition" : edition,
                        "photos": photos,
                        "preferredloc" : "Bedok MRT",
                        "tags" : "English"
                        
                        ]), onComplete: {
                            json, response, error in
                            
                            if json != nil {
                                
                                print(json!)
                                
                                print(json!["success"].string!)
                                print(json!["id"].string!)
                                
                                
                                
                                print("size of the array:  \(json!.count)")
                                
                                
                                if onComplete != nil
                                {
                                    
                                    onComplete!(print("success"))
                                    
                                }
                                
                                /*       DispatchQueue.main.async {
                                 self.svc.detectLabel.text = "Book Name: \(item.name!) Book Publisher: \(item.publisher) Book Edition: \(item.edition) Book ISBN: \(item.id)"
                                 
                                 //     success = true;
                                 
                                 
                                 if success {
                                 
                                 let scanConfirmVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scanConfirmVC") as! ScanConfirmViewController
                                 self.svc.navigationController?.pushViewController(scanConfirmVC, animated: true)
                                 
                                 
                                 }
                                 
                                 } */
                            } else{
                                print("failed api request")
                                return
                            }
                            
                            
        })
    }
    
}
