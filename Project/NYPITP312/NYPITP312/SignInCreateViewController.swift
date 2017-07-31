//
//  SignInCreateViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 24/5/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class SignInCreateViewController: UIViewController {
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //let navigationBar = navigationController!.navigationBar
        //navigationBar.setBackgroundImage(UIImage(),
        //                                 for: .default)
        //navigationBar.shadowImage = UIImage()
        
        signInButton.layer.cornerRadius = signInButton.frame.size.height / 2
        createAccountButton.layer.cornerRadius = createAccountButton.frame.size.height / 2
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
