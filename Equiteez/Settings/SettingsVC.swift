//
//  SettingsVC.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 1/7/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBAction func toggleDarkMode(_ sender: Any) {
        if darkModeSwitch.isOn {
            UserDefaults.standard.set("dark", forKey: "theme")
            view.window?.overrideUserInterfaceStyle = .dark
        } else if !darkModeSwitch.isOn {
            UserDefaults.standard.set("light", forKey: "theme")
            view.window?.overrideUserInterfaceStyle = .light
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(.portrait)
        
        if let themeSelected = UserDefaults.standard.string(forKey: "theme") {
            if themeSelected == "dark" {
                darkModeSwitch.setOn(true, animated: false)
            } else if themeSelected == "light" {
                darkModeSwitch.setOn(false, animated: false)
            }
        }
        
//        let style = overrideUserInterfaceStyle
//        if style == .dark {
//            darkModeSwitch.setOn(true, animated: false)
//        } else if style == .light {
//            darkModeSwitch.setOn(false, animated: false)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}
