//
//  RootNavViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 22/5/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class RootNavViewController: UINavigationController {
    var login = Login()
    var categoryList: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = UIColor.white;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
