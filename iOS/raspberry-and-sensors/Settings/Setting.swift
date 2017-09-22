//
//  Setting.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 14/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit


/**
 Setting, for storing user settings
 */
class Setting: NSObject {
    
    static let shared = Setting()
    
    let keys = (inited: "inited", pressureUnit: "pressureUnit", altitudeUnit: "altitudeUnit", temperatureUnit: "temperatureUnit", temperatureAlarmOn: "temperatureAlarmOn", temperatureAlarmHigherThan: "temperatureAlarmHigherThan", temperatureAlarmLowerThan: "temperatureAlarmLowerThan", pressureAlarmOn: "pressureAlarmOn", pressureAlarmLowerThan: "pressureAlarmLowerThan", altitudeAlarmOn: "altitudeAlarmOn", altitudeAlarmHigherThan: "altitudeAlarmHigherThan")
    
    static let pressureUnits = (hPa: "hpa", kPa: "kpa")
    
    static let altitudeUnits = (m: "m", feet: "feet")
    
    static let temperatureUnits = (c: "c", f: "f", k: "k")
    
    let preferences = UserDefaults.standard
    
    var pressureUnit = pressureUnits.hPa
    
    var altitudeUnit = altitudeUnits.m
    
    var temperatureUnit = temperatureUnits.c
    
    var temperatureAlarmOn = false
    
    var temperatureAlarmHigherThan: Double?
    
    var temperatureAlarmLowerThan: Double?
    
    var pressureAlarmOn = false
    
    var pressureAlarmLowerThan: Double?
    
    var altitudeAlarmOn = false
    
    var altitudeAlarmHigherThan: Double?
    

    override init() {
        super.init()
        
        if preferences.object(forKey: keys.inited) == nil {
            // first time, init default settings
            preferences.set(true, forKey: keys.inited)
            
            temperatureAlarmHigherThan = 299.15 // 26℃
            temperatureAlarmLowerThan = 293.15  // 20℃
            
            pressureAlarmLowerThan = 102.0      // 1020hPa
            
            altitudeAlarmHigherThan = 3000.0    // 3000m
            
            self.save()
        } else {
            // otherwise, retrieve settings
            pressureUnit = preferences.string(forKey: keys.pressureUnit)!
            altitudeUnit = preferences.string(forKey: keys.altitudeUnit)!
            temperatureUnit = preferences.string(forKey: keys.temperatureUnit)!
            
            temperatureAlarmOn = preferences.bool(forKey: keys.temperatureAlarmOn)
            temperatureAlarmHigherThan = preferences.double(forKey: keys.temperatureAlarmHigherThan)
            temperatureAlarmLowerThan = preferences.double(forKey: keys.temperatureAlarmLowerThan)
            
            pressureAlarmOn = preferences.bool(forKey: keys.pressureAlarmOn)
            pressureAlarmLowerThan = preferences.double(forKey: keys.pressureAlarmLowerThan)
            
            altitudeAlarmOn = preferences.bool(forKey: keys.altitudeAlarmOn)
            altitudeAlarmHigherThan = preferences.double(forKey: keys.altitudeAlarmHigherThan)
        }
    }
    
    
    /**
     Persistent the settings
     */
    func save() {
        preferences.set(pressureUnit, forKey: keys.pressureUnit)
        preferences.set(altitudeUnit, forKey: keys.altitudeUnit)
        preferences.set(temperatureUnit, forKey: keys.temperatureUnit)
        
        preferences.set(temperatureAlarmOn, forKey: keys.temperatureAlarmOn)
        preferences.set(temperatureAlarmHigherThan, forKey: keys.temperatureAlarmHigherThan)
        preferences.set(temperatureAlarmLowerThan, forKey: keys.temperatureAlarmLowerThan)
        
        preferences.set(pressureAlarmOn, forKey: keys.pressureAlarmOn)
        preferences.set(pressureAlarmLowerThan, forKey: keys.pressureAlarmLowerThan)
        
        preferences.set(altitudeAlarmOn, forKey: keys.altitudeAlarmOn)
        preferences.set(altitudeAlarmHigherThan, forKey: keys.altitudeAlarmHigherThan)
        
        let didSave = preferences.synchronize()
        
        if !didSave {
            fatalError("Could not save the settings")
        }
    }
    
    
    // MARK: - Units
    
    /**
     Get current temperature unit symbol according to the setting
     */
    func getTemperatureUnitSymbol() -> String {
        switch temperatureUnit {
        case Setting.temperatureUnits.c:
            return "℃"
        case Setting.temperatureUnits.f:
            return "℉"
        case Setting.temperatureUnits.k:
            return "K"
        default:
            return ""
        }
    }
    
    /**
     Get pressure temperature unit symbol according to the setting
     */
    func getPressureUnitSymbol() -> String {
        switch pressureUnit {
        case Setting.pressureUnits.hPa:
            return "hPa"
        case Setting.pressureUnits.kPa:
            return "kPa"
        default:
            return ""
        }
    }
    
    /**
     Get current altitude unit symbol according to the setting
     */
    func getAltitudeUnitSymbol() -> String {
        switch altitudeUnit {
        case Setting.altitudeUnits.m:
            return "m"
        case Setting.altitudeUnits.feet:
            return "feet"
        default:
            return ""
        }
    }
    
}
