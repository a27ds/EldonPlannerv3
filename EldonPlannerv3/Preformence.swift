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
    var rigUpTime: String
    var showTime: String
    var rigDownTime: String
    var lineUpPlacement: String
    var timeForShow: String
    var timeForChangeOver : String
    var preformerTotalTimeInMin: Int
    var changeOverTimeInt : Int
    var soundcheckTimeInt: Int
    var rigUpTimeInt: Int
    var showTimeInt: Int
    var rigDownTimeInt: Int
    var lineUpPlacementInt: Int
    var howManyPreformers: Int
    
    init(preformenceName: String, soundcheckTime: String, rigUpTime: String, showTime: String, rigDownTime: String, lineUpPlacement: String, howManyPreformers: Int) {
        self.preformenceName = preformenceName
        self.soundcheckTime = soundcheckTime
        self.rigUpTime = rigUpTime
        self.showTime = showTime
        self.rigDownTime = rigDownTime
        self.lineUpPlacement = lineUpPlacement
        self.timeForShow = "22:22"
        self.timeForChangeOver = "11:11"
        self.preformerTotalTimeInMin = 0
        self.changeOverTimeInt = 0
        self.soundcheckTimeInt = Int(soundcheckTime.dropLast(4))!
        self.rigUpTimeInt = Int(rigUpTime.dropLast(4))!
        self.showTimeInt = Int(showTime.dropLast(4))!
        self.rigDownTimeInt = Int(rigDownTime.dropLast(4))!
        self.lineUpPlacementInt = Int(lineUpPlacement)!
        self.howManyPreformers = howManyPreformers
//        totalShowTimeInMinForPreformers()
    }
//    func totalShowTimeInMinForPreformers() {
//        if lineUpPlacementInt == 1 { //First preformer
//            preformerTotalTimeInMin = showTimeInt + rigDownTimeInt
//            print(preformerTotalTimeInMin)
//        } else if lineUpPlacementInt == howManyPreformers { // Last preformer
//            preformerTotalTimeInMin = rigUpTimeInt + showTimeInt
//            print(preformerTotalTimeInMin)
//        } else { //in the middle preformers
//            preformerTotalTimeInMin = rigUpTimeInt + showTimeInt + rigDownTimeInt
//            print(preformerTotalTimeInMin)
//        }
//    }
}
