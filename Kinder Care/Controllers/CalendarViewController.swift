//
//  ViewController.swift
//  Calendar
//
//  Created by CIPL on 12/2/19.
//  Copyright © 2019 CIPL. All rights reserved.
//

import UIKit
import EventKit
import DropDown

class EventsCell : UITableViewCell{
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var viewEventsBackground: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var dayLbl: UILabel!
    
    
    
}


class CalendarViewController: BaseViewController, CalendarViewDataSource, CalendarViewDelegate {
    var arrayEvents = [HoildayData]()
    let arrayColors = [UIColor(red:85/255.0, green:204/255.0, blue:113/255.0, alpha:1.00),UIColor(red:79/255.0, green:152/255.0, blue:219/255.0, alpha:1.00),UIColor(red:238/255.0, green:155/255.0, blue:16/255.0, alpha:1.00),UIColor(red:155/255.0, green:89/255.0, blue:182/255.0, alpha:1.00)]
    
    
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var lblDivider: UILabel!
    @IBOutlet weak var tableViewEvents: UITableView!
    @IBOutlet weak var lblMonthTitle: UILabel!
    @IBOutlet weak var lblDayTitle: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    let monthsDropDown = DropDown()
    
    lazy var viewModel : HolidayViewModel = {
        return HolidayViewModel()
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //        let events = CalendarEvent(title: "test Event", startDate: Date(), endDate: Date())
        //        calendarView.events = [events]
        titleString = "CALENDAR"
        viewModel.delegate = self
        
        lblDivider.layer.masksToBounds = false
        
        
        lblDivider.layer.shadowColor = UIColor.gray.cgColor
        lblDivider.layer.shadowOpacity = 0.2
        lblDivider.layer.shadowOffset = CGSize(width: 0, height: 0)
        lblDivider.layer.shadowRadius = 2
        
        viewContainer.layer.cornerRadius = 10.0
        viewContainer.layer.masksToBounds = false
        viewContainer.layer.shadowColor = UIColor.lightGray.cgColor
        viewContainer.layer.shadowOpacity = 0.5
        viewContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewContainer.layer.shadowRadius = 5
        
        CalendarView.Style.cellShape                = .round
        CalendarView.Style.cellColorDefault         = UIColor.clear
        CalendarView.Style.cellColorToday           = UIColor(red:78/255.0, green:133/255.0, blue:245/255.0, alpha:1.00)
        CalendarView.Style.cellSelectedColor  = UIColor(red:78/255.0, green:133/255.0, blue:245/255.0, alpha:1.00)
        CalendarView.Style.cellEventColor           = UIColor(red:233/255.0, green:57/255.0, blue:13/255.0, alpha:1.00)
        CalendarView.Style.headerTextColor          = UIColor.black
        CalendarView.Style.cellTextColorDefault     = UIColor.black
        CalendarView.Style.cellTextColorToday       = UIColor.black
        CalendarView.Style.cellTextColorWeekend     = UIColor.black
        CalendarView.Style.cellSelectedTextColor    = UIColor.white
        CalendarView.Style.firstWeekday             = .sunday
        
        calendarView.dataSource = self
        calendarView.delegate = self
        
        calendarView.direction = .horizontal
        calendarView.multipleSelectionEnable = false
        calendarView.marksWeekends = true
        
        
        calendarView.backgroundColor = UIColor.white
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateMonths),
            name: NSNotification.Name(rawValue: "NotifyUpdateMonths"),
            object: nil)
        setupDaysDropDown()
        
        let date = Date()
        let calendar = Calendar.current
        var month =  calendar.component(.month, from: date)
        print(month)
        if let schoolID = UserManager.shared.currentUser?.school_id
        {
            viewModel.hoildayList(month: month, school_id: schoolID)
        }
    }
    @objc func updateMonths(){
        monthsDropDown.show()
    }
    func setupDaysDropDown() {
        monthsDropDown.anchorView = lblMonthTitle
        print(lblMonthTitle.text)
        monthsDropDown.bottomOffset = CGPoint(x: 0, y: lblMonthTitle.bounds.height)
        // You can also use localizationKeysDataSource instead. Check the docs.
        monthsDropDown.dataSource = ["January","February","March","April","May","June","July","August","September","October","November","December"]
        monthsDropDown.selectionAction = { [weak self] (index, item) in
            let monthIndex =  self?.calendarView.calendar.component(.month, from: (self?.calendarView.displayDate)!)
            print(index)
            print(item)
            
            self?.calendarView.goToMonth(offset: index+1  - monthIndex!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.setCurrentDate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadEvents()
        }
    }
    func loadEvents(){
        let today = Date()
        
        var tomorrowComponents = DateComponents()
        tomorrowComponents.day = 1
        
        
        let tomorrow = self.calendarView.calendar.date(byAdding: tomorrowComponents, to: today)!
        self.calendarView.selectDate(tomorrow)
        self.calendarView.loadEvents() { error in
            if error != nil {
                let message = "The karmadust calender could not load system events. It is possibly a problem with permissions"
                let alert = UIAlertController(title: "Events Loading Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        self.calendarView.setDisplayDate(today)
    }
    
    func setCurrentDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        let strDate = dateFormatter.string(from: Date())
        lblDayTitle.text = "\(strDate)"
        print(strDate)
    }
    
    // MARK : KDCalendarDataSource
    
    func startDate() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = -1
        
        let today = Date()
        
        let threeMonthsAgo = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
        
        return threeMonthsAgo
    }
    
    func endDate() -> Date {
        
        var dateComponents = DateComponents()
        
        dateComponents.year = 2;
        let today = Date()
        
        let twoYearsFromNow = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
        // self.calendarView.setDisplayDate( Date())
        return twoYearsFromNow
        
    }
    
    
    // MARK : KDCalendarDelegate
    
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        // print("Did Select: \(date) with \(events.count) events")
        print(date.asString(withFormat: "yyyy-MM-dd"))
        var dateFromApi = arrayEvents.map({$0.date})
        
        let dateApi = arrayEvents.filter({$0.date == date.asString(withFormat: "yyyy-MM-dd")})
        if dateApi.count > 0 {
            tableViewEvents.isHidden = false
            tableViewEvents.reloadData()
            
        }
        else{
            tableViewEvents.isHidden = true
        }
        
        for event in events {
            print("\t\"\(event.title)\" - Starting at:\(event.startDate)")
        }
        
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date : Date) {
        
    }
    
    
    func calendar(_ calendar: CalendarView, didLongPressDate date : Date) {
        
        let alert = UIAlertController(title: "Create New Event", message: "Message", preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Event Title"
        }
        
        let addEventAction = UIAlertAction(title: "Create", style: .default, handler: { (action) -> Void in
            let title = alert.textFields?.first?.text
            self.calendarView.addEvent(title!, date: date)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(addEventAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    // MARK : Events
    
    @IBAction func onValueChange(_ picker : UIDatePicker) {
        self.calendarView.setDisplayDate(picker.date, animated: true)
    }
    
    @IBAction func goToPreviousMonth(_ sender: Any) {
        self.calendarView.goToPreviousMonth()
    }
    @IBAction func goToNextMonth(_ sender: Any) {
        self.calendarView.goToNextMonth()
        
    }
    @IBAction func calendarButtonHandler(_ sender: Any) {
        self.calendarView.setDisplayDate(Date())
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
extension CalendarViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventsCell
        cell.lblEventTitle.text = arrayEvents[indexPath.row].holiday
        cell.dayLbl.text = arrayEvents[indexPath.row].day
        cell.dateLbl.text = arrayEvents[indexPath.row].date
        
        
        
        cell.viewEventsBackground.backgroundColor = arrayColors[indexPath.row]
        cell.viewEventsBackground.layer.cornerRadius = 4.0
        if indexPath.row == arrayEvents.count - 1 {
            cell.lblEventTitle.layer.borderColor =  UIColor(red:0.61, green:0.35, blue:0.71, alpha:1.0).cgColor
            
            cell.lblEventTitle.layer.borderWidth = 2.0
        }
        return cell
        
    }
}




extension CalendarViewController:HolidayDelegate{
    func holidaySuccess(Holiday: [HoildayData]) {
        arrayEvents = Holiday
        //tableViewEvents.reloadData()
    }
    
    func failure(message: String) {
        displayServerError(withMessage: message)
    }
    
    
}
