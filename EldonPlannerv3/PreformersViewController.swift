//
//  PreformersViewController.swift
//  EldonPlannerv3
//
//  Created by a27 on 2018-01-31.
//  Copyright © 2018 a27. All rights reserved.
//

import UIKit

class PreformersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Outlets
    @IBOutlet weak var preformersTableView: UITableView!
    
    //Variables
    let preformersInfoNames = ["Preformence Name", "Soundcheck Time", "Rig Up Time", "Show Time", "Rig Down Time", "Line Up Placement"]
    var whichTextFieldIsSelectedByItsTagNumber: Int = 0
    var showTimePickerData: [String] = []
    var soundcheckTimePickerData: [String] = []
    var lineUpPlacementData: [String] = ["1","2","3"]
    var name: UITextField? = nil
    var soundcheckTime: UITextField? = nil
    var rigUpTime: UITextField? = nil
    var showTime: UITextField? = nil
    var rigDownTime: UITextField? = nil
    var lineUpPlacement: UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preformersTableView.delegate = self
        preformersTableView.dataSource = self
        preformersTableView.alwaysBounceVertical = false
        preformersTableView.tableFooterView = UIView()
        showTimeEveryFiveMinInTotal()
        soundcheckTimeEveryFiveMinInTotal()
    }
    
    //Methods --> Tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! PreformersTableViewCell
        switch indexPath.row {
        case 0:             //Preformence Name tag = 200
            textFieldEdit(name!)
        case 1:             //Soundcheck Time tag = 201
            textFieldEdit(soundcheckTime!)
        case 2:             //Rig Up Time tag = 202
            textFieldEdit(rigUpTime!)
        case 3:             //Show Time tag = 203
            textFieldEdit(showTime!)
        case 4:             //Rig Down Time tag = 204
            textFieldEdit(rigDownTime!)
        case 5:             //Line Up Placement tag = 205
            textFieldEdit(lineUpPlacement!)
        default:
            print("Default")
        }
    }
    
    func textFieldEdit (_ sender: UITextField) {
        whichTextFieldIsSelectedByItsTagNumber = sender.tag
        if sender.tag == 200 {
            sender.viewWithTag(whichTextFieldIsSelectedByItsTagNumber)?.becomeFirstResponder()
        } else if sender.tag == 201 {
            soundcheckTimerPickerLoad(sender)
        } else if sender.tag >= 202 && sender.tag <= 204{
            countDownTimerPickerLoad(sender)
        } else if sender.tag == 205 {
            lineUpPlacementPickerLoad(sender)
        }
    }
    
    //Methods --> Construting Pickers
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
    
    //Methods --> Building Up Time array
    func showTimeEveryFiveMinInTotal() {
        let everyFiveMinInTotalShowTime = (200) / 5 //FIXA SEN NÄR COREDATA ÄR PÅ PLATS
        appendTimeInPickerData(runs: everyFiveMinInTotalShowTime, array: &showTimePickerData)
    }
    
    func soundcheckTimeEveryFiveMinInTotal() {
        let everyFiveMinInTotalSoundcheckTime = (100) / 5 //FIXA SEN NÄR COREDATA ÄR PÅ PLATS
        appendTimeInPickerData(runs: everyFiveMinInTotalSoundcheckTime, array: &soundcheckTimePickerData)
    }
    
    func appendTimeInPickerData(runs: Int, array: inout [String]) {
        array.removeAll()
        for i in 1...runs {
            array.append("\(i * 5) min")
        }
    }
    //Methods --> Errorchecks
    func ifAnyInputFieldIsEmpty () {
        if (name?.text?.isEmpty)! || (soundcheckTime?.text?.isEmpty)! || (rigUpTime?.text?.isEmpty)! || (showTime?.text?.isEmpty)! || (rigDownTime?.text?.isEmpty)! || (lineUpPlacement?.text?.isEmpty)! {
            alertIfAnyInputFieldIsEmpty()
        }
    }
    
    //Methods --> Alerts
    func alertIfAnyInputFieldIsEmpty () {
        let alert = UIAlertController(title: "What are you trying to do?", message: "You must fill out all the boxes before continuing.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    //Helpers --> Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preformersInfoNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preformersCell") as! PreformersTableViewCell
        cell.preformersCellLabel.text = preformersInfoNames[indexPath.row]
        cell.preformersCellTextField.tag = indexPath.row + 200
        name = self.view.viewWithTag(200) as? UITextField
        soundcheckTime = self.view.viewWithTag(201) as? UITextField
        rigUpTime = self.view.viewWithTag(202) as? UITextField
        showTime = self.view.viewWithTag(203) as? UITextField
        rigDownTime = self.view.viewWithTag(204) as? UITextField
        lineUpPlacement = self.view.viewWithTag(205) as? UITextField
        return cell
    }
    
    //Helpers --> PickerView
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
    
    //Helpers --> Closes InputView
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
