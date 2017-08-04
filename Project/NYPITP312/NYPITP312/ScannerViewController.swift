//
//  ScannerViewController.swift
//  NYPITP312
//
//  Created by Ng Wan Ying on 1/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

//
//  ScannerViewController.swift
//  FairpriceShareTextbook
//
//  Created by Ng Wan Ying on 30/5/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox


var bookName : String!


var bookPublisher : String!
var bookEdition : String!
var bookISBN : String!
var bookCondition : String!
var bookAuthor : String!
var bookCateId : [String]!



class ScannerViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate{
    /* override var preferredStatusBarStyle: UIStatusBarStyle {
     return .lightContent
     }*/
    
    // var userToken : String = ""
    
    func setSegmentHidden(isHidden: Bool){
        
        donateSegment.isHidden = isHidden
    }
    
    
    
    
    @IBAction func postBtn(_ sender: UIBarButtonItem) {
        
        
        //        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileVC")
        //        self.navigationController?.present(profileVC, animated: true)
        
        
        //   self.tabBarController?.selectedIndex = 3
        
        /*
         let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scanConfirmVC")
         self.navigationController?.pushViewController(profileVC, animated: true)
         */
        print("nyan says hi ! :D")
    }
    
    
    @IBOutlet weak var doneNavBtn: UIBarButtonItem!
    
