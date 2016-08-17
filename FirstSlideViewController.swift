//
//  FirstSlideViewController.swift
//  SimpleSleep
//
//  Created by Blair Altland on 8/10/16.
//  Copyright © 2016 Blairaltland. All rights reserved.
//

import UIKit
import HealthKit

class FirstSlideViewController: UIViewController {

    let healthStore = HKHealthStore()
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var allowAccessLabel: UILabel!
    @IBOutlet weak var allowAccessButton: UIButton!
    @IBOutlet weak var allowAccessButtonBackground: UIView!
    
    @IBAction func allowHealthKitAccess(_ sender: AnyObject) {
       
        let typestoRead = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
            ])
        
        let typestoShare = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
            ])
        
        self.healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
            if success == false {
                NSLog(" Display not allowed")
            }
        }
        
        welcomeLabel.text = "🎉Thank you🎉"
        allowAccessLabel.text = "Now lets get to logging your sleep. (Swipe to continue)"
        allowAccessButton.isHidden = true
        allowAccessButtonBackground.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        allowAccessButton.titleLabel?.adjustsFontSizeToFitWidth = true
        allowAccessButton.titleLabel?.minimumScaleFactor = 0.5
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestHealthKitPermissions() {
        
        let typestoRead = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
            ])
        
        let typestoShare = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
            ])
        
        self.healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) -> Void in
            if success == false {
                NSLog(" Display not allowed")
            }
        }
    }
}
