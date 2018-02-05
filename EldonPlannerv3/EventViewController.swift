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
    
    
    //  Variabels
    var event: Event? = nil
    var getInCopy: String = ""
    var musicCurfewCopy: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInCopy = (event?.getIn)!
        musicCurfewCopy = (event?.musicCurfew)!
        eventInfo.text = eventInfoText()
    }
    
    //  IBActions
    @IBAction func copyUIBarButtonPressed(_ sender: UIBarButtonItem) {
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
        for preformer in event!.preformers {
            soundcheckInfo.append("Soundcheck \(preformer.preformenceName): \(fromGetInToDinner(preformerTimeInMin: preformer.soundcheckTimeInt, from: (getInCopy)))")
            soundcheckInfo.append("\n")
        }
        return soundcheckInfo
    }
    
    func showInfo () -> String {
        event?.preformers.sort(by: { Int($0.lineUpPlacement)! < Int($1.lineUpPlacement)! }) //Sortera preformers
        var showInfo = String()
        showInfo.append("\n")
        for preformer in event!.preformers {
            showInfo.append("\(preformer.preformenceName): \(fromMusicCurfewToDoors(preformerTimeInMin: preformer.preformerTotalTimeInMin, curfew: (musicCurfewCopy)))")
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
    
    
}
