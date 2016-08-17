//
//  CircleSliderDetail.swift
//  SimpleSleep
//
//  Created by Blair Altland on 8/15/16.
//  Copyright © 2016 Blairaltland. All rights reserved.
//

import Foundation

import UIKit

class CircleSliderDetail: UIView {
    
    var iconColor = UIColor.lightGray
    //let wentToBedLabel = "I went to bed at:"
    //let wokeUpLabel = "I woke up at:"
    var bedTimeLabel = UILabel()
    //var wokeUpTimeLabel = ""
    var dividerColor = UIColor.white
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        iconColor.setFill()
        path.fill()
        
        
    ///draw horizontal line
        /*
        let centerView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 5))
        
        //Dimensions
        let height = rect.height
        let width = rect.width
        let middle = height/2
        let margin = width*0.043243243
        
        let horizontalLineDivider = UIBezierPath()
        horizontalLineDivider.move(to: CGPoint(x: margin, y: middle))
        horizontalLineDivider.addLine(to: CGPoint(x: width-margin, y: middle))
        dividerColor.setStroke()
        horizontalLineDivider.lineWidth = 2
        horizontalLineDivider.stroke()

        //set label positions
        let timeLabelWidth = width*0.956756757
        let timeLabelHeight = 0.194594595*height
        bedTimeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: timeLabelWidth, height: timeLabelHeight))
        bedTimeLabel.center = CGPoint(x: timeLabelWidth/2, y: timeLabelHeight/2)
        bedTimeLabel.textAlignment = NSTextAlignment.center
        bedTimeLabel.textColor = dividerColor
        bedTimeLabel.adjustsFontSizeToFitWidth = true
        bedTimeLabel.text = "Test"
        bedTimeLabel.font = UIFont.boldSystemFont(ofSize: 30)
        self.addSubview(bedTimeLabel)
        
        
        
        */
        
        
        // create the constraints with the constant value you want.
        //let verticalSpace = NSLayoutConstraint(item: bedTimeLabel, attribute: .bottom, relatedBy: .equal, toItem: TimeLabel, attribute: .bottom, multiplier: 2, constant: 10)
        
        //let verticalSpace = NSLayoutConstraint(item: bedTimeLabel, attribute: .bottom, relatedBy: .equal, toItem: TimeLabel, attribute: .bottom, multiplier: 1, constant: 100)
        
        // activate the constraints
        //NSLayoutConstraint.activate([verticalSpace])
        
        //bedTimeLabel.addConstraint(verticalSpace)
    }
}
