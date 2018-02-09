//
//  AddEventViewController.swift
//  CalenderApp
//
//  Created by Ankit Garg on 08/02/2018.
//  Copyright © 2018 Ankit Garg. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textVeiw: UITextField!
    
    var selectedDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Event"
        textVeiw.becomeFirstResponder()
        setDateLabel(selectedDate)
        

        // Do any additional setup after loading the view.
    }
    
    func setDateLabel(_ date : Date){
        dateLabel.text = date.dateInDDMMMInLocal
    }
    
    func showPopUp(){
        let alert = UIAlertController(title: "Title Empty", message: "Enter some text in title field", preferredStyle: UIAlertControllerStyle.alert)
        
        let noAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
            
        }
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func selectDateTapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyBoard.instantiateViewController(withIdentifier: "calenderVC") as! UINavigationController
        let vc = rootVC.viewControllers[0] as! CalenderViewController
        vc.calenderDelegate = self
        self.present(rootVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if textVeiw.text != ""{
            CalenderDataVader.sharedInstance.saveEvent(eventTitle: textVeiw.text!, date: self.selectedDate)
            self.dismiss(animated: true, completion: nil)
        }else{
            showPopUp()
        }
        
    }
}
extension AddEventViewController : CalenderProtocol{
    func selectedDate(date : Date?){
        if let date = date{
            self.selectedDate = date
            setDateLabel(selectedDate)
            
        }
    }
}
