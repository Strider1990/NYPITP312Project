//
//  ProfileViewController.swift
//  NYPITP312
//
//  Created by Alex Ooi on 1/8/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var donationButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var achievementButton: UIButton!
    @IBOutlet weak var transactionButton: UIButton!
    @IBOutlet weak var chatTable: UITableView!
    
    var par: RootNavViewController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.parent?.navigationItem.title = par.login.name
        
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ProfileViewController.btnEdit))
        self.parent?.navigationItem.rightBarButtonItem = edit
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(ProfileViewController.btnLogout))
        self.parent?.navigationItem.leftBarButtonItem = logout
        
        do {
            let data = try Data(contentsOf: URL(string: "http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=users/\(par.login.photo!)_c150")!)
            print("http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=users/\(par.login.photo!)_c150")
            self.profilePhoto.image = UIImage(data: data)
        } catch {
            print("Error in data \(par.login.photo!)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        par = self.parent?.parent as! RootNavViewController
        
        self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.width / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func btnEdit() {
        // Perform segue to profile editing
    }
    
    func btnLogout() {
        if par.login.type == "G" {
            GIDSignIn.sharedInstance().signOut()
        }
        
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        spinner.frame = self.view.frame
        spinner.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        spinner.alpha = 1.0
        self.view.addSubview(spinner)
        spinner.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        spinner.startAnimating()
        DispatchQueue.global(qos: .background).async {
            HTTP.postJSON(url: "http://13.228.39.122/FP01_654265348176237/1.0/user/logout", json: JSON.init(parseJSON: "{\"token\": \"\(self.par.login.token!)\",\"userid\": \"\(self.par.login.userId!)\"}"), onComplete:
                {
                    json, response, error in
                    
                    if json == nil
                    {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        spinner.stopAnimating()
                        self.par.login = Login()
                        let tabBarController: TabViewController = self.parent as! TabViewController
                        tabBarController.selectedIndex = 0
                    }
            })
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
