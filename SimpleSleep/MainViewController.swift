//
//  ViewController.swift
//  SimpleSleep
//
//  Created by Blair Altland on 8/1/16.
//  Copyright © 2016 Blairaltland. All rights reserved.
//

import UIKit
import HealthKit

class MainViewController: UIViewController {
    
    static let sharedProfile = MainViewController()
    
    let healthStore = HKHealthStore()
    //let Date = String(NSDate())
    let dateFormatter = DateFormatter()
    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    
    var darkMode = false
    
    //Colors
    let darkModeBackground = UIColor(red:0.08, green:0.07, blue:0.14, alpha:1.0)
    let darkModeText = UIColor(red:0.47, green:0.98, blue:0.94, alpha:1.0)
    
    let lightModeBackground = UIColor(red:0.47, green:0.98, blue:0.94, alpha:1.0)
    let lightModeText = UIColor(red:0.08, green:0.07, blue:0.14, alpha:1.0)
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var horizontalDivider: UIView!
    @IBOutlet weak var horizontalDivider2: UIView!
    
    @IBOutlet weak var sleepAnalysisLabel: UILabel!

    @IBOutlet weak var logSleepButton: UIButton!
    @IBOutlet weak var sleepButtonBackground: UIView!
    
    @IBAction func longPressed(_ sender: AnyObject) {
        
        if darkMode == false {
            self.view.backgroundColor = darkModeBackground
            dateLabel.textColor = darkModeText
            dayOfWeekLabel.textColor = darkModeText
            timeLabel.textColor = darkModeText
            sleepAnalysisLabel.textColor = darkModeText
            sleepButtonBackground.backgroundColor = darkModeText
            logSleepButton.setTitleColor(darkModeBackground, for: .normal)
            
            darkMode = true
            
        }else if darkMode == true {
            self.view.backgroundColor = lightModeBackground
            dateLabel.textColor = lightModeText
            dayOfWeekLabel.textColor = lightModeText
            timeLabel.textColor = lightModeText
            sleepAnalysisLabel.textColor = lightModeText
            sleepButtonBackground.backgroundColor = lightModeText
            logSleepButton.setTitleColor(lightModeBackground, for: .normal)
            
            darkMode =  false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        drawDividerLine1()
        drawDividerLine2()
        setTimeAndDate()
        drawButtonDetail()
        retrieveSleepAnalysis()
        
        sleepAnalysisLabel.text = "Analyzing Sleep..."
        
        checkForDarkMode()
        correctTextWidthAndSize()
        adjustButtonSizesForDeviceHeight()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveSleepAnalysis()
        setTime()
    }
    
    func adjustButtonSizesForDeviceHeight() {
        
        if view.bounds.height < 570 { //if running on 5/5c/SE
            
            if let sleepButtonLabel = logSleepButton.titleLabel {
                
                sleepButtonLabel.font = sleepButtonLabel.font.withSize(36)
            }
            
        } else if view.bounds.height > 570 && view.bounds.height < 700 { //if running on 6/6s
            
            if let sleepButtonLabel = logSleepButton.titleLabel {
                
                sleepButtonLabel.font = sleepButtonLabel.font.withSize(38)
            }
            
        } else if view.bounds.height > 700 { //if running on 6+/6s+
            
            if let sleepButtonLabel = logSleepButton.titleLabel {
                
                sleepButtonLabel.font = sleepButtonLabel.font.withSize(40)
            }
        }
    }

    func correctTextWidthAndSize() {
        
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.5
        dayOfWeekLabel.adjustsFontSizeToFitWidth = true
        dayOfWeekLabel.minimumScaleFactor = 0.5
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.minimumScaleFactor = 0.5

    }
    
    func checkForDarkMode() {
        
        let currentDate = NSDate()
        let currentDateComponents = calendar.dateComponents([.hour], from: currentDate as Date)
        
        if currentDateComponents.hour! > 19 {
        
            darkMode = true
            
            self.view.backgroundColor = darkModeBackground
            dateLabel.textColor = darkModeText
            dayOfWeekLabel.textColor = darkModeText
            timeLabel.textColor = darkModeText
            sleepAnalysisLabel.textColor = darkModeText
            sleepButtonBackground.backgroundColor = darkModeText
            logSleepButton.setTitleColor(darkModeBackground, for: .normal)
        }
    }
    
    func drawDividerLine1() {
        
        let lineView = UIView(frame: CGRect(x: 0, y: 11/2, width: view.bounds.width*0.914666667, height: 1))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.darkGray.cgColor
        horizontalDivider.addSubview(lineView)
    }
    
    func drawDividerLine2() {
        
        let lineView = UIView(frame: CGRect(x: 0, y: 11/2, width: view.bounds.width*0.914666667, height: 1))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.darkGray.cgColor
        horizontalDivider2.addSubview(lineView)
    }
    
    func drawButtonDetail() {
        
        logSleepButton.titleLabel?.adjustsFontSizeToFitWidth = true
        logSleepButton.titleLabel?.minimumScaleFactor = 0.5
        
        if view.bounds.height < 660 {
            
            sleepButtonBackground.layer.cornerRadius = 63/2
            
        }else if view.bounds.height == 667 {
            
            sleepButtonBackground.layer.cornerRadius = 74/2
            
        }else if view.bounds.height > 700 {
            
            sleepButtonBackground.layer.cornerRadius = 88/2
        }
        
    }
    
    func setTime() {
        let currentDate = NSDate()
        
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = DateFormatter.Style.long
        let convertedDate = dateFormatter.string(from: currentDate as Date)
        
        dateLabel.text = convertedDate
    }
    
    func setTimeAndDate() {
        let currentDate = NSDate()
        let calendar = Calendar.current
        
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = DateFormatter.Style.long
        let convertedDate = dateFormatter.string(from: currentDate as Date)
        
        dateLabel.text = convertedDate
        
        dateFormatter.dateFormat = "h:mm a"
        let convertedTime = dateFormatter.string(from: currentDate as Date)
        
        timeLabel.text = convertedTime
        
        
        let components = calendar.dateComponents([.month, .day, .weekday], from: currentDate as Date)
        
        switch components.weekday! {
        case 1:
            dayOfWeekLabel.text = "Sunday"
        case 2:
            dayOfWeekLabel.text = "Monday"
        case 3:
            dayOfWeekLabel.text = "Tuesday"
        case 4:
            dayOfWeekLabel.text = "Wednesday"
        case 5:
            dayOfWeekLabel.text = "Thursday"
        case 6:
            dayOfWeekLabel.text = "Friday"
        case 7:
            dayOfWeekLabel.text = "Saturday"
        default:
            dayOfWeekLabel.text = "FAILURE"
        }
    }
    
    func setSleepAnalysisText(duration: String) {

        let text = "Last night, you slept for \(duration)."
        sleepAnalysisLabel.text = text
    }
    
    func retrieveSleepAnalysis() {
        
        // first, we define the object type we want
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            
            // Use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            // we create our query with a block completion to execute
            let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                
                if error != nil {
                    
                    // something happened
                    return
                    
                }
                
                if let result = tmpResult {
                    
                    // do something with my data
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            //let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                            //print("Healthkit sleep: \(sample.startDate) \(sample.endDate) - value: \(value)")
                            
                            let dateComponentsFormatter = DateComponentsFormatter()
                            dateComponentsFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.full
                            
                            let interval = sample.endDate.timeIntervalSince(sample.startDate)
                            
                            self.setSleepAnalysisText(duration: dateComponentsFormatter.string(from: interval)!)
                        }
                    }
                }
            }
            
            // finally, we execute our query
            healthStore.execute(query)
        }
    }
}
