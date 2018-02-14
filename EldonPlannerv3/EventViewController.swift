//
//  EventViewController.swift
//  EldonPlannerv3
//
//  Created by a27 on 2018-02-05.
//  Copyright © 2018 a27. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //  IBOutlets
    @IBOutlet weak var eventInfo: UITextView!
    @IBOutlet weak var eventNavBar: UINavigationItem!
    @IBOutlet weak var eventSideMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventSideMenuTableView: UITableView!
    
    //  Variabels
    var event: Event? = nil
    var getInCopy: String = ""
    var musicCurfewCopy: String = ""
    var sideMenuIsHidden = true
    
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
//        testRun()
        getInCopy = (event?.getIn)!
        musicCurfewCopy = (event?.musicCurfew)!
        eventInfo.text = eventInfoText()
        makeButtons()
        setSideMenuConstraint(value: -150)
        eventSideMenuTableView.delegate = self
        eventSideMenuTableView.dataSource = self
        eventSideMenuTableView.alwaysBounceVertical = false
        eventSideMenuTableView.tableFooterView = UIView()
    }
    
    //  Methods --> Button becomes visable
    func makeButtons () {
        let copyButtonItem = UIBarButtonItem(title: "Copy", style: .plain, target: self, action: #selector(self.copyButtonFunc))
        eventNavBar.rightBarButtonItem = copyButtonItem
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editButtonFunc))
        eventNavBar.leftBarButtonItem = editButton
    }
    
    @objc func copyButtonFunc() {
        UIPasteboard.general.string = eventInfo.text
    }
    
    func setSideMenuConstraint(value: CGFloat) {
        eventSideMenuConstraint.constant = value
    }
    
    @objc func editButtonFunc() {
        if sideMenuIsHidden {
            setSideMenuConstraint(value: 0)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            setSideMenuConstraint(value: -150)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        sideMenuIsHidden = !sideMenuIsHidden
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
        event?.performers.sort(by: { Int($0.lineUpPlacement)! > Int($1.lineUpPlacement)! }) //Sortera performers
        var soundcheckInfo = String()
        soundcheckInfo.append("\n")
        soundcheckInfo.append("Soundcheck \((String(describing: event!.performers[0].performenceName))): \((String(describing: event!.getIn))) (\(String(describing: event!.performers[0].soundcheckTimeInt)) min)")
        soundcheckInfo.append("\n")
        getInCopy = fromGetInToDinner(performerTimeInMin: (event?.performers[0].soundcheckTimeInt)!, from: (getInCopy))
        let lastPerformerSave = event?.performers[0]
        event?.performers.remove(at: 0)
        for performer in event!.performers {
            soundcheckInfo.append("Soundcheck \(performer.performenceName): \(getInCopy) (\(String(describing: performer.soundcheckTimeInt)) min)")
            soundcheckInfo.append("\n")
            getInCopy = fromGetInToDinner(performerTimeInMin: performer.soundcheckTimeInt, from: (getInCopy))
        }
        event?.performers.insert(lastPerformerSave!, at: 0)
        return soundcheckInfo
    }
    
    func showInfo () -> String {
        event?.performers.sort(by: { Int($0.lineUpPlacement)! > Int($1.lineUpPlacement)! }) //Sortera performers
        for performer in event!.performers {
            performer.timeForShow = fromMusicCurfewToDoors(performerTimeInMin: performer.showTimeInt, curfew: musicCurfewCopy)
            musicCurfewCopy = performer.timeForShow
            performer.timeForChangeOver = fromMusicCurfewToDoors(performerTimeInMin: getChangeOverTimeInt(performer: performer), curfew: musicCurfewCopy)
            musicCurfewCopy = performer.timeForChangeOver
        }
        event?.performers.sort(by: { Int($0.lineUpPlacement)! < Int($1.lineUpPlacement)! }) //Sortera performers
        var showInfo = String()
        showInfo.append("\n")
        for performer in event!.performers {
            if performer.lineUpPlacementInt != 1 {
                showInfo.append("C/O: \(String(performer.changeOverTimeInt)) min")
                showInfo.append("\n")
            }
            showInfo.append("\(performer.performenceName): \(performer.timeForShow) (\(String(describing: performer.showTimeInt)) min)")
            showInfo.append("\n")
        }
        return showInfo
    }
    
    func getChangeOverTimeInt(performer: Performence) -> Int{
        var index = -1
        var changeOver = 0
        for performer in event!.performers {
            index = index + 1
            if performer.lineUpPlacementInt != 1 {
                changeOver = performer.rigUpTimeInt + (event?.performers[index+1].rigDownTimeInt)!
                performer.changeOverTimeInt = changeOver
            }
        }
        return changeOver
    }
    
    //  Methods --> Time conversion
    func fromGetInToDinner(performerTimeInMin: Int, from: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let tuplet = minutesToHoursMinutes(minutes: performerTimeInMin)
        var musicCurfew = formatter.date(from: from)!
        musicCurfew = Calendar.current.date(byAdding: .hour, value: tuplet.hours, to: musicCurfew)!
        musicCurfew = Calendar.current.date(byAdding: .minute, value: tuplet.leftMinutes, to: musicCurfew)!
        getInCopy = formatter.string(from: musicCurfew)
        return getInCopy
    }
    
    func fromMusicCurfewToDoors(performerTimeInMin: Int, curfew: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let tuplet = minutesToHoursMinutes(minutes: performerTimeInMin)
        var musicCurfew = formatter.date(from: curfew)!
        musicCurfew = Calendar.current.date(byAdding: .hour, value: -tuplet.hours, to: musicCurfew)!
        musicCurfew = Calendar.current.date(byAdding: .minute, value: -tuplet.leftMinutes, to: musicCurfew)!
        musicCurfewCopy = formatter.string(from: musicCurfew)
        return musicCurfewCopy
    }
    
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    //  Helpers --> Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (event?.howManyPerformers)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventInfoSideMenuCell") as! EventInfoSideMenuTableViewCell
        cell.eventInfoSideMenuCellLabel.text = event?.performers[indexPath.row].performenceName
        return cell
    }
    
    //  Methods --> Select Tableview cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tryckte på \(indexPath.row)")
        self.performSegue(withIdentifier: "editPerformers", sender: indexPath.row)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPerformers" {
            let destVC = segue.destination as! PerformersViewController
            destVC.whatPerformerWillLoad = sender
            destVC.event = event
            destVC.isEditMode = true
        }
    }
    
    //  Tester
    func testRun() {
        event = Event(date: "", getIn: "15:00", dinner: "18:00", doors: "19:00", musicCurfew: "22:00", venueCurfew: "00:00", howManyPerformers: 3)
        event?.performers.append(Performence(performenceName: "Första", soundcheckTime: "30 min", rigUpTime: "15 min", showTime: "30 min", rigDownTime: "15 min", lineUpPlacement: "1", howManyPerformers: (event?.howManyPerformers)!))
        event?.performers.append(Performence(performenceName: "Andra", soundcheckTime: "30 min", rigUpTime: "15 min", showTime: "30 min", rigDownTime: "15 min", lineUpPlacement: "2", howManyPerformers: (event?.howManyPerformers)!))
//        event?.performers.append(Performence(performenceName: "tredje", soundcheckTime: "30 min", rigUpTime: "3 min", showTime: "30 min", rigDownTime: "3 min", lineUpPlacement: "3", howManyPerformers: (event?.howManyPerformers)!))
//        event?.performers.append(Performence(performenceName: "Fjärde", soundcheckTime: "30 min", rigUpTime: "4 min", showTime: "30 min", rigDownTime: "4 min", lineUpPlacement: "4", howManyPerformers: (event?.howManyPerformers)!))
        event?.performers.append(Performence(performenceName: "Sista", soundcheckTime: "60 min", rigUpTime: "15 min", showTime: "30 min", rigDownTime: "15 min", lineUpPlacement: "3", howManyPerformers: (event?.howManyPerformers)!))
    }
}
