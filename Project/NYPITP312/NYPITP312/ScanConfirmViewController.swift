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
    
    
    var pname : String = ""
    var pisbn : String = ""
    var ppub : String = ""
    var pauthor : String = ""
    var pedit : String = ""
    var pdesc : String = ""
    
    var success : Bool = false;
    
    
    
    
    var items: [Int] = []
    
    
    @IBOutlet var carousel: iCarousel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for i in 0 ... 3 {
            items.append(i)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print(bookName)
        bookLbl.text = bookName
        
        print(bookCateId)
        
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
                    self.courselevelLbl.text = allLevelObjectArr[i].name
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
                        self.categoryLbl.text = allCateObjectArr[i].name
                    }
                    if (bookCateId[0] == allCateObjectArr[i].id!){
                        print("nyan back")
                        self.courselevelLbl.text = allCateObjectArr[i].name
                    }
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
                    self.categoryLbl.text = allCateObjectArr[i].name
                }
                if (bookCateId[0] == allCateObjectArr[i].id!){
                    print("nyan back")
                    self.courselevelLbl.text = allCateObjectArr[i].name
                }
                
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
            return value * 3.1
        }
        return value
    }
    
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        
        
    }
    
    
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
            let scanVC =  self.parent as! ScannerViewController
            scanVC.setSegmentHidden(isHidden: true)
            
            
            //      newImageView.superview?.bringSubview(toFront: newImageView)
            
            
        }
        
        alertView.showInfo("Add Images", subTitle: "Choose an action")
        //, circleIconImage: alertViewIcon)
        
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        var scanVC =  self.parent as! ScannerViewController
        scanVC.setSegmentHidden(isHidden: false)
        
        sender.view?.removeFromSuperview()
    }
    func firstButton(){
        print("first button")
        
        /*
         let cameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cameraVC") as! OpenCameraViewController
         self.navigationController?.pushViewController(cameraVC, animated: true)
         */
        let picker = UIImagePickerController()
        picker.delegate = self
        // Setting this to true allows the user to crop and scale // the image to a square after the photo is taken.
        //
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.camera
        self.present(
            picker, animated: true)
        
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
            info[UIImagePickerControllerEditedImage] as! UIImage
        itemView.image = chosenImage
        
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
            print(self.tempCateid)
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
        
        if (data != nil) {
            pname = data.name!
            pisbn = data.isbn!
            ppub = data.publisher!
            pauthor = data.author!
            pedit = data.edition!
            pdesc = data.desc!
        }
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
