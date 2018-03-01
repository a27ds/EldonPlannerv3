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
    let eventInfoNames = ["How Many Performers", "Get-in", "Dinner", "Doors", "Music Curfew", "Venue Curfew"]
    var whichTextFieldIsSelectedByItsTagNumber: Int = 0
    var counterClick = 1
    var timeForTimeWheel: String?
    
    var event: Event? = nil
    
    var getIn: UITextField? = nil
    var dinner: UITextField? = nil
    var doors: UITextField? = nil
    var musicCurfew: UITextField? = nil
    var venueCurfew: UITextField? = nil
    var howManyPerformers: UITextField? = nil
    
    var cellIndexPath: IndexPath? = nil
    
    var howManyPerformersEdit: Bool = false
    var getInEdit: Bool = false
    var doorsEdit: Bool = false
    var musicCurfewEdit: Bool = false
    var venueCurfewEdit: Bool = false
    
    //  ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableViewSet()
    }
    
    //  ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        observerSet()
    }
    
    //  ViewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //  IBActions --> TapGestures
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        eventTableView.deselectRow(at: cellIndexPath!, animated: true)
    }
    
    //  IBActions --> Buttons
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
            destVC.event = Event(getIn: (getIn?.text!)!, dinner: (dinner?.text!)!, doors: (doors?.text!)!, musicCurfew: (musicCurfew?.text!)!, venueCurfew: (venueCurfew?.text!)!, howManyPerformers: Int((howManyPerformers?.text!)!)!)
        }
    }
    
    //  Method --> Makes the statusbar light colored
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //  Methods --> Setting the observers to checks if any UITextfield did end it's editing, and then Display a done button in navbar
    func observerSet() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: getIn)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: dinner)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: doors)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: musicCurfew)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: venueCurfew)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldEndEdit), name: Notification.Name.UITextFieldTextDidEndEditing, object: howManyPerformers)
    }
    
    //  Methods --> Observer Method
    @objc func textFieldEndEdit() {
        shouldNextButtonDisplay(anyInputFieldIsEmpty: anyInputFieldIsEmpty())
    }
    
    //  Methods --> Tableview
    func eventTableViewSet() {
        eventTableView.delegate = self
        eventTableView.dataSource = self
        eventTableView.alwaysBounceVertical = false
        eventTableView.tableFooterView = UIView()
        eventTableView.rowHeight = 44.0
        eventTableView.backgroundView = UIView()
        eventTableView.backgroundView?.addGestureRecognizer(tap)
    }
    
    //  Methods --> Tableview | Locks the different cells to guide the user on the right path
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath.row >= counterClick) {
            return nil
        }
        counterClick += 1
        return indexPath
    }
    
    //  Methods --> Tableview | Detect user input on the tableview and preform actions after choice
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellIndexPath = indexPath
        setTagToName()
        switch indexPath.row {
        case 0:             //How many performers tag = 100
            textFieldEdit(howManyPerformers!)
            setColorOnLabels(2)
        case 1:             //Get-in tag = 101
            timeForTimeWheel = "15:00"
            textFieldEdit(getIn!)
            setColorOnLabels(3)
        case 2:             //Dinner tag = 102
            timeForTimeWheel = "18:00"
            textFieldEdit(dinner!)
            setColorOnLabels(4)
        case 3:             //Doors tag = 103
            timeForTimeWheel = "19:00"
            textFieldEdit(doors!)
            setColorOnLabels(5)
        case 4:             //Music Curfew tag = 104
            timeForTimeWheel = "00:00"
            textFieldEdit(musicCurfew!)
            setColorOnLabels(6)
        case 5:             //Venue Curfew tag = 105
            timeForTimeWheel = "03:00"
            textFieldEdit(venueCurfew!)
        default:
            print("This sentence should never be printed")
        }
    }
    
    //  Methods --> Tableview | Method that runs when a cell is deselected
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        eventTableView.deselectRow(at: indexPath, animated: true)
    }
    
    //  Methods --> Textfield became active
    func textFieldEdit (_ sender: UITextField) {
        whichTextFieldIsSelectedByItsTagNumber = sender.tag
        if sender.tag == 100 {
            numPadEdit(sender)
        } else if sender.tag >= 101 && sender.tag <= 105{
            timePickerEdit(sender)
        }
    }
    
    //  Methods --> Button becomes visible
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
    
    //  Methods --> Set a variable to a Tag
    func setTagToName() {
        howManyPerformers = self.view.viewWithTag(100) as? UITextField
        getIn = self.view.viewWithTag(101) as? UITextField
        dinner = self.view.viewWithTag(102) as? UITextField
        doors = self.view.viewWithTag(103) as? UITextField
        musicCurfew = self.view.viewWithTag(104) as? UITextField
        venueCurfew = self.view.viewWithTag(105) as? UITextField
    }
    
    //  Methods --> Setting color to Pickers
    func setPickerColor(sender: UIDatePicker) {
        sender.backgroundColor = .black
        sender.setValue(UIColor.red, forKey:"textColor")
    }
    
    //  Methods --> Construting TimePicker
    func timePickerEdit(_ sender: UITextField) {
        let timePicker = timePickerLoad()
        setPickerColor(sender: timePicker)
        sender.inputView = timePicker
        sender.viewWithTag(whichTextFieldIsSelectedByItsTagNumber)?.becomeFirstResponder()
        timePicker.addTarget(self, action: #selector(timePickerValueChangedStart(sender:)), for: UIControlEvents.valueChanged)
    }
    
    @objc func timePickerValueChangedStart(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.none
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateFormat = "HH:mm"
        let textField = self.view.viewWithTag(whichTextFieldIsSelectedByItsTagNumber) as! UITextField
        textField.text = formatter.string(from: sender.date)
    }
    
    func timePickerLoad() -> UIDatePicker{
        let timePicker = UIDatePicker()
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.none
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateFormat = "HH:mm"
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
        if (getIn?.text?.isEmpty)! || (dinner?.text?.isEmpty)! || (doors?.text?.isEmpty)! || (musicCurfew?.text?.isEmpty)! || (venueCurfew?.text?.isEmpty)! || (howManyPerformers?.text?.isEmpty)! {
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
        cell.eventCellLabel.tag = indexPath.row + 300
        cell.eventCellLabel.textColor = UIColor.gray
        cell.eventCellTextField.tag = indexPath.row + 100
        setTagToName()
        let dateLabel = self.view.viewWithTag(300) as? UILabel          //Make a UILabel from it's tag
        dateLabel?.textColor = UIColor.white                            //Setting Text color to the UILabel to get the user to understand what to click.
        return cell                                                     //Will continue doing this in the next method
    }
    // Methods --> Setting some color to the cells
    func setColorOnLabels(_ index: Int) {
        let howManyPerformersLabel = self.view.viewWithTag(301) as? UILabel
        let getinLabel = self.view.viewWithTag(302) as? UILabel
        let dinnerLabel = self.view.viewWithTag(303) as? UILabel         //Makes UILabel's from it's tags
        let doorsLabel = self.view.viewWithTag(304) as? UILabel
        let musicCurfewLabel = self.view.viewWithTag(305) as? UILabel
        let venueCurfewLabel = self.view.viewWithTag(306) as? UILabel
        switch index {
        case 2:
            howManyPerformersLabel?.textColor = UIColor.white
        case 3:
            getinLabel?.textColor = UIColor.white
        case 4:
            dinnerLabel?.textColor = UIColor.white                       //Setting Text color's to the UILabels to get the user to understand what to click.
        case 5:
            doorsLabel?.textColor = UIColor.white
        case 6:
            musicCurfewLabel?.textColor = UIColor.white
        case 7:
            venueCurfewLabel?.textColor = UIColor.white
        default:
            print("ERROR! Or is it an error?")
        }
    }
}
