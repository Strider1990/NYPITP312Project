//
//  RegistrationSecondViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 3/7/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class RegistrationSecondViewController: UIViewController, UIImagePickerControllerDelegate {

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var emailSwitch: UISwitch!
    @IBOutlet weak var smsSwitch: UISwitch!
    @IBOutlet weak var signUpButton: UIButton!
    
    var profile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.profileButton.layer.cornerRadius = self.profileButton.frame.size.width / 2
        self.signUpButton.layer.cornerRadius = signUpButton.frame.size.height / 2
        self.profile?.contactEmail = false
        self.profile?.contactMobile = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emailSwitchChanged(_ sender: UISwitch) {
        self.profile?.contactEmail = sender.isOn
    }

    @IBAction func smsSwitchChanged(_ sender: UISwitch) {
        self.profile?.contactMobile = sender.isOn
    }
    
    @IBAction func uploadPhoto(_ sender: UIImageView) {
        // open Gallery/photos option, encourage real photo
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
            //TODO: Get Camera
        }
        let sharePhoto = UIAlertAction(title: "Open Gallery", style: .default) { (alert : UIAlertAction!) in
            //TODO: Get Photo Library
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
            //TODO: Destroy optionMenu
        }
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func validateSignUp(_ sender: UIButton) {
        if emailSwitch.isOn || smsSwitch.isOn {
            // Validate photo has been uploaded
            self.profile?.profileImg = "filepath"
            
            /*let testFrame: CGRect = CGRect(x: 0, y: 200, width: 320, height: 200)
            var testView: UIView = UIView(frame: testFrame)
            testView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
            testView.alpha = 0.5
            self.view.addSubview(testView)*/
            
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            spinner.frame = self.view.frame
            spinner.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
            spinner.alpha = 1.0
            self.view.addSubview(spinner)
            spinner.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
            spinner.startAnimating()

            DispatchQueue.global(qos: .background).async {
                HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/user/add", json: JSON.init(parseJSON: "{ \"type\": \"E\", \"name\": \"\(self.profile!.name!)\", \"photo\": \"\(self.profile!.profileImg!)\", \"email\": \"\(self.profile!.email!)\", \"password\": \"\(self.profile!.password!)\", \"phone\": \"\(self.profile!.mobile!)\", \"showemail\": \"\(self.profile!.contactEmail!.description)\", \"showphone\": \"\(self.profile!.contactMobile!.description)\" }"), onComplete:
                {
                    json, response, error in
                    
                    if json == nil
                    {
                        return
                    }
                    
                    if json!["success"].exists() {
                        let par: RootNavViewController = self.parent as! RootNavViewController
                        let newLogin = Login()
                        newLogin.name = self.profile!.name!
                        newLogin.photo = self.profile!.profileImg!
                        newLogin.token = json!["token"].string!
                        newLogin.userId = json!["userid"].string!
                        
                        par.login = newLogin
                    }
                 
                    DispatchQueue.main.async {
                        spinner.stopAnimating()
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                })
            }
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