    //  @IBOutlet var view1: UIView!
    
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var detectLabel: UILabel!
    
    
    @IBOutlet weak var view2: UIView!
    
    
    var captureSession:AVCaptureSession?
    @IBOutlet weak var donateSegment: UISegmentedControl!
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    var qrCodeFrameView:UIView?
    
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode]
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("a")
        
        first = true;
        
        captureSession?.startRunning()
        qrCodeFrameView?.frame = CGRect.zero
        detectLabel.text = "Try Manual Add if no barcode found."
        
        self.parent?.navigationItem.title = "Donate"
        /*if donateSegment.selectedSegmentIndex == 0 {
         
         //doneNavBtn.isEnabled = false
         //doneNavBtn.tintColor = UIColor.clear
         
         }*/
    }
    
    
    override func viewDidLayoutSubviews() {
        //    videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let par: RootNavViewController = self.parent?.parent as! RootNavViewController
        PostingDataManager.userToken = par.login.token!
        print(PostingDataManager.userToken)
        print("login nyan")
        
        
        
        print("c")
        
        view2.isHidden = true;
        
        
        
        
        // Do any additional setup after loading the view.
        
        //Get an instance of the AVCaptureDevice class to initialize a device object and provide
        // the video as the media type parameter.
        /*
         let url = "http://13.228.39.122/FP01_654265348176237/1.0/isbn/add"
         
         HTTP.postJSON(url: url,
         json: JSON.init([
         "token" : "123467832",
         "id" : "9780733426094",
         "limit" : "1",
         "name" : "Discover Maths",
         "publisher" : "Marshall Cavendish Education (formerly Panpac Education)",
         "edition" : "1st Edition",
         "author" : "Lai Chee Chong, Spario Soon, Tan Kim Lian",
         "cateid" : [ "3", "8"]
         
         ]), onComplete: {
         json, response, error in
         
         if json != nil {
         print(json!)
         
         DispatchQueue.main.async {
         
         }
         } else{
         print("failed api request")
         return
         }
         
         })
         */
        
        
        /*
         
         let url2 = "http://13.228.39.122/FP01_654265348176237/1.0/category/add"
         
         HTTP.postJSON(url: url2,
         json: JSON.init([
         "token" : "123467832",
         "id" : "8",
         "displayorder" : "2",
         "heading" : "Level/Course",
         "name" : "Primary 1",
         
         
         ]), onComplete: {
         json, response, error in
         
         if json != nil {
         print(json!)
         
         DispatchQueue.main.async {
         
         }
         } else{
         print("failed api request")
         return
         }
         
         })
         
         */
        
        
        
        let url1 = "http://13.228.39.122/FP01_654265348176237/1.0/isbn/list"
        
        HTTP.postJSON(url: url1,
                      json: JSON.init([
                        "id" : "9780733426094",
                        "limit" : "1",
                        
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
                                DispatchQueue.main.async {
                                    
                                }
                            } else{
                                print("failed api request")
                                return
                            }
                            
        })
        
        
        
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            //Get an instance of the AVCaptureDeviceInput class using the previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            //Initialise the captureSession object.
            captureSession = AVCaptureSession()
            
            //Set the input device on the capture session
            captureSession?.addInput(input)
            
            //Initialize a AVCaptureMetadataOutput object and set it as the output device
            //to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            //Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            //    captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            //Initialise the video preview layer and add it as a sublayer to the
            //viewPreview view's layer.
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            //Start video capture.
            captureSession?.startRunning()
            
            //Move the message label and top bar to the front
            view.bringSubview(toFront: detectLabel)
            view.bringSubview(toFront: navView)
            
            //Initialise barcode frame to highlight the barcode
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
            
            
            
        }catch {
            //If any error occurs, simply print it out and dont continue any more.
            print(error)
            return
            
        }
        
    }
    var first = true;
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func segmentChanged(_ sender: Any) {
        
        if donateSegment.selectedSegmentIndex == 1 {
            
            videoPreviewLayer?.isHidden = true
            view2.isHidden = false
            view.bringSubview(toFront: view2)
            view.bringSubview(toFront: navView)
            //doneNavBtn.isEnabled = true
            //doneNavBtn.tintColor = UIColor.white
            
            /*
             let manualVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "manualVC") as! ManualAddViewController
             self.navigationController?.present(manualVC, animated: true)
             */
        }else if donateSegment.selectedSegmentIndex == 0 {
            videoPreviewLayer?.isHidden = false
            view2.isHidden = true
            //doneNavBtn.isEnabled = false
            //doneNavBtn.tintColor = UIColor.clear
            
        }
        
    }
    
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        //Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            detectLabel.text = "No barcode is detected"
            return
        }
        
        print(metadataObjects)
        
        //Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type){
            //If the found metadata is equal to the barcode metadata then update the status
            //label's text and set the bounds
            captureSession?.stopRunning()
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if !first {
                return
            }
            first = false;
            
            if metadataObj.stringValue != nil {
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                detectLabel.text = metadataObj.stringValue
                
                // captureSession?.stopRunning()
                
                let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                spinner.frame = self.view.frame
                spinner.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
                spinner.alpha = 1.0
                self.view.addSubview(spinner)
                spinner.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
                spinner.startAnimating()
                
                
                
                
                ISBNDataManager.getISBNData(id: metadataObj.stringValue, limit: "1", onComplete: {
                    (ISBN) in
                    if ISBNDataManager.success{
                        bookName = ISBN.name
                        bookPublisher = ISBN.publisher
                        bookAuthor = ISBN.author
                        bookEdition = ISBN.edition
                        bookISBN = ISBN.id
                        print("nyaaapire")
                        print(ISBN.cateid)
                        //  for var i in 0 ..< ISBN.cateid.count {
                        //   bookCateId.append(ISBN.cateid[i])
                        //    bookCateId[i] = ISBN.cateid[i]
                        
                        bookCateId = ISBN.cateid
                        
                        //      }
                        //  bookCateId.append(ISBN.cateid[1])
                        print("nyaaacan !")
                        if (bookName != nil) {
                            DispatchQueue.main.async {
                                //            self.detectLabel.text = "Book Name: \(ISBN.name!) Book Publisher: \(ISBN.publisher!) Book Edition: \(ISBN.edition!) Book ISBN: \(ISBN.id!)"
                                
                                //  if ISBNDataManager.success{
                                
                                
                                //                    let scanConfirmVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scanConfirmVC") as! ScanConfirmViewController
                                //                    self.navigationController?.pushViewController(scanConfirmVC, animated: true)
                                
                                /* ==========
                                 CategoryDataManager.getCategory(heading: "Textbook", limit: "50", onComplete: {
                                 (data : [Objects]) in
                                 
                                 
                                 })
                                 */
                                
                                //     let scanConfirmVC = ScanConfirmViewController()
                                
                                spinner.stopAnimating()
                                
                                print("yolo")
                                print(bookCateId.count)
                                
                                //                print("hi")
                                //                scanConfirmVC.categoryLbl.text = ISBN.cateid[0]
                                //                scanConfirmVC.courselevelLbl.text = ISBN.cateid[1]
                                //       self.navigationController?.pushViewController(scanConfirmVC, animated: true)
                                let scanConfirmVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scanConfirmVC") as! ScanConfirmViewController
                                self.navigationController?.pushViewController(scanConfirmVC, animated: true)
                            }
                            
                        }
                    }
                    
                    print("done")
                    
                })
                
                //    self.detectLabel.text = "Book Name: \(item.name!) Book Publisher: \(item.publisher!) Book Edition: \(item.edition!) Book ISBN: \(item.id!)"
                
                
                
                
                
            }
            
        }
        
        /* if metadataObj.type == AVMetadataObjectTypeQRCode {
         //If the found metadata is equal to the barcode metadata then update the status
         //label's text and set the bounds
         
         let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
         qrCodeFrameView?.frame = barCodeObject!.bounds
         
         if metadataObj.stringValue != nil {
         detectLabel.text = metadataObj.stringValue
         }
         } */
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
