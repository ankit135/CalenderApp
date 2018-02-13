//
//  NetworkProvider.swift
//  CalenderApp
//
//  Created by Ankit Garg on 12/02/2018.
//  Copyright © 2018 Ankit Garg. All rights reserved.
//

import UIKit
import CoreLocation

class NetworkProvider: NSObject {
    
    
    func getWeatherDetails(location : CLLocation, completion: @escaping ([String:AnyObject]?) -> ()) {
        
        let urlString = "https://api.darksky.net/forecast/47edc8e1ef5a7383057135e95f45a33c/\(location.coordinate.latitude),\(location.coordinate.longitude)"
        
        let url = URL(string:urlString.trimmingCharacters(in: .whitespaces))
        let request = URLRequest(url: url!)
       
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                
                let jsonData = self.convertToJson(data: data)
                print("response : \(String(describing: jsonData))")
                completion(jsonData)
                
            }
            task.resume()
        
        
        
    }
    
    func convertToJson(data : Data) -> [String:AnyObject]?{
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:AnyObject]
            {
                return json
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
            
        }
        return nil
    }

}
