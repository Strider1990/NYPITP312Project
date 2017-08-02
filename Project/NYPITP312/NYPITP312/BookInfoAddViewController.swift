//
//  BookInfoAddViewController.swift
//  NYPITP312
//
//  Created by Ng Wan Ying on 2/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

//
//  BookInfoAddViewController.swift
//  FairpriceShareTextbook
//
//  Created by Ng Wan Ying on 21/6/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Eureka

protocol SendBookDelegate {
    func sendData(data: Posting)
}

class BookInfoAddViewController: FormViewController {
    
    var delegate: SendBookDelegate?
    
    var asd : String?
    var bName : String!
    var bISBN : String!
    var bAuthor : String!
    var bPublisher : String!
    var bEdition : String!
    var bDesc : String!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(asd!)
        
        
        
        form
            
            +++ Section("Book details")
            <<< NameRow("bookName"){ row in
                row.title = "Book Name"
                row.placeholder = "Enter book name"
                row.add(rule: RuleRequired(msg:"This field is mandatory"))
                row.validationOptions = .validatesOnChangeAfterBlurred
                if PostingDataManager.userBookDataExist == true {
                    row.value = bName
                }
                
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                //                                if validationMsg.characters.count != 0 {
                                //                                    self.validationStr = validationMsg
                                //                                }else {
                                //                                    self.validationStr = ""
                                //                                }
                                print((row.section?.form?.validate().count)!)
                                //                                if (row.section?.form?.validate().count)! == 0{
                                //                                    self.validatedBN = true
                                //                                }else {
                                //                                    self.validatedBN = false
                                //                                }
                                $0.cell.height = { 30 }
                                }.cellUpdate { cell, row in
                                    cell.textLabel?.textColor = UIColor(red: 0.251, green: 0.1608, blue: 0.5255, alpha: 1.0)
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            <<< TextRow("isbn"){ row in
                row.title = "ISBN"
                row.placeholder = "Enter book ISBN"
                row.add(rule: RuleRequired(msg:"ISBN should be 13 letters long"))
                //      row.add(ruleSet: RuleMinLength(minLength: 13))
                row.add(rule: RuleMinLength(minLength: 13))
                row.validationOptions = .validatesOnChangeAfterBlurred
                if PostingDataManager.userBookDataExist == true {
                    row.value = bISBN
                }
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                //                                if validationMsg.characters.count != 0 {
                                //                                    self.validationStr = validationMsg
                                //                                }else {
                                //                                    self.validationStr = ""
                                //                                }
                                print((row.section?.form?.validate().count)!)
                                //                                if (row.section?.form?.validate().count)! == 0{
                                //                                    self.validatedBISBN = true
                                //                                }else {
                                //                                    self.validatedBISBN = false
                                //                                }
                                $0.cell.height = { 30 }
                                }.cellUpdate { cell, row in
                                    cell.textLabel?.textColor = UIColor(red: 0.251, green: 0.1608, blue: 0.5255, alpha: 1.0)
                            }
                            
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            <<< NameRow("author"){ row in
                row.title = "Author"
                row.placeholder = "Enter book author name"
                row.add(rule: RuleRequired(msg:"This field is mandatory"))
                row.validationOptions = .validatesOnChangeAfterBlurred
                if PostingDataManager.userBookDataExist == true {
                    row.value = bAuthor
                }
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                //                                if validationMsg.characters.count != 0 {
                                //                                    self.validationStr = validationMsg
                                //                                }else {
                                //                                    self.validationStr = ""
                                //                                }
                                
                                //                                print((row.section?.form?.validate().count)!)
                                //                                if (row.section?.form?.validate().count)! == 0{
                                //                                    self.validatedBA = true
                                //                                }else {
                                //                                    self.validatedBA = false
                                //                                }
                                print((row.section?.form?.validate().count)!)
                                $0.cell.height = { 30 }
                                }.cellUpdate { cell, row in
                                    cell.textLabel?.textColor = UIColor(red: 0.251, green: 0.1608, blue: 0.5255, alpha: 1.0)
                            }
                            
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            <<< NameRow("publisher"){ row in
                row.title = "Publisher"
                row.placeholder = "Enter book publisher name"
                row.add(rule: RuleRequired(msg:"This field is mandatory"))
                row.validationOptions = .validatesOnChangeAfterBlurred
                if PostingDataManager.userBookDataExist == true {
                    row.value = bPublisher
                }
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                //                                if validationMsg.characters.count != 0 {
                                //                                    self.validationStr = validationMsg
                                //                                }else {
                                //                                    self.validationStr = ""
                                //                                }
                                
                                //                                if (row.section?.form?.validate().count)! == 0{
                                //                                    self.validatedBP = true
                                //                                }
                                //                                else {
                                //                                    self.validatedBP = false
                                //                                }
                                print((row.section?.form?.validate().count)!)
                                $0.cell.height = { 30 }
                                }.cellUpdate { cell, row in
                                    cell.textLabel?.textColor = UIColor(red: 0.251, green: 0.1608, blue: 0.5255, alpha: 1.0)
                            }
                            
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            
            <<< NameRow("edition"){ row in
                row.title = "Edition"
                row.placeholder = "Enter book edition"
                row.add(rule: RuleRequired(msg:"This field is mandatory"))
                row.validationOptions = .validatesOnChangeAfterBlurred
                if PostingDataManager.userBookDataExist == true {
                    row.value = bName
                }
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                //                                if validationMsg.characters.count != 0 {
                                //                                    self.validationStr = validationMsg
                                //                                }else {
                                //                                    self.validationStr = ""
                                //                                }
                                
                                //                                if (row.section?.form?.validate().count)! == 0{
                                //                                    self.validatedBE = true
                                //                                }else {
                                //                                    self.validatedBE = false
                                //                                }
                                
                                $0.cell.height = { 30 }
                                }.cellUpdate { cell, row in
                                    cell.textLabel?.textColor = UIColor(red: 0.251, green: 0.1608, blue: 0.5255, alpha: 1.0)
                            }
                            
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            +++ Section("Book Condition")
            <<< PickerInlineRow<String>("condition") {
                $0.title = "Condition"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChangeAfterBlurred
                $0.options = ["1/10", "2/10", "3/10", "4/10", "5/10", "6/10", "7/10", "8/10","9/10", "10/10"]
                $0.value = "10/10"
                if PostingDataManager.userBookDataExist == true {
                    $0.value = bDesc
                }
        }
        
        
        
        //
        //        let row: TextRow? = form.rowBy(tag: "bookName")
        //        let value = row?.value
        //        print("VALUE \(value)")
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        
        //        let row: TextRow? = form.rowBy(tag: "bookName")
        //        let bookN = row?.value
        //        print("VALUE \(bookN!)")
        //        let row1: TextRow? = form.rowBy(tag: "author")
        //        let bookA = row1?.value
        //        let row2: TextRow? = form.rowBy(tag: "author")
        //        let bookP = row2?.value
        form.validate()
        //        print(validationStr.characters.count)
        //        print(validationStr)
        //        print("book name \(validatedBN)")
        //        print("book isbn \(validatedBISBN)")
        //        print("book author \(validatedBA)")
        //        print("book publisher \(validatedBP)")
        //        print("book edition \(validatedBE)")
        
        
        // if validationStr.characters.count == 0 {
        //         if validatedBN == true && validatedBISBN == true && validatedBA == true && validatedBP == true && validatedBE == true {
        if (form.validate().count) == 0{
            
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
