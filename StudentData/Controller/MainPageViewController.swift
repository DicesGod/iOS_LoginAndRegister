//
//  MainPageViewController.swift
//  StudentData
//
//  Created by Minh Le on 2019-05-01.
//  Copyright © 2019 Minh Le. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    
    
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var Score: UILabel!
    
    @IBAction func Play(_ sender: UIButton) {
        self.performSegue(withIdentifier: "question", sender: self)
    }
    
    
    @IBAction func Logout(_ sender: UIButton) {
        UserDefaults.standard.set("", forKey: "username")
        UserDefaults.standard.set("", forKey: "password")
        UserDefaults.standard.synchronize()
         self.performSegue(withIdentifier: "logout", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Username.text = "Username: "+String(UserDefaults.standard.string(forKey: "username") ?? "")
        Score.text = "0"
        // Do any additional setup after loading the view.
    }
}
