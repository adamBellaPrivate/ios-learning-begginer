//
//  BAGridEvent.swift
//  GridTestProject
//
//  Created by Ádám Bella on 9/18/17.
//  Copyright © 2017 Ádám Bella. All rights reserved.
//

import UIKit

class BAGridEvent: NSObject {
    var title = ""
    var backgroundColor = UIColor.white
    var startTimeInMin = 0
    var endTimeInMin = 0
    var columnNumber = 0
    var borderWidth = 0
    var borderColor = UIColor.clear
    var textColor = UIColor.white
    
    init(_ title : String, backgroundColor : UIColor = UIColor.white, startTimeInMin : Int, endTimeInMin : Int, columnNumber : Int, borderWidth : Int = 0, borderColor : UIColor = .clear, textColor : UIColor = .white) {
        super.init()
        self.title = title
        self.backgroundColor = backgroundColor
        self.startTimeInMin = startTimeInMin
        self.endTimeInMin = endTimeInMin
        self.columnNumber = columnNumber
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.textColor = textColor
    }
}
