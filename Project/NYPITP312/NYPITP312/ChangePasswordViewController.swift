//
//  ChangePasswordViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 2/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Eureka

class ChangePasswordViewController: FormViewController {

    var validator: FieldValidators!
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .lightContent
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor(red: 82.0/255.0, green: 61.0/255.0, blue: 152.0/255.0, alpha: 1.0)
        }
        
        validator = FieldValidators()
        
        form +++ Section("Change Password")
            <<< PasswordRow() {
                row in
                row.title = "Old Password"
                row.add(rule: RuleRequired())
            }
            <<< PasswordRow() {
                row in
                row.title = "New Password"
                row.add(rule: RuleRequired())
            }.onRowValidationChanged {
                cell, row in
                print("Validation changed")
            }.onChange {
                row in
                print(row.value!)
            }
            <<< PasswordRow() {
                row in
                row.title = "Confirm New"
                row.add(rule: RuleRequired())
            }.onChange {
                row in
                print(row.value!)
            }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func savePressed(_ sender: UIBarButtonItem) {
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
