//
//  HTTP.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 16/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit


//  Website: How to create and throw an Error Swift 3 | The Agile Warrior
//      https://agilewarrior.wordpress.com/2016/11/21/how-to-create-and-throw-an-error-swift-3/

enum HTTPError: Error {
    case JSONError(String)
    case ServerError(String)
}


/**
 HTTP
 */
class HTTP: NSObject {
    
    static let shared = HTTP()

    static let baseUrl = "http://192.168.0.6/history/"
//    static let baseUrl = "http://192.168.43.154/history/"
    
    
    /**
     Get history data from the server
 
     - Parameters:
        - sensor: Sensor's name
        - value: Which value of the sensor (eg. barometer)
        - limit: How many hisotry data
        - callback: Callback function
     */
    func getHistory(sensor: String, value: String, limit: Int, callback: @escaping (_ error: Error?, _ senses: [Any]?) -> Void) {
        let url = URL(string: "\(HTTP.baseUrl)\(sensor)/\(value)/\(limit)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard data != nil else {
                callback(HTTPError.ServerError("No result from the server"), nil)
                return
            }
            
            do {
                if sensor == "meters" {
                    var senses = [MeterSense]()
                    
                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    
                    let object = result as? NSDictionary
                    
                    if let object = object {
                        if let error = object.object(forKey: "error") {
                            let errorObject = error as? NSDictionary
                            
                            if let errorObject = errorObject {
                                print(errorObject)
                                if let message = errorObject.object(forKey: "message") as? String {
                                    callback(HTTPError.ServerError(message), nil)
                                } else {
                                    callback(HTTPError.ServerError("Unknown reason"), nil)
                                }
                            }
                            return
                        }
                        
                        let array = object["senses"] as? NSArray
                        
                        if let array = array {
                            for data in (array as NSArray as! [NSDictionary]) {
                                let sense = MeterSense()
                                
                                if let thermometer = data.object(forKey: MeterSense.values.thermometer) {
                                    sense.thermometer = thermometer as? Double
                                }
                                if let barometer = data.object(forKey: MeterSense.values.barometer) {
                                    sense.barometer = barometer as? Double
                                }
                                if let altimeter = data.object(forKey: MeterSense.values.altimeter) {
                                    sense.altimeter = altimeter as? Double
                                }
                                
                                senses.append(sense)
                            }
                        } else {
                            callback(HTTPError.JSONError("Cannot be understood"), nil)
                            return
                        }
                    }
                    
                    callback(nil, senses)
                } else if sensor == "colour" {
                    // TODO
                }
                
            } catch let error as NSError {
                print("Cannot parse json of history data: \(error)")
                callback(error, nil)
            }
        }
        
        task.resume()
    }
    
}
