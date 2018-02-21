//
//  ViewController.swift
//  CalenderApp
//
//  Created by Ankit Garg on 08/02/2018.
//  Copyright © 2018 Ankit Garg. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var monthYearFormatter =  DateFormatter()
    var dataArray : [EventSectionsData] = []
    var weatherDataArray : [EventData] = []
    var locationManger : CLLocationManager!
    var currentLocation : CLLocation?
    var updateAfterCheck = false
    var weatherDataCalled = false
    
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
        initializeLocationManager()
        getUserLocation()
        dataArray  = CalenderDataVader.sharedInstance.getTotalEventsData()
        tableView.reloadData()
    }
    
    @IBAction func addEventTapped(_ sender: Any) {
        openAddEventVC(date : Date())
    }
    
    func openAddEventVC(date : Date){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyBoard.instantiateViewController(withIdentifier: "addEventNavigationVC") as! UINavigationController
        let vc = rootVC.viewControllers[0] as! AddEventViewController
        vc.selectedDate = date
        vc.addEventDelegate = self
        self.present(rootVC, animated: true, completion: nil)
    }
    
    func setViewcontrollerTitle(_ date : Date){
        
        monthYearFormatter.dateFormat = "MMM YYYY"
        self.title = monthYearFormatter.string(from: date).capitalized
        
    }
    
    func initializeLocationManager(){
        
        locationManger = CLLocationManager()
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    func handleLocationUnAuthorisedCase(){
        
        if CLLocationManager.authorizationStatus() == .denied {
            
            if CLLocationManager.locationServicesEnabled(){
                
                let alert = UIAlertController(title: "For Better Accuracy, Location Permission needed", message: "Go to App Settings -> Location -> While Using the App", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {action in
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: {action in
                    self.updateAfterCheck = true
                    UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                    
                }))
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else{
                let alert = UIAlertController(title: "Location is off, For Better Accuracy", message: "Go to Settings -> Privacy -> Location Service -> On", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {action in
                    
                }))
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func getUserLocation(){
        
        updateAfterCheck = false
        
        if isGPSOn(){
            locationManger.startUpdatingLocation()
            
        }else{
            updateAfterCheck = true
            locationManger.requestWhenInUseAuthorization()
            handleLocationUnAuthorisedCase()
            
        }
    }
    
    func isGPSOn() -> Bool{
        
        if CLLocationManager.locationServicesEnabled(){
            if CLLocationManager.authorizationStatus() == .authorizedAlways ||  CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                return true
            }else{
                handleLocationUnAuthorisedCase()
            }
        }
        return false
    }
    
    func callWeatherData(location : CLLocation){
        let obj = NetworkProvider()
        obj.getWeatherDetails(location: location) { (dict) in
            if let dict = dict{
                if let dailyData = dict["daily"] as? [String:AnyObject]{
                    if let dataArr = dailyData["data"] as? [[String:AnyObject]]{
                        for data in dataArr{
                            let weatherData = WeatherData(dict: data)
                            if let summary = weatherData.summary, let date = weatherData.date, let icon = weatherData.icon{
                                self.weatherDataArray.append(EventData(eventName: summary, eventDate: date, icon : icon, type : 2))
                                for eventData in self.dataArray{
                                    if eventData.date?.dateIneeemonInLocal == date.dateIneeemonInLocal{
                                        eventData.eventData.append(EventData(eventName: summary, eventDate: date, icon : icon, type : 2))
                                    }
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }
    
}
// MARK:- Location Handling
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location : CLLocation = locations.first!
        
        self.perform(#selector(ViewController.geoGMScode(_:)), with: location, afterDelay: 1)
        locationManger.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if updateAfterCheck{
            getUserLocation()
        }
    }
    
    @objc func geoGMScode(_ location : CLLocation){
        currentLocation = location
        if !weatherDataCalled{
            weatherDataCalled = true
            callWeatherData(location: location)
        }
        
    }
    
}
// MARK:- Tableview Handling
extension ViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataArray[indexPath.section]
        if data.eventData.count == 0{
            if let date = data.date{
                openAddEventVC(date: date)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let indexSet = tableView.indexPathsForVisibleRows{
            let topIndex = indexSet[0]
            if dataArray.count > topIndex.section{
                if let date = dataArray[topIndex.section].date{
                    calenderView.selectionStartDate = date
                    calenderView.scrollTo(month: date, animated: true)
                    
                }
                
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let indexSet = tableView.indexPathsForVisibleRows{
            let topIndex = indexSet[0]
            if dataArray.count > topIndex.section{
                if let date = dataArray[topIndex.section].date{
                    //                    calenderView.scrollTo(month: date, animated: true)
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
            if data[indexPath.row].type == 1{ //Event Cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! CellTableViewCell
                let data = data[indexPath.row]
                cell.data = data
                return cell
            }else{ // Weather Cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCellID", for: indexPath) as! WeatherTableViewCell
                let data = data[indexPath.row]
                cell.data = data
                return cell
            }
            
        }else{ // Blank cell in case of No event
            let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell", for: indexPath)
            return cell
        }
        
        
    }
    
}
// MARK:- Calender Handling
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
// MARK:- Add Event Handling
extension ViewController : AddEventProtocol{
    func saveTapped(){
        dataArray  = CalenderDataVader.sharedInstance.getTotalEventsData()
        
        for weatherData in weatherDataArray{
            if let summary = weatherData.eventName, let date = weatherData.eventDate, let icon = weatherData.icon{
                for eventData in self.dataArray{
                    if eventData.date?.dateIneeemonInLocal == date.dateIneeemonInLocal{
                        eventData.eventData.append(EventData(eventName: summary, eventDate: date, icon : icon, type : 2))
                    }
                }
            }
        }
        tableView.reloadData()
        
    }
    func cancelTapped(){
        
    }
}

