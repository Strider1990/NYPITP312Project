//
//  RegistrationFirstViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 3/7/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class RegistrationFirstViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: DesignableUITextField!
    @IBOutlet weak var nameTextField: DesignableUITextField!
    @IBOutlet weak var passwordTextField: DesignableUITextField!
    @IBOutlet weak var confirmPasswordTextField: DesignableUITextField!
    @IBOutlet weak var dobTextField: DesignableUITextField!
    @IBOutlet weak var mobileTextField: DesignableUITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var validEmail = false
    var validName = false
    var validPass = false
    var validConfirm = false
    var validDob = false
    var validMobile = false
    var fieldValidator: FieldValidators!
    var profile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fieldValidator = FieldValidators()
        
        if self.fieldValidator.emailValidate(emailTextField) {
            validEmail = true
        }
        if self.fieldValidator.nameValidate(nameTextField) {
            validName = true
        }
        if self.fieldValidator.passwordValidate(passwordTextField) {
            validPass = true
        }
        if self.fieldValidator.confirmValidate(confirmPasswordTextField, pass: passwordTextField) {
            validConfirm = true
        }
        if self.fieldValidator.dobValidate(dobTextField) {
            validDob = true
        }
        if self.fieldValidator.mobileValidate(mobileTextField) {
            validMobile = true
        }
        
        self.profile = Profile()
        self.nextButton.layer.cornerRadius = nextButton.frame.size.height / 2
        
        allValid()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dp(_ sender: DesignableUITextField) {
        let datePickerView = UIDatePicker()
        let currentDate = Date()
        datePickerView.datePickerMode = .date
        datePickerView.maximumDate = currentDate
        datePickerView.date = Date(timeInterval: -567648000, since: currentDate)
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dobTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func validateEmail(_ sender: DesignableUITextField) {
        if !self.fieldValidator.emailValidate(sender) {
            emailTextField.layer.borderColor = UIColor.red.cgColor
            validEmail = false
        } else {
            emailTextField.layer.borderColor = UIColor.green.cgColor
            validEmail = true
            profile?.email = emailTextField.text
        }
        emailTextField.layer.borderWidth = 1.0
        allValid()
    }
    
    @IBAction func validateName(_ sender: DesignableUITextField) {
        if !self.fieldValidator.nameValidate(sender) {
            nameTextField.layer.borderColor = UIColor.red.cgColor
            validName = false
        } else {
            nameTextField.layer.borderColor = UIColor.green.cgColor
            validName = true
            profile?.name = nameTextField.text
        }
        nameTextField.layer.borderWidth = 1.0
        allValid()
    }
    
    @IBAction func validatePassword(_ sender: DesignableUITextField) {
        if !self.fieldValidator.passwordValidate(sender) {
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            validPass = false
        } else {
            passwordTextField.layer.borderColor = UIColor.green.cgColor
            validPass = true
        }
        passwordTextField.layer.borderWidth = 1.0
        allValid()
    }
    
    @IBAction func validateConfirm(_ sender: DesignableUITextField) {
        if !self.fieldValidator.confirmValidate(sender, pass: passwordTextField) {
            confirmPasswordTextField.layer.borderColor = UIColor.red.cgColor
            validConfirm = false
        } else {
            confirmPasswordTextField.layer.borderColor = UIColor.green.cgColor
            validConfirm = true
            profile?.password = passwordTextField.text?.sha512().uppercased()
        }
        confirmPasswordTextField.layer.borderWidth = 1.0
        allValid()
    }
    
    @IBAction func validateDob(_ sender: DesignableUITextField) {
        if !self.fieldValidator.dobValidate(sender) {
            dobTextField.layer.borderColor = UIColor.red.cgColor
            validDob = false
        } else {
            dobTextField.layer.borderColor = UIColor.green.cgColor
            validDob = true
        }
        dobTextField.layer.borderWidth = 1.0
        allValid()
    }
    
    @IBAction func validateMobile(_ sender: DesignableUITextField) {
        if !self.fieldValidator.mobileValidate(sender) {
            mobileTextField.layer.borderColor = UIColor.red.cgColor
            validMobile = false
        } else {
            mobileTextField.layer.borderColor = UIColor.green.cgColor
            validMobile = true
            profile?.mobile = mobileTextField.text
        }
        mobileTextField.layer.borderWidth = 1.0
        allValid()
    }
    
    func allValid() {
        if !nextButton.isEnabled && validEmail && validMobile && validDob && validName && validConfirm && validPass {
            nextButton.isEnabled = true
        } else if nextButton.isEnabled {
            nextButton.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondViewController = segue.destination as! RegistrationSecondViewController
        secondViewController.profile = self.profile
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
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
