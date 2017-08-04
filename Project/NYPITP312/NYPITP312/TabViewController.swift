//
//  TabViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 5/7/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let par: RootNavViewController = parent as! RootNavViewController
        if viewController is ProfileViewController && par.login.token == nil {
            performSegue(withIdentifier: "loginSegue", sender: self)
            return false
        }
        
        
        if viewController is ScannerViewController && par.login.token == nil {
            performSegue(withIdentifier: "loginSegue", sender: self)
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
     let par: RootNavViewController = parent as! RootNavViewController
     
     if item.title! == "Profile" && par.login.token == nil {
     performSegue(withIdentifier: "loginSegue", sender: self)
     }
     }
     
     override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
     let par: RootNavViewController = parent as! RootNavViewController
     //if item.title! == "Profile" && par.login.token == nil {
     //performSegue(withIdentifier: "loginSegue", sender: self)
     //}
     return true
     }*/
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

