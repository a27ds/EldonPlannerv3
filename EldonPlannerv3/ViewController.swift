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
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    //  Variables
    let eventInfoNames = ["Date", "Get-in", "Dinner", "Doors", "Music Curfew", "Venue Curfew", "How Many Preformers"]
    var whichTextFieldIsSelectedByItsTagNumber: Int = 0
    var event: Event? = nil
    var date: UITextField? = nil
    var getIn: UITextField? = nil
    var dinner: UITextField? = nil
    var doors: UITextField? = nil
    var musicCurfew: UITextField? = nil
    var venueCurfew: UITextField? = nil
    var howManyPreformers: UITextField? = nil
    var timeForTimeWheel: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.title = ""
        eventTableView.delegate = self
        eventTableView.dataSource = self
        eventTableView.alwaysBounceVertical = false
        eventTableView.tableFooterView = UIView()
    }
    
    //  IBActions
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        if !anyInputFieldIsEmpty() {
            alertIfAnyInputFieldIsEmpty()
        } else {
            self.performSegue(withIdentifier: "toAddPreformers", sender: sender)
        }
    }
    
    //  Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddPreformers" {
            let destVC = segue.destination as! PreformersViewController
            destVC.event = Event(date: (date?.text!)!, getIn: (getIn?.text!)!, dinner: (dinner?.text!)!, doors: (doors?.text!)!, musicCurfew: (musicCurfew?.text!)!, venueCurfew: (venueCurfew?.text!)!, howManyPreformers: Int((howManyPreformers?.text!)!)!)
        }
    }
    
    
    //  Methods --> Tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        case 6:             //How many preformers tag = 106
            textFieldEdit(howManyPreformers!)
        default:
            print("Default")
        }
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:             //Date
//            self.hideKeyboard()
//        case 1:             //Get-in
//            self.hideKeyboard()
//        case 2:             //Dinner
//            self.hideKeyboard()
//        case 3:             //Doors
//            self.hideKeyboard()
//        case 4:             //Music Curfew
//            self.hideKeyboard()
//        case 5:             //Venue Curfew
//            self.hideKeyboard()
//        case 6:             //How many preformers
//            self.hideKeyboard()
//        default:
//            print("Default")
//        }
//    }
    
    //  Methods --> Errorchecks
    func anyInputFieldIsEmpty () -> Bool {
        if (date?.text?.isEmpty)! || (getIn?.text?.isEmpty)! || (dinner?.text?.isEmpty)! || (doors?.text?.isEmpty)! || (musicCurfew?.text?.isEmpty)! || (venueCurfew?.text?.isEmpty)! || (howManyPreformers?.text?.isEmpty)! {
            return false
        }
        return true
    }
    
    //  Methods --> Button becomes visable
    func shouldNextButtonDisplay (anyInputFieldIsEmpty: Bool) {
        if anyInputFieldIsEmpty {
            nextButton.title = "Next"
        }
    }
    
    //  Methods --> Textfield became active
    func textFieldEdit (_ sender: UITextField) {
        whichTextFieldIsSelectedByItsTagNumber = sender.tag
        if sender.tag == 100 {
            datePickerEdit(sender)
            shouldNextButtonDisplay(anyInputFieldIsEmpty: anyInputFieldIsEmpty())
        } else if sender.tag >= 101 && sender.tag <= 105{
            timePickerEdit(sender)
            shouldNextButtonDisplay(anyInputFieldIsEmpty: anyInputFieldIsEmpty())
        } else if sender.tag == 106 {
            numPadEdit(sender)
            shouldNextButtonDisplay(anyInputFieldIsEmpty: anyInputFieldIsEmpty())
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
        howManyPreformers = self.view.viewWithTag(106) as? UITextField
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
    
    //  Helpers --> Closes InputView
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

