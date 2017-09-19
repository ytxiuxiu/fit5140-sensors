//
//  NumberExtension.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 15/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit

extension Double {
    
    /**
     Convert to simplified string with 1 decimal point
     
     - Returns: String format
     */
    func simplify() -> String {
        return String(format: "%.1f", self)
    }
    
    /**
     Convert to simplified string with a specific decimal number
     
     - Parameters:
        - decimal: Number of decimal points
     
     - Returns: String format
     */
    func simplify(decimal: Int) -> String {
        return String(format: "%.\(decimal)f", self)
    }
    
    /**
     Convert to current temperature unit
    
     - Returns: Data in current temperature unit
     */
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
    
    /**
     Get celsius
     
     - Returns: Temperature in celsius
     */
    var celsius: Double {
        get {
            // ✴️ Attributes:
            // Website: Kelvin to Celsius formula
            //      http://www.rapidtables.com/convert/temperature/how-kelvin-to-celsius.htm
            
            return self - 273.15
        }
    }
    
    /**
     Convert from celsius to kelvin
     
     - Returns: Temperature in kelvin
     */
    func celsiusToKelvin() -> Double {
        return self + 273.15
    }
    
    /**
     Get fahrenheit
     
     - Returns: Temperature in fahrenheit
     */
    var fahrenheit: Double {
        get {
            // ✴️ Attributes:
            // Website: Kelvin to Fahrenheit formula
            //      http://www.rapidtables.com/convert/temperature/how-kelvin-to-fahrenheit.htm
            
            return self * 9 / 5 - 459.67
        }
    }
    
    /**
     Convert from fahrenheit to kelvin
     
     - Returns: Temperature in kelvin
     */
    func fahrenheitToKelvin() -> Double {
        return (self + 459.67) * 5 / 9
    }
    
    /**
     Get pressure in current pressure unit according to the settings
    
     - Returns: Pressure in current unit
     */
    func toCurrentPressureUnit() -> Double {
        let setting = Setting.shared
        
        if setting.pressureUnit == Setting.pressureUnits.hPa {
            return self.hPa
        } else {
            return self
        }
    }
    
    /**
     Get kPa
     
     - Returns: Pressure in kPa
     */
    var kPa: Double {
        get {
            return self
        }
    }
    
    /**
     Get hPa
     
     - Returns: Pressure in hPa
     */
    var hPa: Double {
        get {
            return self * 10
        }
    }
    
    /**
     Convert from hPa to kPa
     
     - Returns: Pressure in kPa
     */
    func hPaToKPa() -> Double {
        return self / 10
    }
    
    /**
     Get altitude in current altitude unit according to the settings
     
     - Returns: Altitude in current unit
     */
    func toCurrentAltitudeUnit() -> Double {
        let setting = Setting.shared
        
        if setting.altitudeUnit == Setting.altitudeUnits.feet {
            return self.feet
        } else {
            return self
        }
    }
    
    /**
     Get meters
     
     - Returns: Altitude in meters
     */
    var meters: Double {
        get {
            return self
        }
    }
    
    /**
     Get feet
     
     - Returns: Altitude in feet
     */
    var feet: Double {
        get {
            // ✴️ Attributes:
            // Website: Meters to Feets conversion
            //      http://www.rapidtables.com/convert/length/meter-to-feet.htm
            
            return self / 0.3048
        }
    }
    
    /**
     Convert from feet to meters
     
     - Returns: Temperature in meters
     */
    func feetToMeters() -> Double {
        return self * 0.3048
    }
}
