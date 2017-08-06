//
//  ScanConfirmViewController.swift
//  NYPITP312
//
//  Created by Ng Wan Ying on 2/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

//
//  ScanConfirmViewController.swift
//  FairpriceShareTextbook
//
//  Created by Ng Wan Ying on 18/6/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import iCarousel
import SCLAlertView
import Alamofire

var firstTimeForCateArray : Bool = false
var firstTimeForLevelArray : Bool = false

class ScanConfirmViewController: UIViewController, SendCategoryDelegate, SendBook2Delegate, SendLevelDelegate, iCarouselDataSource, iCarouselDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var courselevelLbl: UILabel!
    
    @IBOutlet weak var bookLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categoryBtn: UIButton!
    
    @IBOutlet weak var bookBtn: UIButton!
    
    @IBOutlet weak var courselevelBtn: UIButton!
    
    var itemView: UIImageView!
    var pictures: [UIImage?] = []
    
    
    var filePath = [String]()
    var tempCateid : String!
    var tempLevelid : String!
    var tempOverallCateid : String!
    
    
    var pname : String = ""
    var pisbn : String = ""
    var ppub : String = ""
    var pauthor : String = ""
    var pedit : String = ""
    var pdesc : String = ""
    
    var success : Bool = false;
    
    var overallCate : String!
    
    
    
    var items: [Int] = []
    
    
    @IBOutlet var carousel: iCarousel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for i in 0 ... 3 {
            items.append(i)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        bookLbl.text = bookName
        pname = bookName
        pauthor = bookAuthor
        ppub = bookPublisher
        pedit = bookEdition
        pisbn = bookISBN
        print("before eh yeah")
        print(pname)
        print("eh yeah")
        
        
        
        //        var retrieveEachCate = bookCateId[0].components(separatedBy: ",")
        //        var subject = retrieveEachCate[0]
        //        let courselevel = retrieveEachCate[1]
        //        subject = subject.replacingOccurrences(of: "[" , with: "")
        //        print(subject)
        //        print("nyan cat says hii ")
        //        print(courselevel)
        print("nyan cat says hii ")
        
        if allLevelObjectArr.count == 0 {
            CategoryDataManager.getCourseLevel(heading: "Education Level", limit: "50", onComplete: {
                (data : [Category]) in
                for var i in 0 ..< data.count {
                    var cate4 = Category()
                    cate4.name = data[i].name
                    cate4.id = data[i].id
                    cate4.heading = data[i].heading
                    cate4.displayOrder = data[i].displayOrder
                    allLevelObjectArr.append(cate4)
                    if (bookCateId[0] == data[i].id!) {
                        DispatchQueue.main.async {
                            print("try")
                            self.courselevelLbl.text = data[i].name
                        }
                        
                        //  self.courselevelLbl.text = data[i].name
                        
                        self.tempLevelid =  data[i].id
                        print(self.tempLevelid)
                        print("testing")
                    }
                    
                    print("nyan done")
                    
                    
                }
                
            })
        } else {
            print("nyan whyyy ?")
            print(allLevelObjectArr.count)
            print("nyan triesss")
            for var i in 0 ..< allLevelObjectArr.count {
                print(allLevelObjectArr[i].id!)
                if (bookCateId[0] == allLevelObjectArr[i].id!){
                    print("nyan back")
                    DispatchQueue.main.async {
                        self.courselevelLbl.text = allLevelObjectArr[i].name
                    }
                    self.tempLevelid = allCateObjectArr[i].id
                    print(self.tempLevelid)
                    print("testing 2")
                }
                
                print("nyan done")
            }
            
        }
        
        
        
        if allCateObjectArr.count == 0 {
            CategoryDataManager.getCategory(heading: "Textbook", limit: "50", onComplete: {
                (txtbk: [Category], fictionbk: [Category],nonfictionbk: [Category],othersbk: [Category],data : [Objects]) in
                let arrCount = txtbk.count + fictionbk.count + nonfictionbk.count + othersbk.count
                print(arrCount)
                
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
                
                print("nyan whyyy ?")
                print(allCateObjectArr.count)
                print("nyan triesss")
                for var i in 0 ..< allCateObjectArr.count {
                    print(allCateObjectArr[i].id!)
                    print("nyan triesss")
                    print(bookCateId[0])
                    print("middle")
                    print(bookCateId[1])
                    if (bookCateId[1] == allCateObjectArr[i].id!) {
                        print("nyan otw")
                        DispatchQueue.main.async {
                            self.categoryLbl.text = allCateObjectArr[i].name
                        }
                        self.overallCate = allCateObjectArr[i].heading
                        self.tempCateid =  allCateObjectArr[i].id
                        print(self.overallCate)
                        print("testing")
                        print(self.tempCateid)
                        CategoryDataManager.getCateid(name: self.overallCate, limit: "1", onComplete: {
                            (data2 : Category) in
                            self.tempOverallCateid = data2.id
                            print("overall catid \(self.tempOverallCateid)")
                            
                        })
                        
                    }
                    //                    if (bookCateId[0] == allCateObjectArr[i].id!){
                    //                        print("nyan back")
                    //                        self.courselevelLbl.text = allCateObjectArr[i].name
                    //                          self.tempLevelid = allCateObjectArr[i].id
                    //                        print(self.tempLevelid)
                    //                    }
                    print("nyan done")
                }
            })
            
            
            
        } else {
            print("nyan whyyy ?")
            print(allCateObjectArr.count)
            print("nyan triesss")
            for var i in 0 ..< allCateObjectArr.count {
                print(allCateObjectArr[i].id!)
                if (bookCateId[1] == allCateObjectArr[i].id!) {
                    print("nyan otw")
                    DispatchQueue.main.async {
                        self.categoryLbl.text = allCateObjectArr[i].name
                    }
                    self.overallCate = allCateObjectArr[i].heading
                    tempCateid =  allCateObjectArr[i].id
                    print(self.overallCate)
                    print("testing 2")
                    print(self.tempCateid)
                    CategoryDataManager.getCateid(name: self.overallCate, limit: "1", onComplete: {
                        (data2 : Category) in
                        self.tempOverallCateid = data2.id
                        print("overall catid \(self.tempOverallCateid)")
                        
                    })
                    
                }
                //                if (bookCateId[0] == allCateObjectArr[i].id!){
                //                    print("nyan back")
                //                    self.courselevelLbl.text = allCateObjectArr[i].name
                //                    tempLevelid = allCateObjectArr[i].id
                //                      print(self.tempLevelid)
                //                }
                
                print("nyan done")
            }
            print("nyan triesss")
            print(bookCateId[0])
            print("middle")
            print(bookCateId[1])
        }
        
        
        //  courselevelLbl.text = bookCateId[0]
        //  categoryLbl.text = bookCateId[0]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        carousel.dataSource = self
        carousel.delegate = self
        carousel.type = .rotary
        carousel.isPagingEnabled = true
        carousel.centerItemWhenSelected = true
        
        
        
        //    bookLbl.text = bookName
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return items.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        //     var view = view
        //  var label: UILabel
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        
        
        
        pictures = [UIImage(named:"uploadImage.png"),UIImage(named:"uploadImage.png"),UIImage(named:"uploadImage.png"),UIImage(named:"uploadImage.png")]
        
        
        
        //reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            itemView = view
            
            
            //get a reference to the label in the recycled view
            //       label = itemView.viewWithTag(1) as! UILabel
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
             itemView.addSubview(label)
             */
            // itemView.addSubview(tapBtn)
        }
        
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        
        
        //     label.text = "\(items[index])"
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
    
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        
        
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
            picker.allowsEditing = false
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
            
            
            
            //      newImageView.superview?.bringSubview(toFront: newImageView)
            
            
        }
        
        alertView.showNotice("Add Images", subTitle: "Choose an action", closeButtonTitle: "Close")
        //, circleIconImage: alertViewIcon)
        
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        
        sender.view?.removeFromSuperview()
    }
    func firstButton(){
        print("first button")
        
        /*
         let cameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cameraVC") as! OpenCameraViewController
         self.navigationController?.pushViewController(cameraVC, animated: true)
         */
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
            picker.allowsEditing = false
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
    
    func sendData(text: String) {
        categoryLbl.text = text
        print("yolo")
        
        CategoryDataManager.getCateid(name: text, limit: "1", onComplete: {
            (data : Category) in
            self.tempCateid = data.id
            self.overallCate = data.heading
            print(self.tempCateid)
            if self.tempCateid.characters.count > 0 {
                PostingDataManager.userCategoryDataExist = true
            }
            CategoryDataManager.getCateid(name: self.overallCate, limit: "1", onComplete: {
                (data2 : Category) in
                self.tempOverallCateid = data2.id
                print("overall catid \(self.tempOverallCateid)")
                
            })
        })
        
    }
    func populateData(firstTime: Bool) {
        firstTimeForCateArray = firstTime
    }
    func populateDataLevel(firstTime: Bool) {
        firstTimeForLevelArray = firstTime
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
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scanBookSegue" {
            let vc = segue.destination as! ScanInfoViewController
            //  vc.asd = "Taylor"
            vc.delegate = self
            if PostingDataManager.userBookDataExist == true {
                vc.bDesc = pdesc
                
            }
            
        } else if segue.identifier == "scanCategorySegue" {
            let vc = segue.destination as! CategoryTableViewController
            vc.delegate = self
            CategoryDataManager.firstTime = firstTimeForCateArray
            vc.objectArray = categoryArray
        } else if segue.identifier == "scanLevelSegue" {
            let vc = segue.destination as! LevelTableViewController
            vc.delegate = self
            CategoryDataManager.firstTimeLevel = firstTimeForLevelArray
            vc.level = allLevelObjectArr
        }
        
        
    }
    
    
    @IBAction func postPressed(_ sender: UIButton) {
        var counter = 0
        success = false
        if PostingDataManager.userBookDataExist == true {
            callPhotoApi(onComplete: {
                
                
                print("success")
                print("level id nyaaan \(self.tempLevelid)")
                print(" cate id nyannnn \(self.tempCateid)")
                print(" overallcate id nyannnn \(self.tempOverallCateid)")
                print("FILEPATH ARR COUNT ^~^ : \(self.filePath.count)")
                
                print("BOOK INFO : \(bookAuthor)")
                print("BOOK NAME : \(bookName)")
                print("BOOK NAME : \(self.pname)")
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
                    print(PostingDataManager.userToken)
                    PostingDataManager.createPostingData(token: PostingDataManager.userToken!, cateid: catid, name: self.pname, isbn: self.pisbn, desc: self.pdesc, author: self.pauthor, publisher: self.ppub, edition: self.pedit, photos: self.filePath , loc: "", tags: "", onComplete: {
                        
                    })
                }
                
            })
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            // create the alert
            let alert = UIAlertController(title: "Post", message: "Please enter the condition of the book", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func callPhotoApi(onComplete:(() -> Void)?){
        
        let parameters = [
            "token": PostingDataManager.userToken!
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
    
    
    
    
    
    
    
    /*
     @IBAction func buttonPressed(_ sender: UIButton) {
     
     if sender == categoryBtn {
     let categoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "categoryVC") as! UITableViewController
     self.navigationController?.pushViewController(categoryVC, animated: true)
     } else if sender == bookBtn {
     let donateDescVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "donateDescVC") as! DonateAddBookDescViewController
     self.navigationController?.pushViewController(donateDescVC, animated: true)
     } else if sender == courselevelBtn {
     let courseLevelVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "courseLevelVC") as! UITableViewController
     self.navigationController?.pushViewController(courseLevelVC, animated: true)
     }
     
     } */
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

