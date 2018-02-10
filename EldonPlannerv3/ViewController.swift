//
//  ViewController.swift
//  EldonPlannerv3
//
//  Created by a27 on 2018-01-30.
//  Copyright © 2018 a27. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //  Outlets
    @IBOutlet weak var eventNavBar: UINavigationItem!
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet var tap: UITapGestureRecognizer!
    
    //  Variables
    let eventInfoNames = ["Date", "Get-in", "Dinner", "Doors", "Music Curfew", "Venue Curfew", "How Many Performers"]
    var whichTextFieldIsSelectedByItsTagNumber: Int = 0
    var timeForTimeWheel: String?
    
    var event: Event? = nil
    
    var date: UITextField? = nil
    var getIn: UITextField? = nil
    var dinner: UITextField? = nil
    var doors: UITextField? = nil
    var musicCurfew: UITextField? = nil
    var venueCurfew: UITextField? = nil
    var howManyPerformers: UITextField? = nil
    
    var cellIndexPath: IndexPath? = nil
    
    //  ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        eventTableView.alwaysBounceVertical = false
        eventTableView.tableFooterView = UIView()
        eventTableView.rowHeight = 44.0
        eventTableView.backgroundView = UIView()
        eventTableView.backgroundView?.addGestureRecognizer(tap)
        initInputViewsForUITextFields()
    }
    
    //  IBActions
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        eventTableView.deselectRow(at: cellIndexPath!, animated: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        if !anyInputFieldIsEmpty() {
            alertIfAnyInputFieldIsEmpty()
        } else {
            self.performSegue(withIdentifier: "toAddPerformers", sender: sender)
        }
    }
    
    //  Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddPerformers" {
            let destVC = segue.destination as! PerformersViewController
            destVC.event = Event(date: (date?.text!)!, getIn: (getIn?.text!)!, dinner: (dinner?.text!)!, doors: (doors?.text!)!, musicCurfew: (musicCurfew?.text!)!, venueCurfew: (venueCurfew?.text!)!, howManyPerformers: Int((howManyPerformers?.text!)!)!)
        }
    }
    
    //  Methods --> Tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellIndexPath = indexPath
        setTagToName()
        switch indexPath.row {
        case 0:             //Date tag = 100
            textFieldEdit(date!)
        case 1:             //Get-in tag = 101
            timeForTimeWheel = "14:00"
            textFieldEdit(getIn!)
        case 2:             //Dinner tag = 102
            timeForTimeWheel = "17:00"
            textFieldEdit(dinner!)
        case 3:             //Doors tag = 103
            timeForTimeWheel = "18:00"
            textFieldEdit(doors!)
        case 4:             //Music Curfew tag = 104
            timeForTimeWheel = "23:00"
            textFieldEdit(musicCurfew!)
        case 5:             //Venue Curfew tag = 105
            timeForTimeWheel = "00:00"
            textFieldEdit(venueCurfew!)
        case 6:             //How many performers tag = 106
            textFieldEdit(howManyPerformers!)
        default:
            print("Default")
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        eventTableView.deselectRow(at: indexPath, animated: true)
    }
    
    //  Methods --> Going thru all cells and make the inputview active
    func initInputViewsForUITextFields() {
        let visiblesCells = eventTableView.visibleCells
        for cell in visiblesCells {
            let path = eventTableView.indexPath(for: cell)
            tableView(eventTableView, didSelectRowAt: path!)
        }
    }
    
    //  Methods --> Button becomes visable
    func shouldNextButtonDisplay (anyInputFieldIsEmpty: Bool) {
        if anyInputFieldIsEmpty {
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonFunc))
        eventNavBar.rightBarButtonItem = doneButtonItem
        }
    }
    
    @objc func doneButtonFunc() {
        self.performSegue(withIdentifier: "toAddPerformers", sender: nil)
    }
    
    //  Methods --> Textfield became active
    func textFieldEdit (_ sender: UITextField) {
        whichTextFieldIsSelectedByItsTagNumber = sender.tag
        if sender.tag == 100 {
            datePickerEdit(sender)
        } else if sender.tag >= 101 && sender.tag <= 105{
            timePickerEdit(sender)
        } else if sender.tag == 106 {
            numPadEdit(sender)
        }
    }
    
    //  Methods --> Set a variable to a Tag
    func setTagToName() {
        date = self.view.viewWithTag(100) as? UITextField
        getIn = self.view.viewWithTag(101) as? UITextField
        dinner = self.view.viewWithTag(102) as? UITextField
        doors = self.view.viewWithTag(103) as? UITextField
        musicCurfew = self.view.viewWithTag(104) as? UITextField
        venueCurfew = self.view.viewWithTag(105) as? UITextField
        howManyPerformers = self.view.viewWithTag(106) as? UITextField
    }
    
    //  Methods --> Construting DatePicker
    func datePickerEdit(_ sender: UITextField) {
        let datePicker = datePickerLoad()
        sender.inputView = datePicker
        sender.viewWithTag(whichTextFieldIsSelectedByItsTagNumber)?.becomeFirstResponder()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.none
        let textField = self.view.viewWithTag(whichTextFieldIsSelectedByItsTagNumber) as! UITextField
        textField.text = formatter.string(from: sender.date)
    }
    
    func datePickerLoad() -> UIDatePicker{
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.date
        return datePicker
    }
    
    //  Methods --> Construting TimePicker
    func timePickerEdit(_ sender: UITextField) {
        let timePicker = timePickerLoad()
        sender.inputView = timePicker
        sender.viewWithTag(whichTextFieldIsSelectedByItsTagNumber)?.becomeFirstResponder()
        timePicker.addTarget(self, action: #selector(timePickerValueChangedStart(sender:)), for: UIControlEvents.valueChanged)
    }
    
    @objc func timePickerValueChangedStart(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.none
        formatter.timeStyle = DateFormatter.Style.short
        let textField = self.view.viewWithTag(whichTextFieldIsSelectedByItsTagNumber) as! UITextField
        textField.text = formatter.string(from: sender.date)
    }
    
    func timePickerLoad() -> UIDatePicker{
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = UIDatePickerMode.time
        timePicker.minuteInterval = 5
        timePicker.setDate(dateSet(testDate: timeForTimeWheel!), animated: true)
        return timePicker
    }
    
    //  Methods --> Time Set
    func dateSet(testDate: String) -> Date {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        formatter.string(from: date)
        return formatter.date(from: testDate)!
    }
    
    //  Methods --> Numpad
    func numPadEdit(_ sender: UITextField) {
        sender.keyboardType = UIKeyboardType.numberPad
        sender.viewWithTag(whichTextFieldIsSelectedByItsTagNumber)?.becomeFirstResponder()
    }
    
    //  Methods --> Alerts
    func alertIfAnyInputFieldIsEmpty () {
        let alert = UIAlertController(title: "What are you trying to do?", message: "You must fill out all the boxes before continuing.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    //  Methods --> Errorchecks
    func anyInputFieldIsEmpty () -> Bool {
        if (date?.text?.isEmpty)! || (getIn?.text?.isEmpty)! || (dinner?.text?.isEmpty)! || (doors?.text?.isEmpty)! || (musicCurfew?.text?.isEmpty)! || (venueCurfew?.text?.isEmpty)! || (howManyPerformers?.text?.isEmpty)! {
            return false
        }
        return true
    }
    
    //  Helpers --> Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventInfoNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTableViewCell
        cell.eventCellLabel.text = eventInfoNames[indexPath.row]
        cell.eventCellTextField.tag = indexPath.row + 100
        setTagToName()
        return cell
    }
    
    //Helpers --> Checks if any UITextfield did end it's editing, and then Display a done button in navbar
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: date)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: getIn)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: dinner)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: doors)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: musicCurfew)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: venueCurfew)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: howManyPerformers)
    }
    
    @objc func textFieldEndEdit() {
        shouldNextButtonDisplay(anyInputFieldIsEmpty: anyInputFieldIsEmpty())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
}

