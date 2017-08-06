//
//  LoginViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 5/7/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var emailTextField: DesignableUITextField!
    @IBOutlet weak var passwordTextField: DesignableUITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var facebookLogin: FBSDKLoginButton!
    @IBOutlet weak var stackView: UIStackView!
    
    var nonce: String?
    var login: Login?

    let validator = FieldValidators()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        signInButton.layer.cornerRadius = signInButton.frame.size.height / 2
        
        facebookLogin.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func validateEmail(_ sender: DesignableUITextField) {
        DispatchQueue.global(qos: .background).async {
            HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/user/getnonce", json: JSON.init(parseJSON: "{ \"email\": \"\(self.emailTextField.text!)\" }"), onComplete: {
                json, response, error in
                
                print(json!)
                if json == nil {
                    return
                }
                    
                if json!["nonce"].exists() {
                    self.nonce = json!["nonce"].string!
                }
            })
        }
    }

    @IBAction func signInPressed(_ sender: UIButton) {
        if self.nonce == nil {
            validateEmail(emailTextField)
            print("Don't have nonce")
        }
        
        if passwordTextField.text != nil && nonce != nil {
            print("Trying activity")
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            spinner.frame = self.view.frame
            spinner.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
            spinner.alpha = 1.0
            self.view.addSubview(spinner)
            spinner.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
            spinner.startAnimating()
            
            let pwd = (passwordTextField.text!.sha512().uppercased() + nonce!).sha512().uppercased()
            DispatchQueue.global(qos: .background).async {
                
                HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/user/login", json: JSON.init(parseJSON: "{ \"type\": \"E\", \"email\": \"\(self.emailTextField.text!)\", \"password\": \"\(pwd)\" }"), onComplete: {
                    json, response, error in
                    
                    print(json!)
                    
                    if json == nil {
                        return
                    }
                    
                    if !json!["error"].exists() {
                        self.login = Login()
                        self.login?.name = json!["name"].string!
                        // TODO FIX THIS
                        self.login?.photo = json!["userid"].string!
                        self.login?.token = json!["token"].string!
                        self.login?.userId = json!["userid"].string!
                        self.login?.type = json!["type"].string!
                        self.login?.email = self.emailTextField.text!
                        
                        let par: RootNavViewController = self.parent as! RootNavViewController
                        par.login = self.login!
                        
                        User.loginUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { [weak weakSelf = self](status) in
                                if status == true {
                                    print("Successfully logged into Firebase")
                                    FIRDatabase.database().reference().child("bookmarks").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: {
                                        (snapshot) in
                                        if snapshot.exists() {
                                            if snapshot.value != nil {
                                                let bookmarks = snapshot.value as! [String: Bool]
                                                for bookmark in bookmarks {
                                                    par.bookmarks.append(bookmark.key)
                                                }
                                                print(par.bookmarks)
                                            }
                                        }
                                        DispatchQueue.main.async {
                                            spinner.stopAnimating()
                                            self.navigationController?.popToRootViewController(animated: true)
                                        }
                                    })
                                }
                            }
                    } else {
                        let optionMenu = UIAlertController(title: nil, message: "You entered the wrong password.", preferredStyle: .actionSheet)
                        optionMenu.popoverPresentationController?.sourceView = self.view
                        
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (alert : UIAlertAction!) in
                            //TODO: Destroy optionMenu
                            optionMenu.dismiss(animated: true, completion: nil)
                        }
                        optionMenu.addAction(cancelAction)
                        
                        DispatchQueue.main.async {
                            spinner.stopAnimating()
                            self.present(optionMenu, animated: true, completion: nil)
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func loginButtonClicked() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: nil)
        { (result, error) in
            if error != nil {
                print("FB Login failed:", error!)
                return
            }
            
            if let socialToken = result?.token {
                print(socialToken.tokenString)
            } else {
                print("No token")
            }
            
            /*LoginDataManager.socialLogin(socialToken: socialToken!, onComplete: {
                (token, userId, isLogin) -> Void in
                
                LoginGlobalVar.token = token
                LoginGlobalVar.userId = userId
                
                if (isLogin) {
                    DispatchQueue.main.async() {
                        
                    }
                }
                
            })*/
                        
        }
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        if let email = emailTextField.text, !email.isEmpty {
            DispatchQueue.global(qos: .background).async {
                HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/user/forgetpassword", json: JSON.init(parseJSON: "{ \"email\": \"\(email)\" }"), onComplete: {
                    json, response, error in
                    
                    if json == nil {
                        return
                    }
                    
                    print(json!)
                    DispatchQueue.main.async {
                        if let _ = json!["success"].string {
                            let alertController = UIAlertController(title: "BookShare", message:
                                "A recovery code has been sent to your e-mail.", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                            
                            self.present(alertController, animated: true, completion: nil)
                        } else {
                            let alertController = UIAlertController(title: "BookShare", message:
                                "There is no account attached to that e-mail.", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                })
            }
        } else {
            let alertController = UIAlertController(title: "BookShare", message:
                "Enter your e-mail!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
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
