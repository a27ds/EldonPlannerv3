//
//  Performence.swift
//  EldonPlannerv3
//
//  Created by a27 on 2018-02-05.
//  Copyright © 2018 a27. All rights reserved.
//

import Foundation

class Performence {
    var performenceName: String
    var soundcheckTime: String
    var rigUpTime: String
    var showTime: String
    var rigDownTime: String
    var lineUpPlacement: String
    var timeForShow: String
    var timeForChangeOver : String
    var performerTotalTimeInMin: Int
    var changeOverTimeInt : Int
    var soundcheckTimeInt: Int
    var rigUpTimeInt: Int
    var showTimeInt: Int
    var rigDownTimeInt: Int
    var lineUpPlacementInt: Int
    var howManyPerformers: Int
    
    init(performenceName: String, soundcheckTime: String, rigUpTime: String, showTime: String, rigDownTime: String, lineUpPlacement: String, howManyPerformers: Int) {
        self.performenceName = performenceName
        self.soundcheckTime = soundcheckTime
        self.rigUpTime = rigUpTime
        self.showTime = showTime
        self.rigDownTime = rigDownTime
        self.lineUpPlacement = lineUpPlacement
        self.timeForShow = "22:22"
        self.timeForChangeOver = "11:11"
        self.performerTotalTimeInMin = 0
        self.changeOverTimeInt = 0
        self.soundcheckTimeInt = Int(soundcheckTime.dropLast(4))!
        self.rigUpTimeInt = Int(rigUpTime.dropLast(4))!
        self.showTimeInt = Int(showTime.dropLast(4))!
        self.rigDownTimeInt = Int(rigDownTime.dropLast(4))!
        self.lineUpPlacementInt = Int(lineUpPlacement)!
        self.howManyPerformers = howManyPerformers
//        totalShowTimeInMinForPerformers()
    }
//    func totalShowTimeInMinForPerformers() {
//        if lineUpPlacementInt == 1 { //First performer
//            performerTotalTimeInMin = showTimeInt + rigDownTimeInt
//            print(performerTotalTimeInMin)
//        } else if lineUpPlacementInt == howManyPerformers { // Last performer
//            performerTotalTimeInMin = rigUpTimeInt + showTimeInt
//            print(performerTotalTimeInMin)
//        } else { //in the middle performers
//            performerTotalTimeInMin = rigUpTimeInt + showTimeInt + rigDownTimeInt
//            print(performerTotalTimeInMin)
//        }
//    }
}
