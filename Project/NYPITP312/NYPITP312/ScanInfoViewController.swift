//
//  ScanInfoViewController.swift
//  NYPITP312
//
//  Created by Ng Wan Ying on 2/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

//
//  ScanInfoViewController.swift
//  FairpriceShareTextbook
//
//  Created by Ng Wan Ying on 17/7/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Eureka

protocol SendBook2Delegate {
    func sendData(data: Posting)
}

class ScanInfoViewController: FormViewController{
    
    
    var delegate: SendBook2Delegate?
    var bDesc : String!
    
    override func viewWillAppear(_ animated: Bool) {
        
        //        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ScanInfoViewController.btnDone))
        //        self.parent?.navigationItem.rightBarButtonItem = done
        
        //  self.parent?.navigationItem.title = "Donate"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        form
            +++ Section("Book details")
            <<< TextRow("bookName"){ row in
                row.title = "Book Name"
                row.placeholder = "Enter book name"
                row.value = bookName
                row.disabled = true
            }
            
            <<< TextRow("isbn"){ row in
                row.title = "ISBN"
                row.placeholder = "Enter book ISBN"
                row.value = bookISBN
                row.disabled = true
            }
            <<< TextRow("author"){ row in
                row.title = "Author"
                row.placeholder = "Enter book author name"
                row.value = bookAuthor
                row.disabled = true
            }
            <<< TextRow("publisher"){ row in
                row.title = "Publisher"
                row.placeholder = "Enter book publisher name"
                row.value = bookPublisher
                row.disabled = true
            }
            
            <<< TextRow("edition"){ row in
                row.title = "Edition"
                row.placeholder = "Enter book edition"
                row.value = bookEdition
                row.disabled = true
            }
            
            +++ Section("Book Condition")
            //            <<< PickerInlineRow<String>("condition") {
            //                  print("testing")
            //                $0.title = "Condition"
            //                $0.options = ["1/10", "2/10", "3/10", "4/10", "5/10", "6/10", "7/10", "8/10","9/10", "10/10"]
            //                $0.value = "10/10"
            //
            //
            //        }
            <<< PickerInputRow<String>("condition"){
                $0.title = "Condition"
                var options = ["1/10", "2/10", "3/10", "4/10", "5/10", "6/10", "7/10", "8/10","9/10", "10/10"]
                $0.options = []
                for i in options {
                    $0.options.append(i)
                }
                $0.value = $0.options.last
                if PostingDataManager.userBookDataExist == true {
                    $0.value = bDesc
                }
        }
        
        
        print("testing2")
        
        // Do any additional setup after loading the view.
    }
    
    /*
     @IBAction func donePressed(_ sender: UIBarButtonItem) {
     
     //        let row: TextRow? = form.rowBy(tag: "bookName")
     //        let bookN = row?.value
     //        print("VALUE \(bookN!)")
     //        let row1: TextRow? = form.rowBy(tag: "author")
     //        let bookA = row1?.value
     //        let row2: TextRow? = form.rowBy(tag: "author")
     //        let bookP = row2?.value
     let bookForm = form.values()
     var p1 = Posting()
     //        p1.name = bookN
     //        p1.author = bookA
     
     print(bookForm)
     p1.name = bookForm["bookName"] as? String
     p1.isbn = bookForm["isbn"] as? String
     p1.author = bookForm["author"] as? String
     p1.publisher = bookForm["publisher"] as? String
     p1.edition = bookForm["edition"] as? String
     p1.desc = bookForm["condition"] as? String
     
     self.delegate?.sendData(data: p1)
     print(p1.publisher!)
     print(p1.name!)
     print(p1.author!)
     
     _ = navigationController?.popViewController(animated: true)
     }
     */
    
    func btnDone() {
        // Perform segue to profile editing
        
        let bookForm = form.values()
        var p1 = Posting()
        //        p1.name = bookN
        //        p1.author = bookA
        
        print(bookForm)
        p1.name = bookForm["bookName"] as? String
        p1.isbn = bookForm["isbn"] as? String
        p1.author = bookForm["author"] as? String
        p1.publisher = bookForm["publisher"] as? String
        p1.edition = bookForm["edition"] as? String
        p1.desc = bookForm["condition"] as? String
        
        
        self.delegate?.sendData(data: p1)
        print(p1.publisher!)
        print(p1.name!)
        print(p1.author!)
        
        _ = navigationController?.popViewController(animated: true)
        
        
    }
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        btnDone()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
