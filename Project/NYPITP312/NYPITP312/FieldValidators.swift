//
//  FieldValidators.swift
//  NYPITP312
//
//  Created by Alex Ooi on 3/7/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

struct FieldValidators {
    func emailValidate(_ field: DesignableUITextField) -> Bool {
        if let text = field.text {
            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            return emailPredicate.evaluate(with: text)
        } else {
            return false
        }
    }
    
    func passwordValidate(_ field: DesignableUITextField) -> Bool {
        var valid = true
        
        if let text = field.text, !text.isEmpty {
            // Validate password security
            let passwordFormat = "(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d!$%@#£€*?&]{8,}"
            let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordFormat)
            return passwordPredicate.evaluate(with: text)
        } else {
            valid = false
        }
        
        return valid
    }
    
    func passwordValidate(_ text: String) -> Bool {
        var valid = true
        
        if !text.isEmpty {
            // Validate password security
            let passwordFormat = "(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d!$%@#£€*?&]{8,}"
            let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordFormat)
            return passwordPredicate.evaluate(with: text)
        } else {
            valid = false
        }
        
        return valid
    }
    
    func mobileValidate(_ field: DesignableUITextField) -> Bool {
        var valid = true
        
        if let text = field.text, !text.isEmpty {
            let mobileFormat = "[0-9]{8}"
            let mobilePredicate = NSPredicate(format: "SELF MATCHES %@", mobileFormat)
            return mobilePredicate.evaluate(with: text)
            // Validate mobile number
        } else {
            valid = false
        }
        
        return valid
    }
    
    func confirmValidate(_ field: DesignableUITextField, pass passField: DesignableUITextField) -> Bool {
        var valid = true
        
        if let confirm = field.text, !confirm.isEmpty {
            if let pwd = passField.text, !pwd.isEmpty {
                if confirm != pwd {
                    valid = false
                }
            } else {
                valid = false
            }
        } else {
            valid = false
        }
        
        return valid
    }
    
    func nameValidate(_ field: DesignableUITextField) -> Bool {
        var valid = true
        
        if let text = field.text, !text.isEmpty {
            
        } else {
            valid = false
        }
        
        return valid
    }
    
    func dobValidate(_ field: DesignableUITextField) -> Bool {
        var valid = true
        
        if let text = field.text, !text.isEmpty {
            
        } else {
            valid = false
        }
        
        return valid
    }
}
