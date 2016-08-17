//
//  TimeCircleSlider.swift
//  SimpleSleep
//
//  Created by Blair Altland on 7/29/16.
//  Copyright © 2016 Blairaltland. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class TimeCircleSlider: UIControl {
    
    // MARK:  - Circle Attributes
    
    ///Circle Percentage color
    @IBInspectable
    var circleColor: UIColor = UIColor.white {
        didSet {
            circleLayer.fillColor = circleColor.withAlphaComponent(0.1).cgColor
            setNeedsDisplay()
        }
    }
    
    ///Circle Shadow Color
    @IBInspectable
    var trackCircleColor: UIColor = UIColor.gray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    ///Circle Stroke Width
    @IBInspectable
    var circleStrokeWidth: CGFloat = 7 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    ///Circle Shadow Stroke Width
    @IBInspectable
    var trackCircleStrokeWidth: CGFloat = 3.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    ///Circle Thumb Radius
    @IBInspectable
    var circleThumbRadius: CGFloat = 14{
        didSet{
            setNeedsDisplay()
        }
    }
    
    var _time = NSDate() {
        didSet {
            sendActions(for: UIControlEvents.valueChanged)
            setNeedsDisplay()
        }
    }
    
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = DateFormatter.Style.short
        return formatter.string(from: _time as Date)
    }
    
    private struct RadianValuesInCircle {
        static let Quarter = M_PI / 2
        static let Half = M_PI
        static let ThreeQuarters = 3 * M_PI / 2
        static let FullCircle = 2 * M_PI
        static let DoubleCircle = 4 * M_PI
    }
    
    private var isSecondCircle = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Initializers
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentMode = UIViewContentMode.redraw
        
        
        circleLayer.fillColor = circleColor.withAlphaComponent(0.1).cgColor
        self.layer.addSublayer(circleLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - Time
    
    func setTimeWithHours(h: Int, andMinutes m: Int) {
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = NSDateComponents()
        components.hour = Int(h)
        components.minute = Int(m)
        if let date = cal.date(from: components as DateComponents) {
            _time = date as NSDate
            //print(_time)
        }
    }
    
    private func getTimeInHoursFromAngle(a: Double) -> Double {
        return a / (RadianValuesInCircle.Half / 12) ///
    }
    
    
    //Converts time to radians
    private func getRadiansFromTimeInDate(t: NSDate) -> Double {
        let calender: Calendar = Calendar.current
        //let flags: Calendar.Unit = [Calendar.Unit.hour, Calendar.Unit.minute]
        
        let flags = Set<Calendar.Component>([.hour, .year, .minute])
        let components = calender.dateComponents(flags, from: t as Date)
        //let components = calender.components(flags, from: t as Date)
        
        let numberFromTime: Double = Double(components.hour!) + Double(components.minute!) / 60
        let timeInRadians: Double = numberFromTime / 24 * RadianValuesInCircle.FullCircle ///
        
        return timeInRadians
    }
    
    private let circleLayer = CAShapeLayer()
    
    // MARK: - Touch handlers
    
    private var canHandleMoveLeft = true
    private var canHandleMoveRight = true
    private var didStopOnLeftSide = false {
        didSet {
            if didStopOnLeftSide {
                setTimeWithHours(h: 0, andMinutes: 0)
            }
        }
    }
    private var didStopOnRightSide = false {
        didSet {
            if didStopOnRightSide {
                setTimeWithHours(h: 23, andMinutes: 59)
            }
        }
    }
    
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let angle = getAngleFromPoint(p: touch.location(in: self))
        
        let previousAngle = getAngleFromPoint(p: touch.previousLocation(in: self))
        
        if angle > RadianValuesInCircle.ThreeQuarters && previousAngle < RadianValuesInCircle.Quarter  {
            
            canHandleMoveLeft = false
            didStopOnLeftSide = true
            
        } else if angle < RadianValuesInCircle.Quarter && previousAngle > RadianValuesInCircle.ThreeQuarters  {
            
            canHandleMoveRight = false
            didStopOnRightSide = true
            
            if didStopOnLeftSide {
                didStopOnLeftSide = false
            }
            
        } else if (canHandleMoveRight && canHandleMoveLeft) ||
            (!canHandleMoveLeft && angle - previousAngle > 0.0 && angle < RadianValuesInCircle.Quarter) ||
            (!canHandleMoveRight && angle - previousAngle < 0.0 && angle > RadianValuesInCircle.ThreeQuarters) {

            
            let timeInHours =  getTimeInHoursFromAngle(a: angle)

            let hours = floor(timeInHours)
            let minutes = (timeInHours - hours) * 60
            setTimeWithHours(h: Int(hours), andMinutes: Int(minutes))
            
            canHandleMoveLeft = true
            canHandleMoveRight = true
    
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        //        isTracking = false
        canHandleMoveLeft = true
        canHandleMoveRight = true
        didStopOnLeftSide = false
        didStopOnRightSide = false
        sendActions(for: UIControlEvents.valueChanged)
        //print("TAG\(timeString)")
    }
    
    private func getAngleFromPoint(p: CGPoint) -> Double {
        let deltaY = p.y - self.frame.size.height/2
        let deltaX = p.x - self.frame.size.width/2
        let angleEndPoint = Double(atan2(deltaY, deltaX) - radianOffset)
        if angleEndPoint < 0 {
            return angleEndPoint + RadianValuesInCircle.FullCircle
        }
        return angleEndPoint
    }
    
    // MARK: - Draw UI
    
    private let radianOffset = -CGFloat(RadianValuesInCircle.Quarter)
    
    override func draw(_ rect: CGRect) {
        
        //Set up overall size constraints for slider
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = min(bounds.width, bounds.height)/2 - max(circleStrokeWidth, trackCircleStrokeWidth)/2 - circleThumbRadius
        
        //Set color for slider track
        trackCircleColor.set()
        
        //Set size constraints for track
        let trackCircleRect = CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2)
        let trackCirclePath = UIBezierPath(ovalIn: trackCircleRect)
        trackCirclePath.lineWidth = trackCircleStrokeWidth //Set the width of the track
        trackCirclePath.stroke() //Create the line along the path
        
        //Main Circle
        circleColor.set()
        let circleRounedBeginningRect = CGRect(
            x: center.x - circleStrokeWidth/2,
            y: center.y - radius - circleStrokeWidth/2,
            width: circleStrokeWidth,
            height: circleStrokeWidth)
        let circleRounedBeginningPath = UIBezierPath(ovalIn: circleRounedBeginningRect)
        circleRounedBeginningPath.fill()
        
        //
        let startAngle = 0 + radianOffset
        let endAngle = CGFloat(getRadiansFromTimeInDate(t: _time)) + radianOffset
        
        let circleForTimePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        circleForTimePath.lineWidth = circleStrokeWidth
        circleForTimePath.stroke()
        
        // Primary circle Thumb
        let endAngleForPoint: CGFloat = endAngle - startAngle + radianOffset
        let xYOffset = -circleThumbRadius
        let endAnglePoint: CGPoint = CGPoint(
            x: bounds.width/2 + cos(endAngleForPoint) * radius + xYOffset,
            y: bounds.height/2 + sin(endAngleForPoint) * radius + xYOffset)
        
        let circleHandleRect = CGRect(
            x: endAnglePoint.x - xYOffset/2,
            y: endAnglePoint.y - xYOffset/2,
            width: circleThumbRadius,
            height: circleThumbRadius)
        let circleHandlePath = UIBezierPath(ovalIn: circleHandleRect)
        circleHandlePath.fill()
        
        
        // Primary circle Thumb background
        if isTracking {
            circleColor.withAlphaComponent(0.2).set()
            let circleHandleBackgroundRect = CGRect(
                origin: endAnglePoint,
                size: CGSize(width: circleThumbRadius*2, height: circleThumbRadius*2))
            
            let circleHandleBackgroundPath = UIBezierPath(ovalIn: circleHandleBackgroundRect)
            circleHandleBackgroundPath.fill()
        }
    }
}
