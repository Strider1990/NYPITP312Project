//
//  ManualAddViewController.swift
//  NYPITP312
//
//  Created by Ng Wan Ying on 2/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

//
//  ManualAddViewController.swift
//  FairpriceShareTextbook
//
//  Created by Ng Wan Ying on 14/6/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
//import Eureka
//import QuartzCore
import iCarousel
import SCLAlertView
import Alamofire


var categoryArray = [Objects]()


// var firstTime : BooleanLiteralType = true

class ManualAddViewController: UIViewController, SendCategoryDelegate, SendBookDelegate, SendLevelDelegate, iCarouselDataSource, iCarouselDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var courselevelBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    
    @IBOutlet weak var bookBtn: UIButton!
    
    @IBOutlet var postBtn: UIButton!
    
    
    @IBOutlet weak var courselevelLbl: UILabel!
    @IBOutlet weak var bookLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    var firstTimee : BooleanLiteralType = false
    var firstTimeeLevel : Bool = false
    
    
    var itemView: UIImageView!
    var pictures: [UIImage?] = []
    
    //var filePath: [String] = []
    var filePath = [String]()
    var tempCateid : String!
    var tempLevelid : String!
    var tempOverallCateid : String!
    
    var postItem : Posting?
    
    var pname : String = ""
    var pisbn : String = ""
    var ppub : String = ""
    var pauthor : String = ""
    var pedit : String = ""
    var pdesc : String = ""
    
    var success : Bool = false;
    
    
    
    //    @IBOutlet var itemView: UIImageView!
    
    //    @IBOutlet var tapBtn: UIButton!
    //@IBOutlet weak var itemView: UIImageView!
    
    
    
    //@IBOutlet weak var view: UIView!
    /*
     
     var textbook : [String] = []
     var storybook : [String] = []
     var others : [String] = []
     /*
     var name = ["Textbooks": ["Tomato", "Potato", "Lettuce"], "Storybooks": ["Apple", "Banana"],
     "Others": []] */
     
     var names : [String: [String]] = [:]
     // and continue
     
     
     struct Objects {
     
     var sectionName : String!
     var sectionObjects : [String]!
     }
     
     var objectArray = [Objects]()
     */
    
    var items: [Int] = []
    
    @IBOutlet var carousel: iCarousel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for i in 0 ... 3 {
            items.append(i)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carousel.dataSource = self
        carousel.delegate = self
        carousel.type = .rotary
        carousel.isPagingEnabled = true
        carousel.centerItemWhenSelected = true
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookSegue" {
            let vc = segue.destination as! BookInfoAddViewController
            vc.asd = "Taylor"
            vc.delegate = self
            if PostingDataManager.userBookDataExist == true {
                vc.bName = pname
                vc.bAuthor = pauthor
                vc.bPublisher = ppub
                vc.bEdition = pedit
                vc.bDesc = pdesc
                vc.bISBN = pisbn
            }
        } else if segue.identifier == "categorySegue" {
            let vc = segue.destination as! CategoryTableViewController
            vc.delegate = self
            CategoryDataManager.firstTime = firstTimee
            vc.objectArray = categoryArray
        } else if segue.identifier == "levelSegue" {
            let vc = segue.destination as! LevelTableViewController
            vc.delegate = self
            CategoryDataManager.firstTimeLevel = firstTimeeLevel
            vc.level = allLevelObjectArr
            
        }
        
        
    }
    
    func sendData(text: String) {
        categoryLbl.text = text
        print("yolo")
        var overallCate : String!
        CategoryDataManager.getCateid(name: text, limit: "1", onComplete: {
            (data : Category) in
            self.tempCateid = data.id
            overallCate = data.heading
            print(self.tempCateid)
            if self.tempCateid.characters.count > 0 {
                PostingDataManager.userCategoryDataExist = true
            }
            CategoryDataManager.getCateid(name: overallCate, limit: "1", onComplete: {
                (data2 : Category) in
                self.tempOverallCateid = data2.id
                print("overall catid \(self.tempOverallCateid)")
                
            })
        })
        
    }
    func populateData(firstTime: Bool) {
        firstTimee = firstTime
    }
    func populateDataLevel(firstTime: Bool) {
        firstTimeeLevel = firstTime
    }
    
    func sendData(data: Posting) {
        bookLbl.text = data.name
        
        print("huehuehe")
        //
        
        
        pname = data.name!
        pisbn = data.isbn!
        ppub = data.publisher!
        pauthor = data.author!
        pedit = data.edition!
        pdesc = data.desc!
        PostingDataManager.userBookDataExist = true;
        
        print("pname: \(pname)")
        
        
        //        if postItem != nil {
        //        postItem?.name = data.name
        //        postItem?.desc = data.desc!
        //          postItem?.isbn = data.isbn!
        //          postItem?.author = data.author!
        //          postItem?.publisher = data.publisher!
        //          postItem?.edition = data.edition!
        //            print(postItem!.name!)
        //
        //        }
        
    }
    func storeCategory(categoryArray2: [Objects]) {
        //   for var i in 0 ..< categoryArray.count {
        // self.categoryArray.append(Objects(sectionName: categoryArray[i].sectionName, sectionObjects: categoryArray[i].sectionObjects))
        categoryArray = categoryArray2
        // }
    }
    func storeCourseLevel(courseLevelArray2: [Category]) {
        allLevelObjectArr = courseLevelArray2
    }
    
    func sendCourseLevel(text: String) {
        courselevelLbl.text = text
        print("yolo")
        CategoryDataManager.getCateid(name: text, limit: "1", onComplete: {
            (data : Category) in
            self.tempLevelid = data.id
            print(self.tempLevelid)
            if self.tempLevelid.characters.count > 0 {
                PostingDataManager.userCourselevelDataExist = true
            }
        })
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return items.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        //     var view = view
        //   var label: UILabel
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        
        
        
        pictures = [UIImage(named:"uploadImage.png"),UIImage(named:"uploadImage.png"),UIImage(named:"uploadImage.png"),UIImage(named:"uploadImage.png")]
        
        
        
        //reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            itemView = view
            
            
            //get a reference to the label in the recycled view
            //    label = itemView.viewWithTag(1) as! UILabel
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
            //  itemView.image = UIImage(named: "page.png")
            itemView.addGestureRecognizer(tap)
            itemView.tag = index
            itemView.isUserInteractionEnabled = true
            self.view.addSubview(itemView)
            itemView.contentMode = .scaleToFill
            /*
             label = UILabel(frame: itemView.bounds)
             label.backgroundColor = .clear
             label.textAlignment = .center
             label.font = label.font.withSize(50)
             label.tag = 1
             */
            //   itemView.addSubview(label)
            // itemView.addSubview(tapBtn)
        }
        
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        //   label.text = "\(items[index])"
        itemView.image = pictures[index]
        
        return itemView
        
        
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 3.5
        }
        return value
    }
    
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        
        
    }
    
    //    func handleTap(sender: UITapGestureRecognizer? = nil){
    //        print("Nyan Y U NO ALERT BRO")
    //                let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
    //                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
    //                self.present(alert, animated: true, completion: nil)
    //
    //    }
    
    //function which is triggered when handleTap is called
    func handleTap(_ sender: UITapGestureRecognizer) {
        
        
        //        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        //                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        //                        self.present(alert, animated: true, completion: nil)
        
        
        //        SCLAlertView().showInfo("Important info", subTitle: "You are great")
        itemView = sender.view as! UIImageView
        let appearance = SCLAlertView.SCLAppearance(
            showCircularIcon: true)
        let alertView = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "info") // Replace the IconImage text with the image name
        alertView.addButton("Take Photo", backgroundColor: UIColor(red: 0.251, green: 0.1608, blue: 0.5255, alpha: 1.0) , target: self, selector: #selector(ManualAddViewController.firstButton))
        alertView.addButton("Upload from Gallery", backgroundColor: UIColor(red: 0.251, green: 0.1608, blue: 0.5255, alpha: 1.0) ){
            print("upload from gallery tapped")
            
            alertView.shake()
            
            let picker = UIImagePickerController()
            picker.delegate = self
            // Setting this to true allows the user to crop and scale // the image to a square after the image is selected.
            //
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(
                picker, animated: true)
            
        }
        alertView.addButton("Preview", backgroundColor: UIColor(red: 0.251, green: 0.1608, blue: 0.5255, alpha: 1.0) ){
            print("preview tapped")
            alertView.shake()
            let imageView = sender.view as! UIImageView
            let newImageView = UIImageView(image: imageView.image)
            newImageView.frame = UIScreen.main.bounds
            newImageView.backgroundColor = .black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
            var scanVC =  self.parent as! ScannerViewController
            scanVC.setSegmentHidden(isHidden: true)
            
            //      newImageView.superview?.bringSubview(toFront: newImageView)
            
            
        }
        
        alertView.showInfo("Add Images", subTitle: "Choose an action", closeButtonTitle: "Close")
        //, circleIconImage: alertViewIcon)
        
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        //making the segment control visible again
        let scanVC =  self.parent as! ScannerViewController
        scanVC.setSegmentHidden(isHidden: false)
        
        sender.view?.removeFromSuperview()
    }
    func firstButton(){
        print("first button")
        
        /*
         let cameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cameraVC") as! OpenCameraViewController
         self.navigationController?.pushViewController(cameraVC, animated: true)
         */
        // We check if this device has a camera
        //
        if !(UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera)) {
            // If not, we will show the alert
            let alert = UIAlertController(title: "Take Photo", message: "This device does not support camera", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }else {
            let picker = UIImagePickerController()
            picker.delegate = self
            // Setting this to true allows the user to crop and scale // the image to a square after the photo is taken.
            //
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(
                picker, animated: true)
            
        }
    }
    
    // This function is called after the user took the picture,
    // or selected a picture from the photo library.
    // When that happens, we simply assign the image binary,
    // represented by UIImage, into the imageView we created. //
    // iOS doesn’t close the picker controller
    // automatically, so we have to do this ourselves by calling
    // dismissViewControllerAnimated. //
    func imagePickerController(
        _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [String : AnyObject])
    {
        let chosenImage : UIImage =
            info[UIImagePickerControllerOriginalImage] as! UIImage
        self.itemView.image = chosenImage
        
        
        pictures.remove(at: itemView.tag)
        pictures.insert(chosenImage, at: itemView.tag)
        
        
        picker.dismiss(animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
    // This function is called after the user decides not to
    // take/select any picture. iOS doesn’t close the picker controller // automatically, so we have to do this ourselves by calling
    // dismissViewControllerAnimated.
    //
    func imagePickerControllerDidCancel(
        _ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    @IBAction func postPressed(_ sender: UIButton) {
        var counter = 0
        success = false
        print(PostingDataManager.userCategoryDataExist)
        print(PostingDataManager.userCourselevelDataExist)
        print(PostingDataManager.userBookDataExist)
        if PostingDataManager.userCategoryDataExist == true && PostingDataManager.userCourselevelDataExist == true && PostingDataManager.userBookDataExist == true {
            callPhotoApi(onComplete: {
                //            print("success")
                //            print("level id nyaaan \(self.tempLevelid)")
                //            print(" cate id nyannnn \(self.tempCateid)")
                //            print("FILEPATH ARR COUNT ^~^ : \(self.filePath.count)")
                //
                //            for var i in 0 ..< self.filePath.count {
                //                print(self.filePath[i]!)
                //                print("huealien")
                //            }
                //            var catid : [String] = [self.tempCateid!,self.tempLevelid!]
                //
                //            print("CATEGORY ID \(catid)")
                //            PostingDataManager.createPostingData(token: "", cateid: catid, name: self.pname, isbn: self.pisbn, desc: self.pdesc, author: self.pauthor, publisher: self.ppub, edition: self.pedit, photos: self.filePath as! [String], loc: "", tags: "", onComplete: {
                //
                //            })
                
                print("success")
                print("level id nyaaan \(self.tempLevelid)")
                print(" cate id nyannnn \(self.tempCateid)")
                print(" overallcate id nyannnn \(self.tempOverallCateid)")
                print("FILEPATH ARR COUNT ^~^ : \(self.filePath.count)")
                counter = counter + 1
                
                if ( counter == self.pictures.count){
                    self.success = true
                }
                if self.success {
                    
                    for var i in 0 ..< self.filePath.count {
                        print("kkkk")
                        print(self.filePath[i])
                        print("huealien")
                    }
                    print("kitty cat")
                    var catid : [String] = [self.tempCateid!,self.tempLevelid!, self.tempOverallCateid!]
                    

                    
                    print("CATEGORY ID \(catid)")
                    print("kitty cat")
                    PostingDataManager.createPostingData(token: "", cateid: catid, name: self.pname, isbn: self.pisbn, desc: self.pdesc, author: self.pauthor, publisher: self.ppub, edition: self.pedit, photos: self.filePath , loc: "", tags: "", onComplete: {
                        
                    })
                    
                }
                
                
            })
            
            
        } else {
            // create the alert
            let alert = UIAlertController(title: "Post", message: "Please fill up all the fields", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    func callPhotoApi(onComplete:(() -> Void)?){
        
        let parameters = [
            "token": "#123456"
        ]
        
        //Use image name from bundle to create NSData
        for var i in 0 ..< self.pictures.count {
            let image : UIImage = pictures[i]!
            
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(UIImageJPEGRepresentation(image, 0.5)!, withName: "file", fileName: "file.png", mimeType: "image/png")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to:"http://13.228.39.122/FP01_654265348176237/1.0/photos/addp")
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        //self.delegate?.showSuccessAlert()
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        //                        self.showSuccesAlert()
                        //self.removeImage("frame", fileExtension: "txt")
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                            
                        }
                        if let data = response.result.value as? [String: Any]{
                            print("File PATH : ")
                            print(data["filepath"]!)
                            self.filePath.append(data["filepath"] as! String)
                            print("alien")
                            if onComplete != nil
                            {
                                onComplete!()
                                
                                
                            }
                        }
                        
                        
                    }
                    
                case .failure(let encodingError):
                    //self.delegate?.showFailAlert()
                    print(encodingError)
                }
                
            }
        }
        
        
        
    }
    
    
    
    
}



