//
//  CustomButton.swift
//  NYPITP312
//
//  Created by Ng Wan Ying on 2/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

//
//  CustomButton.swift
//  FairpriceShareTextbook
//
//  Created by Ng Wan Ying on 18/6/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit



/*
 // Only override draw() if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func draw(_ rect: CGRect) {
 // Drawing code
 }
 */

@IBDesignable class CustomButton: UIButton {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
    }
}
