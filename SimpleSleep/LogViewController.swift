//
//  LogViewController.swift
//  SimpleSleep
//
//  Created by Blair Altland on 8/1/16.
//  Copyright © 2016 Blairaltland. All rights reserved.
//

import UIKit
import HealthKit

class LogViewController: UIViewController {
    
    //Variables
    let healthStore = HKHealthStore()
    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    let dateFormatter = DateFormatter()
    let currentDate = NSDate()
    var toSleep = NSDate()
    var wokeUp = NSDate()
    var darkMode = false
    var lineView = UIView()
    
    //Colors
    let darkModeBackground = UIColor(red:0.08, green:0.07, blue:0.14, alpha:1.0)
    let darkModeText = UIColor(red:0.47, green:0.98, blue:0.94, alpha:1.0)
    
    let lightModeBackground = UIColor(red:0.47, green:0.98, blue:0.94, alpha:1.0)
    let lightModeText = UIColor(red:0.08, green:0.07, blue:0.14, alpha:1.0)
    
    //UI Elements
    @IBOutlet weak var bedTimeLabel: UILabel!
    @IBOutlet weak var wakeUpLabel: UILabel!
    @IBOutlet weak var bedTimeSlider: TimeCircleSlider!
    @IBOutlet weak var wakeUpTimeSlider: TimeCircleSlider!
    @IBOutlet weak var detailCircle: UIView!
    @IBOutlet weak var horizontalDivider: UIView!
    @IBOutlet weak var saveButtonBackground: UIView!
    @IBOutlet weak var cancelButtonBackground: UIView!
    @IBOutlet weak var wentToBedLabel: UILabel!
    @IBOutlet weak var wokeUpAtLabel: UILabel!
    

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func save(_ sender: AnyObject) {
        
        saveSleepAnalysis()
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var dismiss: UIButton!
    @IBAction func dismissView(_ sender: AnyObject) {
    
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressed(_ sender: AnyObject) {
        
        if darkMode == false {
            
            self.view.backgroundColor = darkModeBackground
            bedTimeLabel.textColor = darkModeText
            wakeUpLabel.textColor = darkModeText
            saveButton.setTitleColor(darkModeBackground, for: .normal)
            saveButtonBackground.backgroundColor = darkModeText
            cancelButtonBackground.backgroundColor = darkModeText
            dismiss.setTitleColor(darkModeBackground, for: .normal)
            detailCircle.backgroundColor = #colorLiteral(red: 0.4266758859, green: 0.4266631007, blue: 0.4266703427, alpha: 1)
            wentToBedLabel.textColor = darkModeText
            wokeUpAtLabel.textColor = darkModeText
            
            bedTimeSlider.circleColor = darkModeText
            bedTimeSlider.trackCircleColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            
            wakeUpTimeSlider.circleColor = darkModeText
            wakeUpTimeSlider.trackCircleColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            
            lineView.layer.borderColor = darkModeText.cgColor
            
            darkMode = true
            
        }else if darkMode == true {
            
            self.view.backgroundColor = lightModeBackground
            bedTimeLabel.textColor = lightModeText
            wakeUpLabel.textColor = lightModeText
            saveButton.setTitleColor(lightModeBackground, for: .normal)
            saveButtonBackground.backgroundColor = lightModeText
            cancelButtonBackground.backgroundColor = lightModeText
            dismiss.setTitleColor(lightModeBackground, for: .normal)
            detailCircle.backgroundColor = #colorLiteral(red: 0.7602152824, green: 0.7601925135, blue: 0.7602053881, alpha: 1)
            wentToBedLabel.textColor = lightModeText
            wokeUpAtLabel.textColor = lightModeText
            
            bedTimeSlider.circleColor = lightModeText
            bedTimeSlider.trackCircleColor = #colorLiteral(red: 0.7602152824, green: 0.7601925135, blue: 0.7602053881, alpha: 1)
            
            wakeUpTimeSlider.circleColor = lightModeText
            wakeUpTimeSlider.trackCircleColor = #colorLiteral(red: 0.7602152824, green: 0.7601925135, blue: 0.7602053881, alpha: 1)
            
            lineView.layer.borderColor = lightModeText.cgColor
            
            darkMode = false
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //drawDividerLine()
        drawButtonDetail()
        configureSliderSettings()
        initiallySetTimeText()
        checkForDarkMode()
        adjustButtonDetails()
        adjustTextSizeForDeviceHeight()
        adjustDetailsForDeviceHeight()
        adjustButtonSizesForDeviceHeight()
 
    }
    
    func valueChange(_ sender: TimeCircleSlider) {
        
        switch sender.tag {
            
        case 0:
            bedTimeLabel.text = sender.timeString
            toSleep = constructHealthKitReadyNSDate(time: sender._time)

        case 1:
            wakeUpLabel.text = sender.timeString
            wokeUp = constructHealthKitReadyNSDate(time: sender._time)
            
        default:
            break
        }
    }
    
    //Handle Multply Device Sizes
    func adjustButtonSizesForDeviceHeight() {
        
        if view.bounds.height < 570 { //if running on 5/5c/SE
            
            if let saveButtonLabel = saveButton.titleLabel {
                
                saveButtonLabel.font = saveButtonLabel.font.withSize(33)
            }
            
            if let cancelButtonLabel = cancelButton.titleLabel {
                
                cancelButtonLabel.font = cancelButtonLabel.font.withSize(22)
            }
            
        } else if view.bounds.height > 570 && view.bounds.height < 700 { //if running on 6/6s
            
            if let saveButtonLabel = saveButton.titleLabel {
                
                saveButtonLabel.font = saveButtonLabel.font.withSize(35)
            }
            
            if let cancelButtonLabel = cancelButton.titleLabel {
                
                cancelButtonLabel.font = cancelButtonLabel.font.withSize(25)
            }
            
        } else if view.bounds.height > 700 { //if running on 6+/6s+
            
            if let saveButtonLabel = saveButton.titleLabel {
                
                saveButtonLabel.font = saveButtonLabel.font.withSize(37)
            }
            
            if let cancelButtonLabel = cancelButton.titleLabel {
                
                cancelButtonLabel.font = cancelButtonLabel.font.withSize(27)
            }
        }
    }
    func adjustButtonDetails() {
        
        saveButton.titleLabel?.adjustsFontSizeToFitWidth = true
        saveButton.titleLabel?.minimumScaleFactor = 0.5
        
        cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cancelButton.titleLabel?.minimumScaleFactor = 0.5
        
        if view.bounds.height < 570 { //if running on 5/5c/SE
            
            saveButtonBackground.layer.cornerRadius = 57/2
            cancelButtonBackground.layer.cornerRadius = 44/2
            
        } else if view.bounds.height > 570 && view.bounds.height < 700 { //if running on 6/6s
            
            saveButtonBackground.layer.cornerRadius = 67/2
            cancelButtonBackground.layer.cornerRadius = 52/2
            
        } else if view.bounds.height > 700 { //if running on 6+/6s+
            
            saveButtonBackground.layer.cornerRadius = 73.87/2
            cancelButtonBackground.layer.cornerRadius = 57.67/2
        }
    }
    func adjustTextSizeForDeviceHeight() {
        
        if view.bounds.height < 570 { //if running on 5/5c/SE
            
            bedTimeLabel.font = bedTimeLabel.font.withSize(24)
            wakeUpLabel.font = wakeUpLabel.font.withSize(24)
            
            wentToBedLabel.font = wentToBedLabel.font.withSize(13)
            wokeUpAtLabel.font = wokeUpAtLabel.font.withSize(13)
            
        } else if view.bounds.height > 570 && view.bounds.height < 700 { //if running on 6/6s
            
            saveButtonBackground.layer.cornerRadius = 67/2
            cancelButtonBackground.layer.cornerRadius = 52/2
            
        } else if view.bounds.height > 700 { //if running on 6+/6s+
            
            
        }
    }
    func adjustDetailsForDeviceHeight() {

        if view.bounds.height < 570 { //if running on 5/5c/SE
            
            detailCircle.layer.cornerRadius = 158/2
            
        } else if view.bounds.height > 570 && view.bounds.height < 700 { //if running on 6/6s
            
            detailCircle.layer.cornerRadius = 186/2
            
        } else if view.bounds.height > 700 { //if running on 6+/6s+
            
            detailCircle.layer.cornerRadius = 205/2
        }
    }
    
    //Initial View Setup
    func configureSliderSettings() {
        
        bedTimeSlider.circleColor = lightModeText
        bedTimeSlider.circleStrokeWidth = 6
        bedTimeSlider.circleThumbRadius = 15
        bedTimeSlider.trackCircleColor = #colorLiteral(red: 0.7602152824, green: 0.7601925135, blue: 0.7602053881, alpha: 1)
        bedTimeSlider.trackCircleStrokeWidth = 4
        bedTimeSlider.setTimeWithHours(h: getEstimatedBedTimeHour(), andMinutes: getEstimatedBedTimeMinute())
        
        wakeUpTimeSlider.circleColor = lightModeText
        wakeUpTimeSlider.circleStrokeWidth = 6
        wakeUpTimeSlider.circleThumbRadius = 15
        wakeUpTimeSlider.trackCircleColor = #colorLiteral(red: 0.7602152824, green: 0.7601925135, blue: 0.7602053881, alpha: 1)
        wakeUpTimeSlider.trackCircleStrokeWidth = 4
        
        bedTimeSlider.addTarget(self, action: #selector(LogViewController.valueChange(_:)), for: .valueChanged)
        wakeUpTimeSlider.addTarget(self, action: #selector(LogViewController.valueChange(_:)), for: .valueChanged)
        bedTimeSlider.tag = 0
        wakeUpTimeSlider.tag = 1
    }
    func initiallySetTimeText() {
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        let wakeTime = dateFormatter.string(from: currentDate as Date)
        
        let bedTime = dateFormatter.string(from: (calendar.date(byAdding: .hour, value: -8, to: currentDate as Date))!)
        bedTimeLabel.text = bedTime
        wakeUpLabel.text = wakeTime
    }
    func drawDividerLine() {
        
        lineView = UIView(frame: CGRect(x: 0, y: horizontalDivider.bounds.height/2, width: horizontalDivider.bounds.width, height: 1))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = #colorLiteral(red: 0.4136289358, green: 0.9786638021, blue: 0.9273311496, alpha: 1).cgColor
        horizontalDivider.addSubview(lineView)
        
    }
    func drawButtonDetail() {
        
        if view.bounds.height < 660 {
            
            saveButtonBackground.layer.cornerRadius = 66.6/2
            cancelButtonBackground.layer.cornerRadius = 44/2
            
        }else if view.bounds.height == 667 {
            
            saveButtonBackground.layer.cornerRadius = 66.6/2
            cancelButtonBackground.layer.cornerRadius = 51.8/2
        }
        
    }
    
    func getEstimatedBedTimeHour() -> Int {
        
        let bedTime = (calendar.date(byAdding: .hour, value: -8, to: currentDate as Date))! as Date
        //let bedTime = (calendar.date(byAdding: .hour, value: -8, to: currentDate as Date, options: []))! as Date
        let bedTimeComponents = calendar.dateComponents([.hour], from: bedTime as Date)
       
        return (bedTimeComponents.hour)!
    }
    func getEstimatedBedTimeMinute() -> Int {
        
        let bedTime = (calendar.date(byAdding: .hour, value: -8, to: currentDate as Date, wrappingComponents: true))! as Date
        //let bedTime = (calendar.date(byAdding: .hour, value: -8, to: currentDate as Date, options: []))! as Date
        let bedTimeComponents = calendar.dateComponents([.minute], from: bedTime as Date)
        
        return (bedTimeComponents.minute)!
    }
    
    func saveSleepAnalysis() {
        
        // alarmTime and endTime are NSDate objects
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
        
            let sleepTime = HKCategorySample(type: sleepType, value: HKCategoryValueSleepAnalysis.asleep.rawValue, start: toSleep as Date, end: wokeUp as Date)
            
            healthStore.save(sleepTime, withCompletion: { (success, error) -> Void in
                if error != nil {
                    // something happened
                    return
                }
                
                if success {
                    print("My new data  was saved in HealthKit")
                } else {
                    // something happened again
                }
                
            })
        }
    }
    
    func constructHealthKitReadyNSDate(time: NSDate) -> NSDate{
        
        //Check to see if date is before or after 9:30 PM
        let components = NSDateComponents()
        components.hour = 19
        components.minute = 59
        components.second = 0
        
        let compareToDate = calendar.date(from: components as DateComponents)
        
        var returnDate = NSDate()

        //If the slider time is before the compareToTime
        if compareToDate?.compare(time as Date) == ComparisonResult.orderedDescending {

            let currentDateComponents = calendar.dateComponents([.month, .day, .year], from: currentDate as Date)
            let sliderComponents = calendar.dateComponents([.minute, .hour, .second], from: time as Date)
            
            let sliderDateComponents = NSDateComponents()
            sliderDateComponents.year = (currentDateComponents.year)!
            sliderDateComponents.month = (currentDateComponents.month)!
            sliderDateComponents.day = (currentDateComponents.day)!
            sliderDateComponents.hour = (sliderComponents.hour)!
            sliderDateComponents.minute = (sliderComponents.minute)!
            sliderDateComponents.second = 0
            
            returnDate = (calendar.date(from: sliderDateComponents as DateComponents))! as NSDate
            
        }
        else if compareToDate?.compare(time as Date) == ComparisonResult.orderedAscending {
            

            let yesterday = (calendar.date(byAdding: .day, value: -1, to: NSDate() as Date, wrappingComponents: true))
            
            let yesterdayDateComponents = calendar.dateComponents([.month, .day, .year], from: yesterday! as Date)
            let sliderComponents = calendar.dateComponents([.minute, .hour, .second], from: time as Date)
            
            let sliderDateComponents = NSDateComponents()
            sliderDateComponents.year = (yesterdayDateComponents.year)!
            sliderDateComponents.month = (yesterdayDateComponents.month)!
            sliderDateComponents.day = (yesterdayDateComponents.day)!
            sliderDateComponents.hour = (sliderComponents.hour)!
            sliderDateComponents.minute = (sliderComponents.minute)!
            sliderDateComponents.second = 0
            
            returnDate = (calendar.date(from: sliderDateComponents as DateComponents))! as NSDate
            
        }
        return returnDate
    }
    
    func checkForDarkMode() {
        
        let currentDate = NSDate()
        let currentDateComponents = calendar.dateComponents([.hour], from: currentDate as Date)
        
        if currentDateComponents.hour! > 19 {
            
            darkMode = true
            
            self.view.backgroundColor = darkModeBackground
            bedTimeLabel.textColor = darkModeText
            wakeUpLabel.textColor = darkModeText
            saveButton.setTitleColor(darkModeBackground, for: .normal)
            saveButtonBackground.backgroundColor = darkModeText
            cancelButtonBackground.backgroundColor = darkModeText
            dismiss.setTitleColor(darkModeBackground, for: .normal)
            detailCircle.backgroundColor = #colorLiteral(red: 0.4266758859, green: 0.4266631007, blue: 0.4266703427, alpha: 1)
            wentToBedLabel.textColor = darkModeText
            wokeUpAtLabel.textColor = darkModeText
            
            bedTimeSlider.circleColor = darkModeText
            bedTimeSlider.trackCircleColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        
            wakeUpTimeSlider.circleColor = darkModeText
            wakeUpTimeSlider.trackCircleColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            
            horizontalDivider.backgroundColor = darkModeText
            
        }else {
            
            detailCircle.backgroundColor = UIColor.lightGray
            horizontalDivider.backgroundColor = lightModeText
        }
    }

}
