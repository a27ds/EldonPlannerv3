//
//  PreformersViewController.swift
//  EldonPlannerv3
//
//  Created by a27 on 2018-01-31.
//  Copyright © 2018 a27. All rights reserved.
//

import UIKit

class PreformersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //  Outlets
    @IBOutlet weak var preformersNavBar: UINavigationItem!
    @IBOutlet weak var preformersTableView: UITableView!
    @IBOutlet var tap: UITapGestureRecognizer!
    
    //  Variables
    var event: Event? = nil
    
    let preformersInfoNames = ["Preformence Name", "Soundcheck Time", "Change Over", "Show Time", "Line Up Placement"]
    var showTimePickerData: [String] = []
    var soundcheckTimePickerData: [String] = []
    var lineUpPlacementData: [String] = []
    
    var whichTextFieldIsSelectedByItsTagNumber: Int = 0
    
    var name: UITextField? = nil
    var soundcheckTime: UITextField? = nil
    var changeOverTime: UITextField? = nil
    var showTime: UITextField? = nil
    var lineUpPlacement: UITextField? = nil
    
    var soundcheckEdit: Bool = false
    var soundcheckTimeSave: Int = 0
    var changeOverEdit: Bool = false
    var changeOverTimeSave: Int = 0
    var showTimeEdit: Bool = false
    var showTimeSave: Int = 0
    
    var cellIndexPath: IndexPath? = nil
    
    //  ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //        testRun()
        preformersTableView.delegate = self
        preformersTableView.dataSource = self
        preformersTableView.alwaysBounceVertical = false
        preformersTableView.tableFooterView = UIView()
        preformersTableView.rowHeight = 44.0
        preformersTableView.backgroundView = UIView()
        preformersTableView.backgroundView?.addGestureRecognizer(tap)
        appendLineUpPlacementData()
        showTimeEveryFiveMinInTotal()
        soundcheckTimeEveryFiveMinInTotal()
        initInputViewsForUITextFields()
        
    }
    
    //  IBActions
    @IBAction func tapPressed(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        preformersTableView.deselectRow(at: cellIndexPath!, animated: true)
    }
    
    //  Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventInfo" {
            let destVC = segue.destination as! EventViewController
            addPreformersInfoToPreformenceArray()
            destVC.event = event
        }
    }
    
    func addPreformersInfoToPreformenceArray() {
        event?.preformers.append(Preformence(preformenceName: (name?.text!)!, soundcheckTime: (soundcheckTime?.text!)!, changeOverTime: (changeOverTime?.text!)!, showTime: (showTime?.text!)!, lineUpPlacement: (lineUpPlacement?.text!)!, howManyPreformers: (event?.howManyPreformers)!))
    }
    
    func removeMinFromTotalTime(sender: UITextField, timeTotalMin: Int) -> Int{
        return timeTotalMin - Int((sender.text!).dropLast(4))!
    }
    
    func removeSelectedLineUpPlacementFromArray() {
        if let index = lineUpPlacementData.index(of: (lineUpPlacement?.text!)!) {
            lineUpPlacementData.remove(at: index)
        }
    }
    
    //Methods --> Going thru all cells and make the inputview active
    func initInputViewsForUITextFields() {
        let visiblesCells = preformersTableView.visibleCells
        for cell in visiblesCells {
            let path = preformersTableView.indexPath(for: cell)
            tableView(preformersTableView, didSelectRowAt: path!)
        }
    }
    
    // Methods --> Append Line up data
    func appendLineUpPlacementData() {
        for i in 1...event!.howManyPreformers {
            lineUpPlacementData.append("\(i)")
        }
    }
    
    //  Methods --> Tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellIndexPath = indexPath
        setTagToName()
        switch indexPath.row {
        case 0:             //Preformence Name tag = 200
            textFieldEdit(name!)
        case 1:             //Soundcheck Time tag = 201
            if soundcheckEdit == true {
                event?.soundcheckTimeTotalInMin += soundcheckTimeSave
            }
            soundcheckEdit = false
            textFieldEdit(soundcheckTime!)
        case 2:             //Rig Up Time tag = 202
            if changeOverEdit == true {
                event?.showTimeTotalInMin += changeOverTimeSave
            }
            changeOverEdit = false
            textFieldEdit(changeOverTime!)
        case 3:             //Show Time tag = 203
            if showTimeEdit == true {
                event?.showTimeTotalInMin += showTimeSave
            }
            showTimeEdit = false
            textFieldEdit(showTime!)
        case 4:             //Line Up Placement tag = 204
            textFieldEdit(lineUpPlacement!)
        default:
            print("Default")
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:             //Soundcheck Time tag = 201
            guard (soundcheckTime?.text?.isEmpty)! else {
                soundcheckTimeSave = Int((soundcheckTime!.text!).dropLast(4))!
                event!.soundcheckTimeTotalInMin = removeMinFromTotalTime(sender: (soundcheckTime!), timeTotalMin: (event?.soundcheckTimeTotalInMin)!)
                soundcheckEdit = true
                return
            }
        case 2:             //Change over Time tag = 202
            guard (changeOverTime!.text?.isEmpty)! else {
                changeOverTimeSave = Int((changeOverTime!.text!).dropLast(4))!
                event!.showTimeTotalInMin = removeMinFromTotalTime(sender: (changeOverTime!), timeTotalMin: (event?.showTimeTotalInMin)!)
                changeOverEdit = true
                return
            }
        case 3:             //Show Time tag = 203
            guard (showTime!.text?.isEmpty)! else {
                showTimeSave = Int((showTime!.text!).dropLast(4))!
                event!.showTimeTotalInMin = removeMinFromTotalTime(sender: (showTime!), timeTotalMin: (event?.showTimeTotalInMin)!)
                showTimeEdit = true
                return
            }
        default:
            print("Default")
        }
    }
    
    func textFieldEdit (_ sender: UITextField) {
        whichTextFieldIsSelectedByItsTagNumber = sender.tag
        if sender.tag == 200 {
            sender.viewWithTag(whichTextFieldIsSelectedByItsTagNumber)?.becomeFirstResponder()
        } else if sender.tag == 201 {
            soundcheckTimeEveryFiveMinInTotal()
            soundcheckTimerPickerLoad(sender)
        } else if sender.tag >= 202 && sender.tag <= 204{
            showTimeEveryFiveMinInTotal()
            countDownTimerPickerLoad(sender)
        } else if sender.tag == 205 {
            lineUpPlacementPickerLoad(sender)
        }
    }
    
    //  Methods --> Construting Pickers
    func countDownTimerPickerLoad(_ sender: UITextField) {
        let countDownTimer = UIPickerView()
        countDownTimer.tag = 1
        countDownTimer.delegate = self
        countDownTimer.dataSource = self
        countDownTimer.selectRow(5, inComponent: 0, animated: true) // väljer vart man vill börja i countDownTimer
        sender.inputView = countDownTimer
        sender.viewWithTag(whichTextFieldIsSelectedByItsTagNumber)?.becomeFirstResponder()
    }
    
    func soundcheckTimerPickerLoad(_ sender: UITextField) {
        let soundcheckTimer = UIPickerView()
        soundcheckTimer.tag = 2
        soundcheckTimer.delegate = self
        soundcheckTimer.dataSource = self
        soundcheckTimer.selectRow(5, inComponent: 0, animated: true) // väljer vart man vill börja i soundcheckTimer
        sender.inputView = soundcheckTimer
        sender.viewWithTag(whichTextFieldIsSelectedByItsTagNumber)?.becomeFirstResponder()
    }
    
    func lineUpPlacementPickerLoad(_ sender: UITextField) {
        let lineUpPlacementPicker = UIPickerView()
        lineUpPlacementPicker.tag = 3
        lineUpPlacementPicker.delegate = self
        lineUpPlacementPicker.dataSource = self
        sender.inputView = lineUpPlacementPicker
        sender.viewWithTag(whichTextFieldIsSelectedByItsTagNumber)?.becomeFirstResponder()
    }
    
    //  Methods --> Building Up Time array
    func showTimeEveryFiveMinInTotal() {
        let everyFiveMinInTotalShowTime = (event?.showTimeTotalInMin)! / 5
        appendTimeInPickerData(runs: everyFiveMinInTotalShowTime, array: &showTimePickerData)
    }
    
    func soundcheckTimeEveryFiveMinInTotal() {
        let everyFiveMinInTotalSoundcheckTime = (event?.soundcheckTimeTotalInMin)! / 5
        appendTimeInPickerData(runs: everyFiveMinInTotalSoundcheckTime, array: &soundcheckTimePickerData)
    }
    
    func appendTimeInPickerData(runs: Int, array: inout [String]) {
        array.removeAll()
        for i in 1...runs {
            array.append("\(i * 5) min")
        }
    }
    
    //  Methods --> Reset all UITextFields
    func resetTextFields() {
        soundcheckEdit = false
        soundcheckTimeSave = 0
        changeOverEdit = false
        changeOverTimeSave = 0
        showTimeEdit = false
        showTimeSave = 0
        
        name?.text = nil
        soundcheckTime?.text = nil
        changeOverTime?.text = nil
        showTime?.text = nil
        lineUpPlacement?.text = nil
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
        let editButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonFunc))
        preformersNavBar.rightBarButtonItem = editButtonItem
    }
    
    @objc func addButtonFunc() {
        addPreformersInfoToPreformenceArray()
        removeSelectedLineUpPlacementFromArray()
        resetTextFields()
        preformersNavBar.rightBarButtonItem = nil
    }
    
    func makeDoneButton() {
        let editButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonFunc))
        preformersNavBar.rightBarButtonItem = editButtonItem
    }
    
    @objc func doneButtonFunc() {
        self.performSegue(withIdentifier: "toEventInfo", sender: nil)
    }
    
    //  Methods --> Errorchecks
    func ifAnyInputFieldIsEmpty () -> Bool {
        if (name?.text?.isEmpty)! || (soundcheckTime?.text?.isEmpty)! || (changeOverTime?.text?.isEmpty)! || (showTime?.text?.isEmpty)! || (lineUpPlacement?.text?.isEmpty)! {
            return false
        }
        return true
    }
    
    //  Methods --> Alerts
    func alertIfAnyInputFieldIsEmpty () {
        let alert = UIAlertController(title: "What are you trying to do?", message: "You must fill out all the boxes before continuing.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    //  Helpers --> Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preformersInfoNames.count
    }
    
    func setTagToName() {
        name = self.view.viewWithTag(200) as? UITextField
        soundcheckTime = self.view.viewWithTag(201) as? UITextField
        changeOverTime = self.view.viewWithTag(202) as? UITextField
        showTime = self.view.viewWithTag(203) as? UITextField
        lineUpPlacement = self.view.viewWithTag(204) as? UITextField
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preformersCell") as! PreformersTableViewCell
        cell.preformersCellLabel.text = preformersInfoNames[indexPath.row]
        cell.preformersCellTextField.tag = indexPath.row + 200
        return cell
    }
    
    //  Helpers --> PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return showTimePickerData.count
        } else if pickerView.tag == 2 {
            return soundcheckTimePickerData.count
        } else if pickerView.tag == 3 {
            return lineUpPlacementData.count
        }
        return -1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return showTimePickerData[row]
        } else if pickerView.tag == 2 {
            return soundcheckTimePickerData[row]
        } else if pickerView.tag == 3 {
            return lineUpPlacementData[row]
        }
        return "Nothing"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let textField = self.view.viewWithTag(whichTextFieldIsSelectedByItsTagNumber) as! UITextField
        if pickerView.tag == 1 {
            textField.text = showTimePickerData[row]
        } else if pickerView.tag == 2 {
            textField.text = soundcheckTimePickerData[row]
        } else if pickerView.tag == 3 {
            textField.text = lineUpPlacementData[row]
        }
    }
    
    //Helpers --> Checks if any UITextfield did end it's editing, and then runs shouldNextButtonDisplay
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: name)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: soundcheckTime)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: changeOverTime)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: showTime)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: lineUpPlacement)
    }
    
    @objc func textFieldEndEdit() {
        if lineUpPlacementData.count == 1 {
            shouldDoneButtonDisplay(anyInputFieldIsEmpty: ifAnyInputFieldIsEmpty())
        } else {
            shouldAddButtonDisplay(anyInputFieldIsEmpty: ifAnyInputFieldIsEmpty())
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
//    //  Tester
//    func testRun() {
//        event = Event(date: "", getIn: "15:00", dinner: "18:00", doors: "19:00", musicCurfew: "22:00", venueCurfew: "00:00", howManyPreformers: 3)
//        
//    }
}