extension SCLAlertView {
    func shake(completion: ((Bool) -> Void)? = nil) {
        self.view.subviews[0].transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.subviews[0].transform = CGAffineTransform.identity
        }, completion: completion)
    }
}


//   http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=postings/0_a3eacd46902a4f6384dc165fb770ead2_r300

//    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
//
//        print("Nyan")
//        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }

/*
 @IBAction func buttonPressed(_ sender: UIButton) {
 
 if sender == categoryBtn {
 let categoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "categoryVC") as! UITableViewController
 self.navigationController?.pushViewController(categoryVC, animated: true)
 
 } else if sender == bookBtn {
 let bookInfoAddVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "bookInfoAddVC") as! BookInfoAddViewController
 self.navigationController?.pushViewController(bookInfoAddVC, animated: true)
 
 let bookInfoAddVC = BookInfoAddViewController()
 bookInfoAddVC.asd = "Taylor Swift"
 navigationController?.pushViewController(bookInfoAddVC, animated: true)
 
 } else if sender == courselevelBtn {
 let courseLevelVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "courseLevelVC") as! UITableViewController
 self.navigationController?.pushViewController(courseLevelVC, animated: true)
 }
 
 } */
//
//    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
//        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//
//    }



//        form +++ Section("Details")
//            <<< PushRow<String>() {
//                $0.title = "Category"
//                $0.selectorTitle = "Pick a category"
//                $0.options = ["One","Two","Three"]
//                $0.value = "Two"    // initially selected
//            }
//            <<< PushRow<String>() {
//                $0.title = "ActionSheetRow"
//                $0.selectorTitle = "Pick a number"
//                $0.options = ["One","Two","Three"]
//                $0.value = "Two"    // initially selected
//            }
//            <<< PushRow<String>() {
//                $0.title = "ActionSheetRow"
//                $0.selectorTitle = "Pick a number"
//                $0.options = ["One","Two","Three"]
//                $0.value = "Two"    // initially selected
//            }
//            +++ Section("Sharing")
//            <<< DateRow(){
//                $0.title = "Date Row"
//                $0.value = Date(timeIntervalSinceReferenceDate: 0)
//            }
//            <<< PushRow<String>() {
//                $0.title = "ActionSheetRow"
//                $0.selectorTitle = "Pick a category"
//                $0.options = textbook
//            //    tableView.reloadData()
//              //  $0.value = self.textbook[0]    // initially selected
//                  }
//                .cellUpdate { cell, row in
//                    row.options = self.textbook
//        }

