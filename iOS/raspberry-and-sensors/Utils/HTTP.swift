//
//  HTTP.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 16/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit

class HTTP: NSObject {
    
    static let shared = HTTP()

    static let baseUrl = "http://192.168.0.6/history/"
    
    
    func getHistory(sensor: String, value: String, skip: Int, limit: Int, callback: @escaping (_ error: NSError?, _ senses: [Any]?) -> Void) {
        let url = URL(string: "\(HTTP.baseUrl)\(sensor)/\(value)/\(skip)/\(limit)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if sensor == "pressure" {
                    var senses = [PressureSense]()
                    
                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    let array = result as! NSArray
                    
                    for object in (array as NSArray as! [NSDictionary]) {
                        let sense = PressureSense()
                        
                        if let thermometer = object.object(forKey: PressureSense.values.thermometer) {
                            print(thermometer)
                            sense.thermometer = thermometer as? Double
                        }
                        if let barometer = object.object(forKey: PressureSense.values.barometer) {
                            sense.barometer = barometer as? Double
                        }
                        if let altimeter = object.object(forKey: PressureSense.values.altimeter) {
                            sense.altimeter = altimeter as? Double
                        }
                        
                        senses.append(sense)
                    }
                    
                    callback(nil, senses)
                } else if sensor == "colour" {
                    // TODO
                }
                
            } catch let error as NSError {
                print("Cannot parse json of pressure history \(error)")
                callback(error, nil)
            }
        }
        
        task.resume()
    }
    
}
