//
//  ViewController.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 1/7/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import UIKit

class HomeScreenVC: UIViewController {
    
    @IBOutlet weak var continueBTN: UIButton!
   
    @IBAction func enterApp(_ sender: Any) {
        performSegue(withIdentifier: "enterApp", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueBTN.layer.cornerRadius = continueBTN.frame.height / 2
    }
    
    
}

