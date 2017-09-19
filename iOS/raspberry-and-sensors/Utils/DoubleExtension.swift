//
//  NumberExtension.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 15/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit

extension Double {
    
    func simplify() -> String {
        return String(format: "%.1f", self)
    }
    
    func simplify(decimal: Int) -> String {
        return String(format: "%.\(decimal)f", self)
    }
    
    func toCurrentTemperatureUnit() -> Double {
        let setting = Setting.shared
        
        if setting.temperatureUnit == Setting.temperatureUnits.c {
            return self.celsius
        } else if setting.temperatureUnit == Setting.temperatureUnits.f {
            return self.fahrenheit
        } else {
            return self
        }
    }
    
    var celsius: Double {
        get {
            // Website: Kelvin to Celsius formula
            //      http://www.rapidtables.com/convert/temperature/how-kelvin-to-celsius.htm
            
            return self - 273.15
        }
    }
    
    func celsiusToKelvin() -> Double {
        return self + 273.15
    }
    
    var fahrenheit: Double {
        get {
            // Website: Kelvin to Fahrenheit formula
            //      http://www.rapidtables.com/convert/temperature/how-kelvin-to-fahrenheit.htm
            
            return self * 9 / 5 - 459.67
        }
    }
    
    func fahrenheitToKelvin() -> Double {
        return (self + 459.67) * 5 / 9
    }
    
    func toCurrentPressureUnit() -> Double {
        let setting = Setting.shared
        
        if setting.pressureUnit == Setting.pressureUnits.hPa {
            return self.hPa
        } else {
            return self
        }
    }
    
    var kPa: Double {
        get {
            return self
        }
    }
    
    var hPa: Double {
        get {
            return self * 10
        }
    }
    
    func hPaToKPa() -> Double {
        return self / 10
    }
    
    func toCurrentAltitudeUnit() -> Double {
        let setting = Setting.shared
        
        if setting.altitudeUnit == Setting.altitudeUnits.feet {
            return self.feet
        } else {
            return self
        }
    }
    
    var meters: Double {
        get {
            return self
        }
    }
    
    var feet: Double {
        get {
            // Website: Meters to Feets conversion
            //      http://www.rapidtables.com/convert/length/meter-to-feet.htm
            
            return self / 0.3048
        }
    }
    
    func feetToMeters() -> Double {
        return self * 0.3048
    }
}
