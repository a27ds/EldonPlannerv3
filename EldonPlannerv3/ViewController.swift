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
    let eventInfoNames = ["Date", "How Many Performers", "Get-in", "Dinner", "Doors", "Music Curfew", "Venue Curfew"]
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
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
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
        case 1:             //How many performers tag = 101
            textFieldEdit(howManyPerformers!)
        case 2:             //Get-in tag = 102
            timeForTimeWheel = "15:00"
            textFieldEdit(getIn!)
        case 3:             //Dinner tag = 103
            timeForTimeWheel = "18:00"
            textFieldEdit(dinner!)
        case 4:             //Doors tag = 104
            timeForTimeWheel = "19:00"
            textFieldEdit(doors!)
        case 5:             //Music Curfew tag = 105
            timeForTimeWheel = "22:00"
            textFieldEdit(musicCurfew!)
        case 6:             //Venue Curfew tag = 106
            timeForTimeWheel = "01:00"
            textFieldEdit(venueCurfew!)
        
        default:
            print("Default")
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        eventTableView.deselectRow(at: indexPath, animated: true)
    }
    
    //  Methods --> Button becomes visable
    func shouldNextButtonDisplay (anyInputFieldIsEmpty: Bool) {
        if anyInputFieldIsEmpty {
            let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonFunc))
            doneButtonItem.tintColor = .red
            eventNavBar.rightBarButtonItem = doneButtonItem
        }
    }
    
    @objc func doneButtonFunc() {
        view.endEditing(true)
        self.performSegue(withIdentifier: "toAddPerformers", sender: nil)
    }
    
    //  Methods --> Textfield became active
    func textFieldEdit (_ sender: UITextField) {
        whichTextFieldIsSelectedByItsTagNumber = sender.tag
        if sender.tag == 100 {
            datePickerEdit(sender)
        } else if sender.tag == 101 {
            numPadEdit(sender)
        } else if sender.tag >= 102 && sender.tag <= 106{
            timePickerEdit(sender)
        }
    }
    
    //  Methods --> Set a variable to a Tag
    func setTagToName() {
        date = self.view.viewWithTag(100) as? UITextField
        howManyPerformers = self.view.viewWithTag(101) as? UITextField
        getIn = self.view.viewWithTag(102) as? UITextField
        dinner = self.view.viewWithTag(103) as? UITextField
        doors = self.view.viewWithTag(104) as? UITextField
        musicCurfew = self.view.viewWithTag(105) as? UITextField
        venueCurfew = self.view.viewWithTag(106) as? UITextField
    }
    
    //  Methods --> Construting DatePicker
    func datePickerEdit(_ sender: UITextField) {
        let datePicker = datePickerLoad()
        datePicker.backgroundColor = .black
        datePicker.setValue(UIColor.red, forKey:"textColor")
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
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.none
        datePicker.datePickerMode = UIDatePickerMode.date
        let textField = self.view.viewWithTag(whichTextFieldIsSelectedByItsTagNumber) as! UITextField
        textField.text = formatter.string(from: datePicker.date)
        return datePicker
    }
    
    //  Methods --> Construting TimePicker
    func timePickerEdit(_ sender: UITextField) {
        let timePicker = timePickerLoad()
        timePicker.backgroundColor = .black
        timePicker.setValue(UIColor.red, forKey: "textColor")
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
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.none
        formatter.timeStyle = DateFormatter.Style.short
        timePicker.datePickerMode = UIDatePickerMode.time
        timePicker.minuteInterval = 5
        timePicker.setDate(dateSet(testDate: timeForTimeWheel!), animated: true)
        let textField = self.view.viewWithTag(whichTextFieldIsSelectedByItsTagNumber) as! UITextField
        textField.text = formatter.string(from: timePicker.date)
        
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
        sender.keyboardAppearance = .dark
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
        let backgroundView = UIView()
        backgroundView.backgroundColor = .red
        cell.selectedBackgroundView = backgroundView
        cell.eventCellLabel.text = eventInfoNames[indexPath.row]
        cell.eventCellTextField.tag = indexPath.row + 100
        setTagToName()
        return cell
    }
    
    //Helpers --> Checks if any UITextfield did end it's editing, and then Display a done button in navbar
    override func viewDidAppear(_ animated: Bool) {
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

