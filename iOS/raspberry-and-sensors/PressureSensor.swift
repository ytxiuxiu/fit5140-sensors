//
//  PressureSensor.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 12/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit

class PressureSensor: NSObject {
    
    private var thermometer: Double
    
    private var barometer: Double
    
    private var altimeter: Double
    
    
    init(thermometer: Double, barometer: Double, altimeter: Double) {
        self.thermometer = thermometer
        self.barometer = barometer
        self.altimeter = altimeter
    }
    
    func getTemperatureCelsius() -> Double {
        
        // Website: Kelvin to Celsius formula
        //      http://www.rapidtables.com/convert/temperature/how-kelvin-to-celsius.htm
        
        return self.thermometer - 273.15
    }
    
    func getTemperatureFahrenheit() -> Double {
        
        // Website: Kelvin to Fahrenheit formula
        //      http://www.rapidtables.com/convert/temperature/how-kelvin-to-fahrenheit.htm
        
        return self.thermometer * 9 / 5 - 459.67
    }
    
    func getPressurePa() -> Double {
        return self.barometer
    }
    
    func getAltitudeMeters() -> Double {
        return self.altimeter
    }
    
    func getAltitudeFeet() -> Double {
        
        // Website: Meters to Feets conversion
        //      http://www.rapidtables.com/convert/length/meter-to-feet.htm
        
        return self.altimeter / 0.3048
    }
    
    override var description: String {
        return "PressureSensor [thermometer=\(self.thermometer), barometer=\(self.barometer), altimeter=\(self.altimeter)]"
    }
}
