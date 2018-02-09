//
//  ViewController.swift
//  CalenderApp
//
//  Created by Ankit Garg on 08/02/2018.
//  Copyright © 2018 Ankit Garg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var monthYearFormatter =  DateFormatter()
    var dataArray : [EventSectionsData] = []
    
    @IBOutlet weak var tableView: UITableView!
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
        
        setViewcontrollerTitle(startDate)
        
        tableView.visibleCells
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataArray  = CalenderDataVader.sharedInstance.getTotalEventsData()
        tableView.reloadData()
    }

    @IBAction func addEventTapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyBoard.instantiateViewController(withIdentifier: "addEventNavigationVC") as! UINavigationController
        self.present(rootVC, animated: true, completion: nil)
    }
    
    func setViewcontrollerTitle(_ date : Date){
        
        monthYearFormatter.dateFormat = "MMM YYYY"
        self.title = monthYearFormatter.string(from: date).capitalized
        
    }
    


}

extension ViewController : UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let indexSet = tableView.indexPathsForVisibleRows{
            let topIndex = indexSet[1]
            if dataArray.count > topIndex.section{
                if let date = dataArray[topIndex.section].date{
                    calenderView.selectionStartDate = date
                    calenderView.scrollTo(month: date, animated: true)
                    setViewcontrollerTitle(date)
                }
                
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
            return 30
            
        }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 50
            
        }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader = UIView(frame: CGRect(x: 0,y: 0,width: tableView.frame.width,height: 35))
        sectionHeader.backgroundColor = UIColor.init(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        let titleLabel = UILabel(frame: CGRect(x: 15,y: 5,width: sectionHeader.frame.width,height: sectionHeader.frame.height-20))
        
        let headerValue =  dataArray[section].date?.dateIneeemonInLocal
        
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(13))
        titleLabel.text = headerValue
        sectionHeader.addSubview(titleLabel)
        return sectionHeader
        
    }
    
    
    
}
extension ViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArray[section].eventData.count > 0{
            return dataArray[section].eventData.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data =  dataArray[indexPath.section].eventData
        
        if data.count > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! CellTableViewCell
            let data = data[indexPath.row]
            cell.data = data
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell", for: indexPath)
            return cell
        }
        
        
    }
    
}
extension ViewController : UIScrollViewDelegate{
    
}
extension ViewController: DTCalendarViewDelegate {
    
    func calendarView(_ calendarView: DTCalendarView, didSelectDate date: Date) {
        
        if date >= Date().addingTimeInterval(-24*60*60){
            calendarView.selectionStartDate = date
            
            for (index,dateStored) in dataArray.enumerated(){
                if date.dateIneeemonInLocal == dateStored.date?.dateIneeemonInLocal{
                    let index = IndexPath(row: 0, section: index)
                    tableView.scrollToRow(at: index, at: .top, animated: true)
                    break
                }
            }
        }
    }
    
    func calendarView(_ calendarView: DTCalendarView, disabledDaysInMonth month: Date) -> [Int]? {
        
        let currentDate = Date()
        monthYearFormatter.dateFormat = "yyyy"
        if monthYearFormatter.string(from: month) == monthYearFormatter.string(from: currentDate){
            monthYearFormatter.dateFormat = "MMM"
            if monthYearFormatter.string(from: month) == monthYearFormatter.string(from: currentDate){
                monthYearFormatter.dateFormat = "dd"
                if let day = Int(monthYearFormatter.string(from: currentDate)){
                    let array = (1..<day).map { $0 }
                    return array
                }
            }}
        return nil
    }
    
    func calendarViewHeightForMonthView(_ calendarView: DTCalendarView) -> CGFloat {
        return 60
    }
    
    func calendarViewHeightForWeekRows(_ calendarView: DTCalendarView) -> CGFloat {
        return 30
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
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.backgroundColor = UIColor.white
        return label
    }
}

