//
//  AltitudeAlarmSettingTableViewController.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 18/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit


/**
 Altitude Alarm Setting Table View Controller
 */
class AltitudeAlarmSettingTableViewController: UITableViewController {

    @IBOutlet weak var altitudeAlarmOnSwitch: UISwitch!
    
    @IBOutlet weak var higherThanField: UITextField!
    
    @IBOutlet weak var higherThanUnitLabel: UILabel!
    
    
    let setting = Setting.shared
    
    let alarm = Alarm.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // pause the alarm
        alarm.pauseAltitudeAlarm = true
    }
    
    /**
     Update UI from the setting
     */
    func updateSetting() {
        altitudeAlarmOnSwitch.setOn(setting.altitudeAlarmOn, animated: false)
        
        // convert to the user setting unit
        higherThanField.text = setting.altitudeAlarmHigherThan?.toCurrentAltitudeUnit().simplify()
        
        higherThanUnitLabel.text = setting.getAltitudeUnitSymbol()
        
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
        alarm.altitudeHigherThanTriggered = false
        alarm.pauseAltitudeAlarm = false
    }
    
    /**
     Update UI according to the alarm is enabled or not
     */
    func updateEnabled() {
        if !altitudeAlarmOnSwitch.isOn {
            higherThanField.isEnabled = false
            
            enableBackButton()
            higherThanField.hideError()
        } else {
            higherThanField.isEnabled = true
            
            updateHigherThanError()
        }
    }
    
    // Altitude alram on switch changed
    @IBAction func altitudeAlarmOnChanged(_ sender: Any) {
        setting.altitudeAlarmOn = altitudeAlarmOnSwitch.isOn
        
        updateEnabled()
    }

    // Higher than changed (each character)
    @IBAction func higherThanChanged(_ sender: Any) {
        setting.altitudeAlarmHigherThan = Double(higherThanField.text!)
        
        // always save as Kelvin
        if let higherThan = setting.altitudeAlarmHigherThan {
            if setting.altitudeUnit == Setting.altitudeUnits.feet {
                setting.altitudeAlarmHigherThan = higherThan.feetToMeters()
            }
        }
        
        updateHigherThanError()
    }
    
    /**
     Update higher than error
     */
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
