//
//  WeatherTableViewCell.swift
//  CalenderApp
//
//  Created by Ankit Garg on 12/02/2018.
//  Copyright © 2018 Ankit Garg. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var data : EventData?{
        didSet{
            if let event = data{
                if let name = event.eventName{
                    titleLabel.text = name
                }
                if let icon = event.icon{
                    if icon == "partly-cloudy-night"{
                        iconImage.image = UIImage(named : "storm")
                    }else if icon == "rain"{
                        iconImage.image = UIImage(named : "rain")
                    }else if icon == "cloudy"{
                        iconImage.image = UIImage(named : "cloudy")
                    }else{
                        iconImage.image = UIImage(named : "cloudy")
                    }
                }
            }
        }
    }
    
}
