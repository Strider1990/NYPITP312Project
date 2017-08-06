//
//  ProfileEditViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 2/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Eureka
import Alamofire

class ProfileEditViewController: FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var par: RootNavViewController!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profilePhoto: UIButton!
    
    // var userInfo
    var profileImage: UIImage?
    var changed: Bool!
    var userInfo: UserInfo!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.profileName.text = par.login.name
        self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.width / 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        par = self.parent as! RootNavViewController
        self.navigationItem.backBarButtonItem = nil
        self.userInfo = UserInfo()
        
        changed = false
        do {
            let data = try Data(contentsOf: URL(string: "http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=users/\(par.login.userId!)_c150")!)
            if data != nil {
                self.profilePhoto.setBackgroundImage(UIImage(data: data), for: .normal)
            } else {
                self.profilePhoto.setBackgroundImage(UIImage(named: "profile"), for: .normal)
            }
            print("http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=users/\(par.login.userId!)_c150")
        } catch {
            print("Error in data \(par.login.photo!)")
        }
        
        //TODO: Retrieve user info and set stuff
        DispatchQueue.global(qos: .background).async {
            HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/user/get", json: JSON.init(parseJSON: "{\"token\": \"\(self.par.login.token!)\",\"id\": \"\(self.par.login.userId!)\"}"), onComplete:
                {
                    json, response, error in
                    
                    print("User info:")
                    print(json!)
                    
                    if json == nil
                    {
                        return
                    }
                    
                    self.userInfo.name = json!["name"].string!
                    self.userInfo.phone = json!["phone"].string!
                    self.userInfo.photo = json!["photo"].string ?? json!["id"].string!
                    if self.userInfo.photo == "filepath" {
                        self.userInfo.photo = json!["id"].string!
                    }
                    
                    let prefLoc = json!["preferredloc"].string ?? "Yio Chu Kang MRT"
                    var showemail: Bool!
                    if json!["showemail"].exists() {
                        showemail = (json!["showemail"].string! == "true") ? true : false
                        print("Hello \(json!["showemail"].string!)")
                    } else {
                        showemail = false
                    }
                    var showphone: Bool!
                    if json!["showephone"].exists() {
                        showphone = (json!["showephone"].string == "true") ? true : false
                    } else {
                        showphone = false
                    }
                    
                    DispatchQueue.main.async {
                        self.form +++ Section()
                            <<< PickerInputRow<String>() {
                                $0.title = "Preferred Location"
                                $0.options = PreferredLocationDataManager.mrtList.sorted()
                                $0.value = prefLoc
                                $0.tag = "preferredloc"
                            }
                            <<< SwitchRow() {
                                row in
                                row.title = "Contact by Mobile"
                                row.value = showphone
                                row.tag = "showephone"
                            }
                            <<< SwitchRow() {
                                row in
                                row.title = "Contact by E-mail"
                                row.value = showemail
                                row.tag = "showemail"
                            }
                    }
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSave() {
        var parameters: [String: String] = [:]
        parameters["token"] = par.login.token!
        parameters["name"] = userInfo.name!
        parameters["phone"] = userInfo.phone!
        parameters["photo"] = userInfo.photo!
        if parameters["phone"] == "" {
            parameters["phone"] = "90000002"
        }
        for user in form.values() {
            parameters[user.key] = String(describing: user.value!)
        }
        print(parameters)
        
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        spinner.frame = self.view.frame
        spinner.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        spinner.alpha = 1.0
        self.view.addSubview(spinner)
        spinner.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        spinner.startAnimating()
        
        DispatchQueue.global(qos: .background).async {
            HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/user/edit", json: JSON.init(parameters), onComplete: {
                json, response, err in
                
                if json == nil {
                    return
                }
                
                if self.changed {
                    //Upload photo
                    Alamofire.upload(multipartFormData: { (multipartFormData) in
                        multipartFormData.append(UIImageJPEGRepresentation(self.profileImage!, 1)!, withName: "file", fileName: "file.jpeg", mimeType: "image/jpeg")
                        for (key, value) in parameters {
                            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                        }
                    }, to:"http://13.228.39.122/FP01_654265348176237/1.0/photos/addu")
                    { (result) in
                        switch result {
                        case .success(let upload, _, _):
                            upload.uploadProgress(closure: { (Progress) in
                                print("Upload Progress: \(Progress.fractionCompleted)")
                            })
                            
                            upload.responseJSON {
                                response in
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
                                    self.par.login.photo = data["filepath"] as! String
                                    DispatchQueue.main.async {
                                        spinner.stopAnimating()
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }
                            
                        case .failure(let encodingError):
                            //self.delegate?.showFailAlert()
                            print(encodingError)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        spinner.stopAnimating()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
        }
    }

    @IBAction func photoChange(_ sender: UIButton) {
        // open Gallery/photos option, encourage real photo
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
            //TODO: Get Camera
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let sharePhoto = UIAlertAction(title: "Open Gallery", style: .default) { (alert : UIAlertAction!) in
            //TODO: Get Photo Library
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
            //TODO: Destroy optionMenu
            optionMenu.dismiss(animated: true)
            
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // User cancelled
        picker.dismiss(animated: true)
    }
    
    internal func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info:
        [String : Any])
    {
        changed = true
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            print("Got a edited image")
            let resized = resizeImage(image: editedImage, targetSize: CGSize(width: 300.0, height: 300.0))
            self.profilePhoto.setBackgroundImage(resized, for: .normal)
            picker.dismiss(animated: true)
            self.profileImage = resized
        } else if let origImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("Got a new image")
            let resized = resizeImage(image: origImage, targetSize: CGSize(width: 300.0, height: 300.0))
            self.profilePhoto.setBackgroundImage(resized, for: .normal)
            picker.dismiss(animated: true)
            self.profileImage = resized
        } else {
            print("Error in getting image")
        }
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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
