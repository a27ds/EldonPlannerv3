//
//  EventViewController.swift
//  EldonPlannerv3
//
//  Created by a27 on 2018-02-05.
//  Copyright © 2018 a27. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    //  IBOutlets
    @IBOutlet weak var eventInfo: UITextView!
    @IBOutlet weak var eventNavBar: UINavigationItem!
    
    //  Variabels
    var event: Event? = nil
    
    var getInCopy: String = ""
    var musicCurfewCopy: String = ""
    
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        testRun()
        getInCopy = (event?.getIn)!
        musicCurfewCopy = (event?.musicCurfew)!
        eventInfo.text = eventInfoText()
        makeCopyButton()
    }
    
    //  Methods --> Button becomes visable
    func makeCopyButton () {
        let copyButtonItem = UIBarButtonItem(title: "Copy", style: .plain, target: self, action: #selector(self.doneButtonFunc))
        eventNavBar.rightBarButtonItem = copyButtonItem
    }
    
    @objc func doneButtonFunc() {
        UIPasteboard.general.string = eventInfo.text
    }
    
    //  Methods --> Create Event Info
    func eventInfoText() -> String{
        let eventInfoTextString: String = """
        Get in: \((event!.getIn))
        \(soundcheckInfo())
        Dinner: \((event!.dinner))
        Doors: \((event!.doors))
        \((showInfo()))
        Live Music Curfew: \((event!.musicCurfew)) STRICT
        Venue Curfew: \((event!.venueCurfew))
        """
        return eventInfoTextString
    }
    
    func soundcheckInfo () -> String {
        event?.preformers.sort(by: { Int($0.lineUpPlacement)! > Int($1.lineUpPlacement)! }) //Sortera preformers
        var soundcheckInfo = String()
        soundcheckInfo.append("\n")
        soundcheckInfo.append("Soundcheck \((String(describing: event!.preformers[0].preformenceName))): \((String(describing: event!.getIn))) (\(String(describing: event!.preformers[0].soundcheckTimeInt)) min)")
        soundcheckInfo.append("\n")
        getInCopy = fromGetInToDinner(preformerTimeInMin: (event?.preformers[0].soundcheckTimeInt)!, from: (getInCopy))
        let lastPreformerSave = event?.preformers[0]
        event?.preformers.remove(at: 0)
        for preformer in event!.preformers {
            soundcheckInfo.append("Soundcheck \(preformer.preformenceName): \(getInCopy) (\(String(describing: preformer.soundcheckTimeInt)) min)")
            soundcheckInfo.append("\n")
            getInCopy = fromGetInToDinner(preformerTimeInMin: preformer.soundcheckTimeInt, from: (getInCopy))
        }
        event?.preformers.insert(lastPreformerSave!, at: 0)
        return soundcheckInfo
    }
    
    func showInfo () -> String {
        event?.preformers.sort(by: { Int($0.lineUpPlacement)! > Int($1.lineUpPlacement)! }) //Sortera preformers
        for preformer in event!.preformers {
            preformer.timeForShow = fromMusicCurfewToDoors(preformerTimeInMin: preformer.preformerTotalTimeInMin, curfew: (musicCurfewCopy))
        }
        event?.preformers.sort(by: { Int($0.lineUpPlacement)! < Int($1.lineUpPlacement)! }) //Sortera preformers
        var showInfo = String()
        showInfo.append("\n")
        for preformer in event!.preformers {
            showInfo.append("\(preformer.preformenceName): \(preformer.timeForShow) (\(String(describing: preformer.showTimeInt)) min)")
            showInfo.append("\n")
        }
        return showInfo
    }
    
    //  Methods --> Time conversion
    func fromGetInToDinner(preformerTimeInMin: Int, from: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let tuplet = minutesToHoursMinutes(minutes: preformerTimeInMin)
        var musicCurfew = formatter.date(from: from)!
        musicCurfew = Calendar.current.date(byAdding: .hour, value: tuplet.hours, to: musicCurfew)!
        musicCurfew = Calendar.current.date(byAdding: .minute, value: tuplet.leftMinutes, to: musicCurfew)!
        getInCopy = formatter.string(from: musicCurfew)
        return getInCopy
    }
    
    func fromMusicCurfewToDoors(preformerTimeInMin: Int, curfew: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let tuplet = minutesToHoursMinutes(minutes: preformerTimeInMin)
        var musicCurfew = formatter.date(from: curfew)!
        musicCurfew = Calendar.current.date(byAdding: .hour, value: -tuplet.hours, to: musicCurfew)!
        musicCurfew = Calendar.current.date(byAdding: .minute, value: -tuplet.leftMinutes, to: musicCurfew)!
        musicCurfewCopy = formatter.string(from: musicCurfew)
        return musicCurfewCopy
    }
    
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    //  Tester
    func testRun() {
        event = Event(date: "", getIn: "15:00", dinner: "18:00", doors: "19:00", musicCurfew: "22:00", venueCurfew: "00:00", howManyPreformers: 3)
        event?.preformers.append(Preformence(preformenceName: "Första", soundcheckTime: "30 min", rigUpTime: "15 min", showTime: "30 min", rigDownTime: "15 min", lineUpPlacement: "1", howManyPreformers: (event?.howManyPreformers)!))
        event?.preformers.append(Preformence(preformenceName: "Andra", soundcheckTime: "60 min", rigUpTime: "15 min", showTime: "30 min", rigDownTime: "15 min", lineUpPlacement: "2", howManyPreformers: (event?.howManyPreformers)!))
        event?.preformers.append(Preformence(preformenceName: "Sista", soundcheckTime: "30 min", rigUpTime: "15 min", showTime: "30 min", rigDownTime: "15 min", lineUpPlacement: "3", howManyPreformers: (event?.howManyPreformers)!))
    }
}

