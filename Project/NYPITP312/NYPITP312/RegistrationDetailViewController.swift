//
//  RegistrationDetailViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 25/4/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import Firebase
import UIKit

class RegistrationDetailViewController: UIViewController {
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
    
    @IBAction func registerPressed() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error
            {
                let uiAlert = UIAlertController(title: "Failed Registration", message: error.localizedDescription, preferredStyle: .alert)
                uiAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(uiAlert, animated: true, completion: nil)
            }
            else
            {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
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
