//
//  Preformence.swift
//  EldonPlannerv3
//
//  Created by a27 on 2018-02-05.
//  Copyright © 2018 a27. All rights reserved.
//

import Foundation

class Preformence {
    var preformenceName: String
    var soundcheckTime: String
    var changeOverTime: String
    var showTime: String
    var lineUpPlacement: String
    var timeForShow: String
    var preformerTotalTimeInMin: Int
    var soundcheckTimeInt: Int
    var changeOverInt: Int
    var showTimeInt: Int
    var lineUpPlacementInt: Int
    var howManyPreformers: Int
    
    init(preformenceName: String, soundcheckTime: String, changeOverTime: String, showTime: String, lineUpPlacement: String, howManyPreformers: Int) {
        self.preformenceName = preformenceName
        self.soundcheckTime = soundcheckTime
        self.changeOverTime = changeOverTime
        self.showTime = showTime
        self.lineUpPlacement = lineUpPlacement
        self.timeForShow = "22:22"
        self.preformerTotalTimeInMin = 0
        self.soundcheckTimeInt = Int(soundcheckTime.dropLast(4))!
        self.changeOverInt = Int(changeOverTime.dropLast(4))!
        self.showTimeInt = Int(showTime.dropLast(4))!
        self.lineUpPlacementInt = Int(lineUpPlacement)!
        self.howManyPreformers = howManyPreformers
        totalShowTimeInMinForPreformers()
    }
    
    func totalShowTimeInMinForPreformers() {
            preformerTotalTimeInMin = showTimeInt + changeOverInt
            print(preformerTotalTimeInMin)
    }
}
