//
//  PerformersViewController.swift
//  EldonPlannerv3
//
//  Created by a27 on 2018-01-31.
//  Copyright © 2018 a27. All rights reserved.
//

import UIKit

class PerformersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //  Outlets
    @IBOutlet weak var performersNavBar: UINavigationItem!
    @IBOutlet weak var performersTableView: UITableView!
    @IBOutlet var tap: UITapGestureRecognizer!
    @IBOutlet weak var showtimeLeft: UILabel!
    
    //  Variables
    var event: Event? = nil
    
    let performersInfoNames = ["Performence Name", "Soundcheck Time", "Rig Up Time", "Show Time", "Rig Down Time", "Line Up Placement"]
    var showTimePickerData: [String] = []
    var soundcheckTimePickerData: [String] = []
    var lineUpPlacementData: [String] = []
    
    var whichTextFieldIsSelectedByItsTagNumber: Int = 0
    
    var name: UITextField? = nil
    var soundcheckTime: UITextField? = nil
    var rigUpTime: UITextField? = nil
    var showTime: UITextField? = nil
    var rigDownTime: UITextField? = nil
    var lineUpPlacement: UITextField? = nil
    
    var soundcheckEdit: Bool = false
    var soundcheckTimeSave: Int = 0
    var rigUpEdit: Bool = false
    var rigUpTimeSave: Int = 0
    var showTimeEdit: Bool = false
    var showTimeSave: Int = 0
    var rigDownEdit: Bool = false
    var rigDownTimeSave: Int = 0
    
    var cellIndexPath: IndexPath? = nil
    var whatPerformerWillLoad: Any?
    var isEditMode: Bool = false
    var anyUiTextFieldTapped: Bool = false
    
    var counter = 0
    var NSAttributed: NSAttributedString?
    
    //  ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //        testRun()
        performersTableViewSet()
        appendLineUpPlacementData()
        showTimeLeftUpdate()
    }
    
    //  ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        if isEditMode {
            editMode()
        }
    }
    
    //  ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        setTagToName()
        observerSet()
    }
    
    //  ViewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //  IBActions --> TapGestures
    @IBAction func tapPressed(_ sender: UITapGestureRecognizer) {
        if anyUiTextFieldTapped {
            view.endEditing(true)
            performersTableView.deselectRow(at: cellIndexPath!, animated: true)
        }
    }
    
    //  Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventInfo" {
            let destVC = segue.destination as! EventViewController
            if !isEditMode {
                addPerformersInfoToPerformenceArray()
            }
            destVC.event = event
        }
    }
    
    //  Methods --> Makes the statusbar light colored
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //  Methods --> Setting the observers
    func observerSet() {
        NotificationCenter.default.addObserver(self, selector: #selector(nameEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: name)
        NotificationCenter.default.addObserver(self, selector: #selector(soundcheckEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: soundcheckTime)
        NotificationCenter.default.addObserver(self, selector: #selector(rigUpEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: rigUpTime)
        NotificationCenter.default.addObserver(self, selector: #selector(showEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: showTime)
        NotificationCenter.default.addObserver(self, selector: #selector(rigDownEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: rigDownTime)
        NotificationCenter.default.addObserver(self, selector: #selector(lineUpPlacementEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: lineUpPlacement)
    }
    
    //  Methods --> Observer Methods
    @objc func nameEndEdit() {
        textFieldEndEdit()
    }
    
    @objc func soundcheckEndEdit() {
        textFieldEndEdit()
        guard (soundcheckTime?.text?.isEmpty)! else {
            soundcheckTimeSave = Int((soundcheckTime!.text!).dropLast(4))!
            let soundcheckTimeTotalSave = (event?.soundcheckTimeTotalInMin)!
            event!.soundcheckTimeTotalInMin = removeMinFromTotalTime(timeSave: soundcheckTimeSave, timeTotalMin: soundcheckTimeTotalSave)
            soundcheckEdit = true
            soundcheckTimeEveryFiveMinInTotal()
            return
        }
    }
    
    @objc func rigUpEndEdit() {
        textFieldEndEdit()
        guard (rigUpTime!.text?.isEmpty)! else {
            rigUpTimeSave = Int((rigUpTime!.text!).dropLast(4))!
            let showTimeTotalSave = (event?.showTimeTotalInMin)!
            event!.showTimeTotalInMin = removeMinFromTotalTime(timeSave: rigUpTimeSave, timeTotalMin: showTimeTotalSave)
            rigUpEdit = true
            showTimeEveryFiveMinInTotal()
            showTimeLeftUpdate()
            return
        }
    }
    
    @objc func showEndEdit() {
        textFieldEndEdit()
        guard (showTime!.text?.isEmpty)! else {
            showTimeSave = Int((showTime!.text!).dropLast(4))!
            event!.showTimeTotalInMin = removeMinFromTotalTime(timeSave: showTimeSave, timeTotalMin: (event?.showTimeTotalInMin)!)
            showTimeEdit = true
            showTimeEveryFiveMinInTotal()
            showTimeLeftUpdate()
            return
        }
    }
    
    @objc func rigDownEndEdit() {
        textFieldEndEdit()
        guard (rigDownTime!.text?.isEmpty)! else {
            rigDownTimeSave = Int((rigDownTime!.text!).dropLast(4))!
            event!.showTimeTotalInMin = removeMinFromTotalTime(timeSave: rigDownTimeSave, timeTotalMin: (event?.showTimeTotalInMin)!)
            rigDownEdit = true
            showTimeEveryFiveMinInTotal()
            showTimeLeftUpdate()
            return
        }
    }
    
    @objc func lineUpPlacementEndEdit() {
        textFieldEndEdit()
    }
    
    //  Methods --> Tableview
    func performersTableViewSet() {
        performersTableView.delegate = self
        performersTableView.dataSource = self
        performersTableView.alwaysBounceVertical = false
        performersTableView.tableFooterView = UIView()
        performersTableView.rowHeight = 44.0
        performersTableView.backgroundView = UIView()
        performersTableView.backgroundView?.addGestureRecognizer(tap)
    }
    
    //  Methods --> Tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellIndexPath = indexPath
        setTagToName()
        switch indexPath.row {
        case 0:             //performence Name tag = 200
            anyUiTextFieldTapped = true
            textFieldEdit(name!)
        case 1:             //Soundcheck Time tag = 201
            anyUiTextFieldTapped = true
            if isEditMode {
                soundcheckTimeSave = Int((soundcheckTime!.text!).dropLast(4))!
            }
            if soundcheckEdit || isEditMode {
                event?.soundcheckTimeTotalInMin += soundcheckTimeSave
                soundcheckTimeEveryFiveMinInTotal()
            }
            textFieldEdit(soundcheckTime!)
            
        case 2:             //Rig Up Time tag = 202
            anyUiTextFieldTapped = true
            if isEditMode {
                rigUpTimeSave = Int((rigUpTime!.text!).dropLast(4))!
            }
            if rigUpEdit || isEditMode  {
                event?.showTimeTotalInMin += rigUpTimeSave
                showTimeEveryFiveMinInTotal()
            }
            textFieldEdit(rigUpTime!)
        case 3:             //Show Time tag = 203
            anyUiTextFieldTapped = true
            if isEditMode {
                showTimeSave = Int((showTime!.text!).dropLast(4))!
            }
            if showTimeEdit || isEditMode  {
                event?.showTimeTotalInMin += showTimeSave
                showTimeEveryFiveMinInTotal()
            }
            textFieldEdit(showTime!)
        case 4:             //Rig Down Time tag = 204
            anyUiTextFieldTapped = true
            if isEditMode {
                rigDownTimeSave = Int((rigDownTime!.text!).dropLast(4))!
            }
            if rigDownEdit || isEditMode  {
                event?.showTimeTotalInMin += rigDownTimeSave
                showTimeEveryFiveMinInTotal()
            }
            textFieldEdit(rigDownTime!)
        case 5:             //Line Up Placement tag = 205
            anyUiTextFieldTapped = true
            textFieldEdit(lineUpPlacement!)
        default:
            print("If you can read this then concider yourself lucky, 84 percent can read but 775 million people still can’t read")
        }
    }
    
    //  Methods --> When a cell are tapped on, this check will run to act as a waycrossing
    func textFieldEdit (_ sender: UITextField) {
        whichTextFieldIsSelectedByItsTagNumber = sender.tag
        if sender.tag == 200 {
            sender.keyboardAppearance = .dark
            sender.viewWithTag(whichTextFieldIsSelectedByItsTagNumber)?.becomeFirstResponder()
        } else if sender.tag == 201 {
            soundcheckTimeEveryFiveMinInTotal()
            soundcheckTimerPickerLoad(sender)
        } else if sender.tag == 202 || sender.tag == 203 || sender.tag == 204{
            showTimeEveryFiveMinInTotal()
            countDownTimerPickerLoad(sender)
        } else if sender.tag == 205 {
            lineUpPlacementPickerLoad(sender)
        }
    }
    
    //  Methods --> Do checks if buttons should be displayed
    func textFieldEndEdit() {
        showTimeLeftUpdate()
        if !isEditMode {
            if lineUpPlacementData.count == 1 {
                shouldDoneButtonDisplay(anyInputFieldIsEmpty: ifAnyInputFieldIsEmpty())
            } else {
                shouldAddButtonDisplay(anyInputFieldIsEmpty: ifAnyInputFieldIsEmpty())
            }
        }
    }
    
    //  Methods --> Update the ShowTimeLeft label
    func showTimeLeftUpdate() {
        showtimeLeft.text = "Showtime left: \(event!.showTimeTotalInMin) min"
    }
    
    //  Methods --> This will run if user wants to edit something from the eventInfo page
    func editMode() {
        editResetTextFields()
        makeSaveButton()
    }
    
    //  Methods --> Appends info into performence Array
    func addPerformersInfoToPerformenceArray() {
        view.endEditing(true)
        performersTableView.deselectRow(at: cellIndexPath!, animated: true)
        event?.performers.append(Performence(performenceName: (name?.text!)!, soundcheckTime: (soundcheckTime?.text!)!, rigUpTime: (rigUpTime?.text!)!, showTime: (showTime?.text!)!, rigDownTime: (rigDownTime?.text!)!, lineUpPlacement: (lineUpPlacement?.text!)!, howManyPerformers: (event?.howManyPerformers)!))
    }
    
    //  Methods --> Remove time from total time
    func removeMinFromTotalTime(timeSave: Int, timeTotalMin: Int) -> Int{
        return timeTotalMin - timeSave
    }
    
    //  Methods --> Creates and append the time arrays
    func appendTimeInPickerData(runs: Int, array: inout [String]) {
        array.removeAll()
        for i in 1...runs {
            array.append("\(i * 5) min")
        }
    }
    
    // Methods --> Creates and append LineUpPlacementData array
    func appendLineUpPlacementData() {
        for i in 1...event!.howManyPerformers {
            lineUpPlacementData.append("\(i)")
        }
    }
    
    //  Methods --> Removes selected lineUpPlacement from lineUpPlacementdata array
    func removeSelectedLineUpPlacementFromArray() {
        if let index = lineUpPlacementData.index(of: (lineUpPlacement?.text!)!) {
            lineUpPlacementData.remove(at: index)
        }
    }
    
    //  Methods --> Construting Pickers
    func countDownTimerPickerLoad(_ sender: UITextField) {
        let countDownTimer = UIPickerView()
        countDownTimer.tag = 1
        countDownTimer.delegate = self
        countDownTimer.dataSource = self
        countDownTimer.backgroundColor = .black
        if showTimePickerData.count > 11 {
            if (sender.text?.isEmpty)! {
                if sender.tag == 202 || sender.tag == 204 {
                    countDownTimer.selectRow(2, inComponent: 0, animated: true)
                    pickerView(countDownTimer, didSelectRow: 2, inComponent: 0)
                } else {
                    countDownTimer.selectRow(11, inComponent: 0, animated: true)
                    pickerView(countDownTimer, didSelectRow: 11, inComponent: 0)
                }
            } else {
                var checkWherePickerWheelsStarts = Int((sender.text!).dropLast(4))!
                checkWherePickerWheelsStarts = (checkWherePickerWheelsStarts / 5)-1
                countDownTimer.selectRow(checkWherePickerWheelsStarts, inComponent: 0, animated: true)
                pickerView(countDownTimer, didSelectRow: checkWherePickerWheelsStarts, inComponent: 0)
            }
        } else {
            countDownTimer.selectRow(0, inComponent: 0, animated: true)
            pickerView(countDownTimer, didSelectRow: 0, inComponent: 0)
        }
        countDownTimer.backgroundColor = .black
        sender.inputView = countDownTimer
        sender.viewWithTag(whichTextFieldIsSelectedByItsTagNumber)?.becomeFirstResponder()
    }
    
    func soundcheckTimerPickerLoad(_ sender: UITextField) {
        let soundcheckTimer = UIPickerView()
        soundcheckTimer.tag = 2
        soundcheckTimer.delegate = self
        soundcheckTimer.dataSource = self
        if (sender.text?.isEmpty)! {
            soundcheckTimer.selectRow(11, inComponent: 0, animated: true)
            pickerView(soundcheckTimer, didSelectRow: 11, inComponent: 0)
        } else {
            var checkWherePickerWheelsStarts = Int((sender.text!).dropLast(4))!
            checkWherePickerWheelsStarts = (checkWherePickerWheelsStarts / 5)-1
            soundcheckTimer.selectRow(checkWherePickerWheelsStarts, inComponent: 0, animated: true)
            pickerView(soundcheckTimer, didSelectRow: checkWherePickerWheelsStarts, inComponent: 0)
        }
        soundcheckTimer.backgroundColor = .black
        sender.inputView = soundcheckTimer
        sender.viewWithTag(whichTextFieldIsSelectedByItsTagNumber)?.becomeFirstResponder()
    }
    
    func lineUpPlacementPickerLoad(_ sender: UITextField) {
        let lineUpPlacementPicker = UIPickerView()
        lineUpPlacementPicker.tag = 3
        lineUpPlacementPicker.delegate = self
        lineUpPlacementPicker.dataSource = self
        lineUpPlacementPicker.backgroundColor = .black
        lineUpPlacementPicker.setValue(UIColor.red, forKey: "textColor")
        pickerView(lineUpPlacementPicker, didSelectRow: 0, inComponent: 0)
        sender.inputView = lineUpPlacementPicker
        sender.viewWithTag(whichTextFieldIsSelectedByItsTagNumber)?.becomeFirstResponder()
    }
    
    //  Methods --> Building Up Time array
    func showTimeEveryFiveMinInTotal() {
        showTimeLeftUpdate()
        if event!.showTimeTotalInMin >= 5 {
            let everyFiveMinInTotalShowTime = (event?.showTimeTotalInMin)! / 5
            appendTimeInPickerData(runs: everyFiveMinInTotalShowTime, array: &showTimePickerData)
        }
    }
    
    func soundcheckTimeEveryFiveMinInTotal() {
        if event!.soundcheckTimeTotalInMin >= 5 {
            let everyFiveMinInTotalSoundcheckTime = (event?.soundcheckTimeTotalInMin)! / 5
            appendTimeInPickerData(runs: everyFiveMinInTotalSoundcheckTime, array: &soundcheckTimePickerData)
        }
    }
    
    //  Methods --> Reset all UITextFields and Bools/variabels that UITextfields are using
    func resetTextFields() {
        soundcheckEdit = false
        soundcheckTimeSave = 0
        rigUpEdit = false
        rigUpTimeSave = 0
        showTimeEdit = false
        showTimeSave = 0
        rigDownEdit = false
        rigDownTimeSave = 0
        
        name?.text = nil
        soundcheckTime?.text = nil
        rigUpTime?.text = nil
        showTime?.text = nil
        rigDownTime?.text = nil
        lineUpPlacement?.text = nil
    }
    
    //  Methods --> Reset all Bools/variabels that UITextfields are using when the app is in Edit mode
    func editResetTextFields() {
        soundcheckEdit = false
        soundcheckTimeSave = 0
        rigUpEdit = false
        rigUpTimeSave = 0
        showTimeEdit = false
        showTimeSave = 0
        rigDownEdit = false
        rigDownTimeSave = 0
    }
    
    //  Methods --> Nav Buttons becomes visble
    func shouldAddButtonDisplay (anyInputFieldIsEmpty: Bool) {
        if anyInputFieldIsEmpty {
            makeAddButton()
        }
    }
    
    func shouldDoneButtonDisplay (anyInputFieldIsEmpty: Bool) {
        if anyInputFieldIsEmpty {
            makeDoneButton()
        }
    }
    
    // Methods --> Making Nav buttons with functions connected to them
    func makeAddButton() {
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonFunc))
        addButtonItem.tintColor = .red
        performersNavBar.rightBarButtonItem = addButtonItem
    }
    
    @objc func addButtonFunc() {
        if showTimePickerData.count < 11 {
            lowInMinAlert()
        } else {
            addButtonAfterCheck()
        }
    }
    
    func addButtonAfterCheck() {
        setTagToName()
        addPerformersInfoToPerformenceArray()
        removeSelectedLineUpPlacementFromArray()
        resetTextFields()
        performersNavBar.rightBarButtonItem = nil
    }
    
    func makeDoneButton() {
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonFunc))
        doneButtonItem.tintColor = .red
        performersNavBar.rightBarButtonItem = doneButtonItem
    }
    
    @objc func doneButtonFunc() {
        self.performSegue(withIdentifier: "toEventInfo", sender: nil)
    }
    
    func makeSaveButton() {
        let saveButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveButtonFunc))
        saveButtonItem.tintColor = .red
        performersNavBar.rightBarButtonItem = saveButtonItem
    }
    
    @objc func saveButtonFunc() {
        setTagToName()
        let lineUpPlacementSave = event?.performers[whatPerformerWillLoad as! Int].lineUpPlacement
        event?.performers.remove(at: whatPerformerWillLoad as! Int)
        event?.performers.append((Performence(performenceName: (name?.text!)!, soundcheckTime: (soundcheckTime?.text!)!, rigUpTime: (rigUpTime?.text!)!, showTime: (showTime?.text!)!, rigDownTime: (rigDownTime?.text!)!, lineUpPlacement: lineUpPlacementSave!, howManyPerformers: (event?.howManyPerformers)!)))
        self.performSegue(withIdentifier: "toEventInfo", sender: nil)
    }
    
    //  Methods --> Set a variable to a Tag
    func setTagToName() {
        name = self.view.viewWithTag(200) as? UITextField
        soundcheckTime = self.view.viewWithTag(201) as? UITextField
        rigUpTime = self.view.viewWithTag(202) as? UITextField
        showTime = self.view.viewWithTag(203) as? UITextField
        rigDownTime = self.view.viewWithTag(204) as? UITextField
        lineUpPlacement = self.view.viewWithTag(205) as? UITextField
    }
    
    //  Methods --> Errorchecks
    func ifAnyInputFieldIsEmpty () -> Bool {
        setTagToName()
        if isEditMode {
            if (name?.text?.isEmpty)! || (soundcheckTime?.text?.isEmpty)! || (rigUpTime?.text?.isEmpty)! || (showTime?.text?.isEmpty)! || (rigDownTime?.text?.isEmpty)! {
                return false
            } else {
                return true
            }
        } else if (name?.text?.isEmpty)! || (soundcheckTime?.text?.isEmpty)! || (rigUpTime?.text?.isEmpty)! || (showTime?.text?.isEmpty)! || (rigDownTime?.text?.isEmpty)! || (lineUpPlacement?.text?.isEmpty)! {
            return false
        } else {
            return true
        }
    }
    
    //  Methods --> Alerts
    func alertIfAnyInputFieldIsEmpty () {
        let alert = UIAlertController(title: "What are you trying to do?", message: "You must fill out all the boxes before continuing.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func lowInMinAlert() {
        let alert = UIAlertController(title: "Under 60 min left" , message: "Are you sure, that you want to continue? You have under 60 min left on the total showtime", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.addButtonAfterCheck()
        }))
        alert.view.tintColor = UIColor.black
        self.present(alert, animated: true)
    }
    
    //  Helpers --> Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = performersInfoNames.count
        if isEditMode {
            return count-1
        } else {
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "performersCell") as! PerformersTableViewCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = .red
        cell.selectedBackgroundView = backgroundView
        cell.performersCellLabel.text = performersInfoNames[indexPath.row]
        cell.performersCellTextField.tag = indexPath.row + 200
        if isEditMode {
            let performerValues = event?.performers[whatPerformerWillLoad as! Int]
            let getPerformerValue = performerValues?.getPerformerValue()
            cell.performersCellTextField.text = getPerformerValue?[indexPath.row]
        }
        return cell
    }
    
    //  Helpers --> PickerView
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag == 1 {
            let showTimePickerData = self.showTimePickerData[row]
            NSAttributed = NSAttributedString(string: showTimePickerData, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        } else if pickerView.tag == 2 {
            let soundcheckTimePickerData = self.soundcheckTimePickerData[row]
            NSAttributed = NSAttributedString(string: soundcheckTimePickerData, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        } else if pickerView.tag == 3 {
            let lineUpPlacementData = self.lineUpPlacementData[row]
            NSAttributed = NSAttributedString(string: lineUpPlacementData, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
        }
        return NSAttributed
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            showTimeEveryFiveMinInTotal()
            return showTimePickerData.count
        } else if pickerView.tag == 2 {
            return soundcheckTimePickerData.count
        } else if pickerView.tag == 3 {
            return lineUpPlacementData.count
        }
        return -1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let textField = self.view.viewWithTag(whichTextFieldIsSelectedByItsTagNumber) as! UITextField
        if pickerView.tag == 1 {
            showTimeEveryFiveMinInTotal()
            textField.text = showTimePickerData[row]
        } else if pickerView.tag == 2 {
            textField.text = soundcheckTimePickerData[row]
        } else if pickerView.tag == 3 {
            textField.text = lineUpPlacementData[row]
        }
        showTimeLeftUpdate()
    }
    
    //  Tester
    func testRun() {
        event = Event(date: "", getIn: "15:00", dinner: "18:00", doors: "19:00", musicCurfew: "22:00", venueCurfew: "00:00", howManyPerformers: 3)
    }
}
