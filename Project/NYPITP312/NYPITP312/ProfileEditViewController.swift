//
//  ProfileEditViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 2/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Eureka

class ProfileEditViewController: FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var par: RootNavViewController!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profilePhoto: UIButton!
    
    // var userInfo
    var profileImage: UIImage?
    var changed: Bool!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.profileName.text = par.login.name
        changed = false
        do {
            let data = try Data(contentsOf: URL(string: "http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=users/\(par.login.photo!)_c150")!)
            print("http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=users/\(par.login.photo!)_c150")
        } catch {
            print("Error in data \(par.login.photo!)")
        }
        
        self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.width / 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        par = self.parent as! RootNavViewController
        
        form +++ Section()
            <<< PickerInputRow<String>() {
                $0.title = "Preferred Location"
                $0.options = ["Yio Chu Kang MRT", "Ang Mo Kio MRT"]
            }
            <<< SwitchRow() {
                row in
                row.title = "Contact by Mobile"
            }
            <<< SwitchRow() {
                row in
                row.title = "Contact by E-mail"
            }
            <<< ButtonRow() {
                row in
                row.title = "Change Password"
                }.onCellSelection({ cell, row in
                    self.performSegue(withIdentifier: "changePasswordSegue", sender: self)
                })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func btnDone() {
        
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
            
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // User cancelled
    }
    
    internal func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info:
        [String : Any])
    {
        changed = true
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profilePhoto.setBackgroundImage(editedImage, for: .normal)
            picker.dismiss(animated: true)
            self.profileImage = editedImage
        } else if let origImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profilePhoto.setBackgroundImage(origImage, for: .normal)
            picker.dismiss(animated: true)
            self.profileImage = origImage
        } else {
            print("Error in getting image")
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
