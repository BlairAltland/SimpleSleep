//
//  SecondSlideViewController.swift
//  SimpleSleep
//
//  Created by Blair Altland on 8/10/16.
//  Copyright © 2016 Blairaltland. All rights reserved.
//

import UIKit

class SecondSlideViewController: UIViewController {
    
    @IBOutlet weak var bedTimeSlider: TimeCircleSlider!
    @IBOutlet weak var wakeUpSlider: TimeCircleSlider!
    @IBOutlet weak var bedTimeLabel: UILabel!
    @IBOutlet weak var wakeUpLabel: UILabel!
    @IBOutlet weak var detailCircle: UIView!
    @IBOutlet weak var wentToBedLabel: UILabel!
    @IBOutlet weak var wokeUpLabel: UILabel!
    
    
    
    //Colors
    let darkModeBackground = UIColor(red:0.08, green:0.07, blue:0.14, alpha:1.0)
    let darkModeText = UIColor(red:0.47, green:0.98, blue:0.94, alpha:1.0)
    
    let lightModeBackground = UIColor(red:0.47, green:0.98, blue:0.94, alpha:1.0)
    let lightModeText = UIColor(red:0.08, green:0.07, blue:0.14, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSliderSettings()
        detailCircle.layer.cornerRadius = 149/2
        
        bedTimeLabel.adjustsFontSizeToFitWidth = true
        bedTimeLabel.minimumScaleFactor = 0.5
        wakeUpLabel.adjustsFontSizeToFitWidth = true
        wakeUpLabel.minimumScaleFactor = 0.5
        
        wentToBedLabel.adjustsFontSizeToFitWidth = true
        wentToBedLabel.minimumScaleFactor = 0.5
        wakeUpLabel.adjustsFontSizeToFitWidth = true
        wakeUpLabel.minimumScaleFactor = 0.5
    }
    
    func valueChange(_ sender: TimeCircleSlider) {
        
        switch sender.tag {
            
        case 0:
            bedTimeLabel.text = sender.timeString
            
        case 1:
            wakeUpLabel.text = sender.timeString
            
        default:
            break
        }
    }
    


    func configureSliderSettings() {
        
        bedTimeSlider.circleColor = lightModeText
        bedTimeSlider.circleStrokeWidth = 6
        bedTimeSlider.circleThumbRadius = 15
        bedTimeSlider.trackCircleColor = #colorLiteral(red: 0.7602152824, green: 0.7601925135, blue: 0.7602053881, alpha: 1)
        bedTimeSlider.trackCircleStrokeWidth = 4
        
        
        wakeUpSlider.circleColor = lightModeText
        wakeUpSlider.circleStrokeWidth = 6
        wakeUpSlider.circleThumbRadius = 15
        wakeUpSlider.trackCircleColor = #colorLiteral(red: 0.7602152824, green: 0.7601925135, blue: 0.7602053881, alpha: 1)
        wakeUpSlider.trackCircleStrokeWidth = 4
        
        bedTimeSlider.addTarget(self, action: #selector(LogViewController.valueChange(_:)), for: .valueChanged)
        wakeUpSlider.addTarget(self, action: #selector(LogViewController.valueChange(_:)), for: .valueChanged)
        bedTimeSlider.tag = 0
        wakeUpSlider.tag = 1
    }

}
