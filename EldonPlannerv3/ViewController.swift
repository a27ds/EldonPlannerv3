//
//  ViewController.swift
//  EldonPlannerv3
//
//  Created by a27 on 2018-01-30.
//  Copyright © 2018 a27. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Declare Outlets
    @IBOutlet weak var eventTableView: UITableView!
    
    // Declare Variables
    let eventInfoNames = ["Date", "Get-in", "Dinner", "Doors", "Music Curfew", "Venue Curfew", "How Many Preformers"]
    let eventInfoValues = ["", "", "", "", "", "", ""]
    var whichTextFieldIsSelectedByItsTagNumber: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventTableView.delegate = self
        eventTableView.dataSource = self
        eventTableView.alwaysBounceVertical = false
        eventTableView.tableFooterView = UIView()
    }
    
    
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
    
//  DatePicker methods
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
    
//  TimePicker Methods
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
    
//    Numpad Methods
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

    // Helpers
    
        // Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventInfoNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTableViewCell
        cell.eventCellLabel.text = eventInfoNames[indexPath.row]
        cell.eventCellTextField.text = eventInfoValues[indexPath.row]
        cell.eventCellTextField.tag = indexPath.row + 100
        return cell
    }


}
