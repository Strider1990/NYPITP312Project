//
//  ISBNDataManager.swift
//  NYPITP312
//
//  Created by Ng Wan Ying on 1/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

//
//  ISBNDataManager.swift
//  FairpriceShareTextbook
//
//  Created by KIM FOONG CHOW on 28/5/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class ISBNDataManager: NSObject {
    
    //   var svc = ScannerViewController()
    
    static var success : Bool = false
    
    class func getISBNData(id : String, limit : String, onComplete: ((ISBN) -> Void)?){
        let url1 = "http://13.228.39.122/FP01_654265348176237/1.0/isbn/list"
        //  var success = false;
        
        //var i = ISBNDataManager()
        //ISBNDataManager.getISBNData(id: <#T##String#>, limit: <#T##String#>)
        
        if ISBNDataManager.success
        {
            // ...
        }
        
        HTTP.postJSON(url: url1,
                      json: JSON.init([
                        "id" : id,
                        "limit" : limit
                        
                        ]), onComplete: {
                            json, response, error in
                            
                            if json != nil {
                                print(json!)
                                
                                print(json![0]["name"])
                                print(json![0]["publisher"])
                                print(json![0]["edition"])
                                print(json![0]["author"])
                                print(json![0]["cateid"])
                                print(json![0]["id"])
                                
                                print("size of the array:  \(json!.count)")
                                var item = ISBN()
                                item.name  = json![0]["name"].string
                                item.publisher = json![0]["publisher"].string
                                item.id = json![0]["id"].string
                                item.author = json![0]["author"].string
                                item.edition = json![0]["edition"].string
                                //       item.cateid = [json![0]["cateid"].stringValue]
                                //  item.cateid = [String(describing: json![0]["cateid"])]
                                item.cateid.append(json![0]["cateid"][0].string!)
                                item.cateid.append(json![0]["cateid"][1].string!)
                                //  item.cateid = json![0]["cateid"][1].string
                                
                                
                                if onComplete != nil
                                {
                                    success = true;
                                    onComplete!(item)
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