/*   let urlCategory = "http://13.228.39.122/FP01_654265348176237/1.0/category/list"
 
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
 
 self.names = [
 "Textbooks": self.textbook,
 "Storybooks": self.storybook,
 "Others" : self.others
 ]
 
 print(self.textbook.count)
 print(self.storybook.count)
 print(self.others.count)
 for (key, value) in self.names {
 print("\(key) -> \(value)")
 self.objectArray.append(Objects(sectionName: key, sectionObjects: value))
 }
 
 DispatchQueue.main.async {
 
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
 
 
 }) */



//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//
//            multipartFormData.append(fileData, withName: "file_pack", fileName: "file_pack", mimeType: "text/plain")
//
//
//            for (key, value) in self.parameters {
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }
//        }, with: URL, encodingCompletion: { (result) in
//
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//                    self.delegate?.showSuccessAlert()
//                    print(response.request)  // original URL request
//                    print(response.response) // URL response
//                    print(response.data)     // server data
//                    print(response.result)   // result of response serialization
//                    //                        self.showSuccesAlert()
//                    self.removeImage("frame", fileExtension: "txt")
//                    if let JSON = response.result.value {
//                        print("JSON: \(JSON)")
//                    }
//                }
//
//            case .failure(let encodingError):
//                self.delegate?.showFailAlert()
//                print(encodingError)
//            }
//
//        })


