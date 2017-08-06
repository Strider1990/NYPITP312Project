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
    var bookmarks: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if login.userId == nil {
            UserDefaults.standard.removeObject(forKey: "bookmarks")
        }
        
        navigationBar.tintColor = UIColor.white
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
}
