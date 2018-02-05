//
//  Event.swift
//  EldonPlannerv3
//
//  Created by a27 on 2018-02-05.
//  Copyright © 2018 a27. All rights reserved.
//

import Foundation

class Event {
    var preformers = [Preformence]()
    var date: String
    var getIn: String
    var dinner: String
    var doors: String
    var musicCurfew: String
    var venueCurfew: String
    var howManyPreformers: Int
    var showTimeTotalInMin: Int
    var soundcheckTimeTotalInMin: Int
    
    init(date: String, getIn: String, dinner: String, doors: String, musicCurfew: String, venueCurfew: String, howManyPreformers: Int) {
        self.date = date
        self.getIn = getIn
        self.dinner = dinner
        self.doors = doors
        self.musicCurfew = musicCurfew
        self.venueCurfew = venueCurfew
        self.howManyPreformers = howManyPreformers
        self.showTimeTotalInMin = 0
        self.soundcheckTimeTotalInMin = 0
        getTotalTime()
    }
    
    func getTotalTime() {
        showTimeTotalInMin = calculateTimeDifference(start: doors, end: musicCurfew)
        soundcheckTimeTotalInMin = calculateTimeDifference(start: getIn, end: dinner)
    }
    
    func calculateTimeDifference(start: String, end: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let sixOClock = formatter.date(from: "06:00")
        let startString = "\(start)"
        let endString = "\(end)"
        let startDate = formatter.date(from: startString)!
        var endDate = formatter.date(from: endString)!
        if sixOClock! > endDate {
            endDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate)!
        }
        let difference = endDate.timeIntervalSince(startDate)
        return Int(difference) / 60
    }
}