// ======================================

/*       func uploadImageAndData(){
 //parameters
 
 let token = "#123456"
 //  let file =
 
 
 var parameters = [String:String]()
 parameters = ["token":token]
 
 let URL = "http://yourserviceurl/"
 for var i in 0..<pictures.count {
 //Use image name from bundle to create NSData
 let image : UIImage = pictures[i]!
 //      let image = UIImage(named: "image.png")
 
 Alamofire.upload(.POST, URL, multipartFormData: {
 multipartFormData in
 if  let imageData = UIImageJPEGRepresentation(image, 0.6) {
 multipartFormData.appendBodyPart(data: imageData, name: "image", fileName: "file.png", mimeType: "image/png")
 }
 for (key, value) in parameters {
 multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
 }
 }, encodingCompletion: {
 encodingResult in
 
 switch encodingResult {
 case .Success(let upload, _, _):
 print("s")
 upload.responseJSON { response in
 print(response.request)  // original URL request
 print(response.response) // URL response
 print(response.data)     // server data
 print(response.result)   // result of response serialization
 
 if let JSON = response.result.value {
 print("JSON: \(JSON)")
 }
 }
 
 case .Failure(let encodingError):
 print(encodingError)
 }
 })
 }
 }
 */
// ===== INITIAL PHOTO UPLOAD WEB API PLACED HERE =======
/*
 let parameters = [
 "token": "#123456"
 ]
 for var i in 0..<pictures.count {
 //Use image name from bundle to create NSData
 let image : UIImage = pictures[i]!
 
 
 Alamofire.upload(multipartFormData: { (multipartFormData) in
 multipartFormData.append(UIImageJPEGRepresentation(image, 0.5)!, withName: "file", fileName: "file.png", mimeType: "image/png")
 for (key, value) in parameters {
 multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
 }
 }, to:"http://13.228.39.122/FP01_654265348176237/1.0/photos/addp")
 { (result) in
 switch result {
 case .success(let upload, _, _):
 
 upload.uploadProgress(closure: { (Progress) in
 print("Upload Progress: \(Progress.fractionCompleted)")
 })
 
 upload.responseJSON { response in
 //self.delegate?.showSuccessAlert()
 print(response.request)  // original URL request
 print(response.response) // URL response
 print(response.data)     // server data
 print(response.result)   // result of response serialization
 //                        self.showSuccesAlert()
 //self.removeImage("frame", fileExtension: "txt")
 if let JSON = response.result.value {
 print("JSON: \(JSON)")
 
 }
 if let data = response.result.value as? [String: Any]{
 print("File PATH : ")
 print(data["filepath"]!)
 self.filePath[i] = data["filePath"] as? String
 }
 }
 
 case .failure(let encodingError):
 //self.delegate?.showFailAlert()
 print(encodingError)
 }
 
 }
 } */

