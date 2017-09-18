//
//  TemperatureAlarmSettingTableViewController.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 15/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit

class TemperatureAlarmSettingTableViewController: UITableViewController {
    
    @IBOutlet weak var temperatureAlarmOnSwitch: UISwitch!
    
    @IBOutlet weak var higherThanField: UITextField!
    
    @IBOutlet weak var lowerThanField: UITextField!
    
    @IBOutlet weak var higherThanUnitLabel: UILabel!
    
    @IBOutlet weak var lowerThanUnitLabel: UILabel!
    
    
    let setting = Setting.shared
    
    let alarm = Alarm.shared
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // pause the alarm
        alarm.pauseTemperatureAlarm = true
    }
    
    func updateSetting() {
        temperatureAlarmOnSwitch.setOn(setting.temperatureAlarmOn, animated: false)
        
        // convert to the user setting unit
        higherThanField.text = setting.temperatureAlarmHigherThan?.toCurrentTemperatureUnit().simplify()
        lowerThanField.text = setting.temperatureAlarmLowerThan?.toCurrentTemperatureUnit().simplify()
        
        higherThanUnitLabel.text = setting.getTemperatureUnitSymbol()
        lowerThanUnitLabel.text = setting.getTemperatureUnitSymbol()
        
        updateEnabled()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setting.save()
        
        // reset alarm
        alarm.temperatureHigherThanTriggered = false
        alarm.temperatureLowerThanTriggered = false
        alarm.pauseTemperatureAlarm = false
    }
    
    func updateEnabled() {
        if !temperatureAlarmOnSwitch.isOn {
            lowerThanField.isEnabled = false
            higherThanField.isEnabled = false
            
            enableBackButton()
            lowerThanField.hideError()
            higherThanField.hideError()
        } else {
            lowerThanField.isEnabled = true
            higherThanField.isEnabled = true
            
            updateLowerThanError()
            updateHigherThanError()
        }
    }
    
    @IBAction func temperatureAlarmOnChanged(_ sender: Any) {
        setting.temperatureAlarmOn = temperatureAlarmOnSwitch.isOn
        
        updateEnabled()
    }
    
    @IBAction func lowerThanChanged(_ sender: Any) {
        setting.temperatureAlarmLowerThan = Double(lowerThanField.text!)
        
        // always save as Kelvin
        if let lowerThan = setting.temperatureAlarmLowerThan {
            if setting.temperatureUnit == Setting.temperatureUnits.c {
                setting.temperatureAlarmLowerThan = lowerThan.celsiusToKelvin()
            } else if setting.temperatureUnit == Setting.temperatureUnits.f {
                setting.temperatureAlarmLowerThan = lowerThan.fahrenheitToKelvin()
            }
        }
        
        updateLowerThanError()
    }
    
    func updateLowerThanError() {
        if let lowerThan = lowerThanField.text {
            if lowerThan.isNumber {
                lowerThanField.hideError()
                
                enableBackButton()
            } else {
                lowerThanField.showError()
                disableBackButton()
            }
        }
    }
    
    @IBAction func higherThanChanged(_ sender: Any) {
        setting.temperatureAlarmHigherThan = Double(higherThanField.text!)
        
        // always save as Kelvin
        if let higherThan = setting.temperatureAlarmHigherThan {
            if setting.temperatureUnit == Setting.temperatureUnits.c {
                setting.temperatureAlarmHigherThan = higherThan.celsiusToKelvin()
            } else if setting.temperatureUnit == Setting.temperatureUnits.f {
                setting.temperatureAlarmHigherThan = higherThan.fahrenheitToKelvin()
            }
        }
        
        updateHigherThanError()
    }
    
    func updateHigherThanError() {
        if let higherThan = higherThanField.text {
            if higherThan.isNumber {
                higherThanField.hideError()
                
                enableBackButton()
            } else {
                higherThanField.showError()
                disableBackButton()
            }
        }
    }
    
}
