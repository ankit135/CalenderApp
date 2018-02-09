//
//  CalenderViewController.swift
//  CalenderApp
//
//  Created by Ankit Garg on 09/02/2018.
//  Copyright © 2018 Ankit Garg. All rights reserved.
//

import UIKit

protocol CalenderProtocol : class {
    func selectedDate(date : Date?)
}

class CalenderViewController: UIViewController {
    
    var monthYearFormatter =  DateFormatter()
    weak var calenderDelegate : CalenderProtocol?
    var selectedDate : Date?

    @IBOutlet weak var calenderView: DTCalendarView!{
        didSet {
            calenderView.delegate = self
            calenderView.displayStartDate = startDate
            calenderView.displayEndDate = endDate
            calenderView.previewDaysInPreviousAndMonth = true
            calenderView.paginateMonths = false
            calenderView.mondayShouldBeTheFirstDayOfTheWeek = true
            calenderView.selectionStartDate = Date()
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select Date"

    }

    @IBAction func doneTapped(_ sender: Any) {
        calenderDelegate?.selectedDate(date: selectedDate)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension CalenderViewController: DTCalendarViewDelegate {
    
    func calendarView(_ calendarView: DTCalendarView, didSelectDate date: Date) {
        
        if date >= Date().addingTimeInterval(-24*60*60){
            calendarView.selectionStartDate = date
        }
        
        selectedDate = date
    }
    
    func calendarView(_ calendarView: DTCalendarView, disabledDaysInMonth month: Date) -> [Int]? {
        
        
        return nil
    }
    
    func calendarViewHeightForMonthView(_ calendarView: DTCalendarView) -> CGFloat {
        return 60
    }
    
    func calendarViewHeightForWeekRows(_ calendarView: DTCalendarView) -> CGFloat {
        return 60
    }
    
    func calendarViewHeightForWeekdayLabelRow(_ calendarView: DTCalendarView) -> CGFloat {
        return 20
    }
    
    
    func calendarView(_ calendarView: DTCalendarView, dragFromDate fromDate: Date, toDate: Date) {
        
    }
    
    func calendarView(_ calendarView: DTCalendarView, viewForMonth month: Date) -> UIView {
        let label = UILabel()
        monthYearFormatter.dateFormat = "MMM YYYY"
        label.text = monthYearFormatter.string(from: month).capitalized
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.backgroundColor = UIColor.white
        return label
    }
}