//==== URL



/*
 let urlCategory = "http://13.228.39.122/FP01_654265348176237/1.0/photos/addp"
 
 for var i in 0..<pictures.count {
 //Use image name from bundle to create NSData
 let image : UIImage = pictures[i]!
 //Now use image to create into NSData format
 let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
 
 let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
 print(strBase64)
 
 
 
 HTTP.postJSON(url: urlCategory,
 json: JSON.init([
 "token" : "#123456",
 "file" : strBase64
 ]), onComplete: {
 json, response, error in
 
 if json != nil {
 print(json!)
 
 print(json![0]["success"])
 print(json![0]["filepath"])
 
 
 
 print("size of the array:  \(json!.count)")
 
 for var i in 0 ..< json!.count{
 self.filePath.append(json![i]["filePath"].string!)
 }
 
 DispatchQueue.main.async {
 
 
 }
 } else{
 print("failed api request")
 return
 }
 
 
 })
 
 
 }
 
 */
/*
 
 print("level id nyaaan \(self.tempLevelid)")
 print(" cate id nyannnn \(self.tempCateid)")
 */
//  postItem?.cateid = ["4","3"]
//     postItem?.cateid = [tempCateid!, tempLevelid!]
//        if postItem != nil {
//        //    postItem!.cateid = ["4","3"]
//            print(postItem!.cateid!)
//        }

