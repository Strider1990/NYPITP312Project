//
//  LoginViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 25/4/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInPressed() {
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                let uiAlert = UIAlertController(title: "Failed Login", message: error.localizedDescription, preferredStyle: .alert)
                uiAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(uiAlert, animated: true, completion: nil)
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
