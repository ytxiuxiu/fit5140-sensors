//
//  PressureSensor.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 12/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit

class MeterSense: NSObject {
    
    static let sensor = "meters"
    
    static let values = (thermometer: "thermometer", barometer: "barometer", altimeter: "altimeter")
    
    var thermometer: Double?
    
    var barometer: Double?
    
    var altimeter: Double?
    
    override init() {
        
    }
    
    init(thermometer: Double, barometer: Double, altimeter: Double) {
        self.thermometer = thermometer
        self.barometer = barometer
        self.altimeter = altimeter
    }
    
    override var description: String {
        return "MeterSense [thermometer=\(self.thermometer?.simplify() ?? ""), barometer=\(self.barometer?.simplify() ?? ""), altimeter=\(self.altimeter?.simplify() ?? "")]"
    }
    
}