/*   print("FILEPATH ARR COUNT ^~^ : \(filePath.count)")
 
 for var i in 0 ..< filePath.count {
 print(filePath[i]!)
 } */

// var arr = ["1"]
/*
 var catid : [String] = [tempCateid!,tempLevelid!]
 
 print("CATEGORY ID \(catid)") */


//        let pname = String(describing: postItem?.name!)
//        let pisbn = postItem?.isbn
//             var ppub = postItem?.publisher
//             var pauthor = postItem?.author
//             var pedit = postItem?.edition
//             var pdesc = postItem?.desc
//
/*
 PostingDataManager.createPostingData(token: "", cateid: catid, name: pname, isbn: pisbn, desc: pdesc, author: pauthor, publisher: ppub, edition: pedit, photos: filePath as! [String], loc: "", tags: "", onComplete: {
 
 }) */

/*  let urlPost = "http://13.228.39.122/FP01_654265348176237/1.0/posting/add"
 
 print("P FAMILY \(catid)")
 print("P FAMILY \(pname)")
 print("P FAMILY \(pisbn)")
 print("P FAMILY \(pdesc)")
 print("P FAMILY \(pauthor)")
 print("P FAMILY \(ppub)")
 print("P FAMILY \(pedit)")
 
 
 
 HTTP.postJSON(url: urlPost,
 json: JSON.init([
 "token" : "#123456",
 "cateid" : catid,
 "name" : pname,
 "isbn" : pisbn,
 "desc" : pdesc,
 "author" :pauthor,
 "publisher" : ppub,
 "edition" : pedit,
 "photos": arr,
 "preferredloc" : "Yio Chu Kang MRT",
 "tags" : "English"
 ]), onComplete: {
 json, response, error in
 
 if json != nil {
 print(json!)
 
 print(json!["success"].string!)
 print(json!["id"].string!)
 
 
 
 print("size of the array:  \(json!.count)")
 
 
 
 DispatchQueue.main.async {
 
 
 }
 } else{
 print("failed api request")
 return
 }
 
 
 })
 */

