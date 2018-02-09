//
//  CellTableViewCell.swift
//  CalenderApp
//
//  Created by Ankit Garg on 08/02/2018.
//  Copyright © 2018 Ankit Garg. All rights reserved.
//

import UIKit

class CellTableViewCell: UITableViewCell {

    @IBOutlet weak var eventLabel: UILabel!
    
    var data : EventData?{
        didSet{
            if let event = data{
                if let name = event.eventName{
                    eventLabel.text = name
                }
            }
        }
    }

}
