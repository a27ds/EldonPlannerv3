//
//  ViewController.swift
//  EldonPlannerv3
//
//  Created by a27 on 2018-01-30.
//  Copyright © 2018 a27. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Outlets
    @IBOutlet weak var eventTableView: UITableView!
    
    //Variables
    let eventInfoNames = ["Date", "Get-in", "Dinner", "Doors", "Music Curfew", "Venue Curfew", "How Many Preformers"]
    var whichTextFieldIsSelectedByItsTagNumber: Int = 0
    var event: Event? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        eventTableView.alwaysBounceVertical = false
        eventTableView.tableFooterView = UIView()
    }
    
    //Methods --> Tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
        switch indexPath.row {
        case 0:             //Date tag = 100
            textFieldEdit(cell.eventCellTextField)
        case 1:             //Get-in tag = 101
            textFieldEdit(cell.eventCellTextField)
        case 2:             //Dinner tag = 102
            textFieldEdit(cell.eventCellTextField)
        case 3:             //Doors tag = 103
            textFieldEdit(cell.eventCellTextField)
        case 4:             //Music Curfew tag = 104
            textFieldEdit(cell.eventCellTextField)
        case 5:             //Venue Curfew tag = 105
            textFieldEdit(cell.eventCellTextField)
        case 6:             //How many preformers tag = 106
            textFieldEdit(cell.eventCellTextField)
        default:
            print("Default")
        }
    }
    
    //Methods --> Errorchecks
    func ifAnyInputFieldIsEmpty () {
        let date = self.view.viewWithTag(100) as! UITextField
        let getIn = self.view.viewWithTag(101) as! UITextField
        let dinner = self.view.viewWithTag(102) as! UITextField
        let doors = self.view.viewWithTag(103) as! UITextField
        let musicCurfew = self.view.viewWithTag(104) as! UITextField
        let venueCurfew = self.view.viewWithTag(105) as! UITextField
        let howManyPreformers = self.view.viewWithTag(106) as! UITextField
        if (date.text?.isEmpty)! || (getIn.text?.isEmpty)! || (dinner.text?.isEmpty)! || (doors.text?.isEmpty)! || (musicCurfew.text?.isEmpty)! || (venueCurfew.text?.isEmpty)! || (howManyPreformers.text?.isEmpty)! {
            alertIfAnyInputFieldIsEmpty()
        }
    }
    
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
        //        datePicker.setDate(dateSet(testDate: timeForTimeWheel!), animated: true)
        return timePicker
    }
    
    //    Methods --> Numpad
    func numPadEdit(_ sender: UITextField) {
        sender.keyboardType = UIKeyboardType.numberPad
        sender.viewWithTag(whichTextFieldIsSelectedByItsTagNumber)?.becomeFirstResponder()
    }
    
    //    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    //        let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
    //        switch indexPath.row {
    //        case 0:             //Date
    //            print("0")
    //        case 1:             //Get-in
    //            print("1")
    //        case 2:             //Dinner
    //            print("2")
    //        case 3:             //Doors
    //            print("3")
    //        case 4:             //Music Curfew
    //            print("4")
    //        case 5:             //Venue Curfew
    //            print("5")
    //        case 6:             //How many preformers
    //            print("6")
    //        default:
    //            print("Default")
    //        }
    //    }
    
    //Methods --> Alerts
    func alertIfAnyInputFieldIsEmpty () {
        let alert = UIAlertController(title: "What are you trying to do?", message: "You must fill out all the boxes before continuing.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // Helpers --> Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventInfoNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTableViewCell
        cell.eventCellLabel.text = eventInfoNames[indexPath.row]
        cell.eventCellTextField.tag = indexPath.row + 100
        return cell
    }
    
    //Helpers --> Closes InputView
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
