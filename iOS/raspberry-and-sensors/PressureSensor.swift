//
//  PressureSensor.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 12/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit

class PressureSensor: NSObject {
    
    var thermometer: Double
    
    var barometer: Double
    
    var altimeter: Double
    
    
    init(thermometer: Double, barometer: Double, altimeter: Double) {
        self.thermometer = thermometer
        self.barometer = barometer
        self.altimeter = altimeter
    }
    
    override var description: String {
        return "PressureSensor [thermometer=\(self.thermometer), barometer=\(self.barometer), altimeter=\(self.altimeter)]"
    }
    
}
