//
//  PressureAlarmSettingTableViewController.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 18/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit

class PressureAlarmSettingTableViewController: UITableViewController {
    
    @IBOutlet weak var pressureAlarmOnSwitch: UISwitch!
    
    @IBOutlet weak var lowerThanField: UITextField!
    
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
        alarm.pausePressureAlarm = true
    }
    
    func updateSetting() {
        pressureAlarmOnSwitch.setOn(setting.pressureAlarmOn, animated: false)
        
        // convert to the user setting unit
        lowerThanField.text = setting.pressureAlarmLowerThan?.toCurrentPressureUnit().simplify()
        
        lowerThanUnitLabel.text = setting.getPressureUnitSymbol()
        
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
        alarm.pressureLowerThanTriggered = false
        alarm.pausePressureAlarm = false
    }
    
    func updateEnabled() {
        if !pressureAlarmOnSwitch.isOn {
            lowerThanField.isEnabled = false
            
            enableBackButton()
            lowerThanField.hideError()
        } else {
            lowerThanField.isEnabled = true
            
            updateLowerThanError()
        }
    }
    
    @IBAction func pressureAlarmOnChanged(_ sender: Any) {
        setting.pressureAlarmOn = pressureAlarmOnSwitch.isOn
        
        updateEnabled()
    }
    
    @IBAction func lowerThanChanged(_ sender: Any) {
        setting.pressureAlarmLowerThan = Double(lowerThanField.text!)
        
        // always save as Kelvin
        if let lowerThan = setting.pressureAlarmLowerThan {
            if setting.pressureUnit == Setting.pressureUnits.hPa {
                setting.pressureAlarmLowerThan = lowerThan.hPaToKPa()
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
    
}
