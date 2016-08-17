//
//  ThirdSlideViewController.swift
//  SimpleSleep
//
//  Created by Blair Altland on 8/10/16.
//  Copyright © 2016 Blairaltland. All rights reserved.
//

import UIKit

class ThirdSlideViewController: UIViewController {
    
    
    @IBAction func endOnboarding(_ sender: AnyObject) {
        
        GeneralSettings.saveOnboardingFinished()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
