//
//  Alarm.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 17/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit
import UserNotifications
import Whisper

class Alarm: NSObject {
    
    static let shared = Alarm()
    
    let setting = Setting.shared
    
    var temperatureHigherThanTriggered = false
    
    var temperatureLowerThanTriggered = false
    
    var pauseTemperatureAlarm = false
    
    
    override init() {
        super.init()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
            guard granted else {
                return
            }
        
            self.monitorPressure()
        })
    }
    
    func monitorPressure() {
        MQTT.shared.addPressureMonitor(key: "alarm") { (sense) in
            self.monitorTemperature(sense: sense)
        }
    }
    
    func monitorTemperature(sense: PressureSense) {
        if self.setting.temperatureAlarmOn && !self.pauseTemperatureAlarm {
            
            // higher than
            if let temperatureAlarmHigherThan = self.setting.temperatureAlarmHigherThan {
                if sense.thermometer! >= temperatureAlarmHigherThan {
                    if !self.temperatureHigherThanTriggered {
                        let temperature = "\(sense.thermometer!.toCurrentTemperatureUnit())\(setting.getTemperatureUnitSymbol())"
                        let title = "Temperature too high! \(temperature)"
                        let message = "Temperature alarm triggered"
                        
                        notify(title: title, message: message)
                    }
                    self.temperatureHigherThanTriggered = true
                    
                } else if sense.thermometer! < temperatureAlarmHigherThan - 1 {
                    // discard the alarm
                    self.temperatureHigherThanTriggered = false
                }
            }
            
            // lower than
            if let temperatureAlarmLowerThan = self.setting.temperatureAlarmLowerThan {
                if sense.thermometer! <= temperatureAlarmLowerThan {
                    if !self.temperatureLowerThanTriggered {
                        let temperature = "\(sense.thermometer!.toCurrentTemperatureUnit())\(setting.getTemperatureUnitSymbol())"
                        let title = "Temperature too low! \(temperature)"
                        let message = "Temperature alarm triggered"
                        
                        notify(title: title, message: message)
                    }
                    self.temperatureLowerThanTriggered = true
                    
                } else if sense.thermometer! > temperatureAlarmLowerThan + 1 {
                    // discard the alarm
                    self.temperatureLowerThanTriggered = false
                }
            }
        }
    }
    
    func notify(title: String, message: String) {
        
        // ✴️ Attributes:
        // Website: Swift Tutorial : CoreLocation and Region Monitoring in iOS 8
        //      http://shrikar.com/swift-tutorial-corelocation-and-region-monitoring-in-ios-8/
        // StackOverflow: didEnterRegion, didExitRegion not being called
        //      https://stackoverflow.com/questions/37498438/didenterregion-didexitregion-not-being-called
        // Website: How to Make Local Notifications in iOS 10
        //      https://makeapppie.com/2016/08/08/how-to-make-local-notifications-in-ios-10/
        
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.sound = UNNotificationSound.default()
        content.body = message
        content.categoryIdentifier = "alarm"
        content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        
        let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
        // In-app notification
        // ✴️ Attribute:
        // GitHub: hyperoslo/Whisper
        //      https://github.com/hyperoslo/Whisper
        
        let murmur = Murmur(title: title)
        Whisper.show(whistle: murmur, action: .show(5))

    }

}
