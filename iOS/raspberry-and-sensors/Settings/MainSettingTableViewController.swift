//
//  MainSettingTableViewController.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 14/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit


/**
 Main Setting Table View Controller
 */
class MainSettingTableViewController: UITableViewController {
    
    @IBOutlet weak var temperatureUnitSegment: UISegmentedControl!
    
    @IBOutlet weak var pressureUnitSegment: UISegmentedControl!
    
    @IBOutlet weak var altitudeUnitSegment: UISegmentedControl!
    
    
    let temperatureUnitToSegmentSelection = [Setting.temperatureUnits.c: 0, Setting.temperatureUnits.f: 1, Setting.temperatureUnits.k: 2]
    
    let temperatureSegmentSelectionToUnit = [Setting.temperatureUnits.c, Setting.temperatureUnits.f, Setting.temperatureUnits.k]
    
    let pressureUnitToSegmentSelection = [Setting.pressureUnits.hPa: 0, Setting.pressureUnits.kPa: 1]
    
    let pressureSegmentSelectionToUnit = [Setting.pressureUnits.hPa, Setting.pressureUnits.kPa]
    
    let altitudeUnitToSegmentSelection = [Setting.altitudeUnits.m: 0, Setting.altitudeUnits.feet: 1]
    
    let altitudeSegmentSelectionToUnit = [Setting.altitudeUnits.m, Setting.altitudeUnits.feet]
    
    
    let setting = Setting.shared
    

    override func viewDidLoad() {
        super.viewDidLoad()

        updateSetting()
        
        temperatureUnitSegment.addTarget(self, action: #selector(temperatureUnitChanged), for: .valueChanged)
        pressureUnitSegment.addTarget(self, action: #selector(pressureUnitChanged), for: .valueChanged)
        altitudeUnitSegment.addTarget(self, action: #selector(altitudeUnitChanged), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateSetting()
    }
    
    
    /**
     Update segment from settings
     */
    func updateSetting() {
        temperatureUnitSegment.selectedSegmentIndex = temperatureUnitToSegmentSelection[setting.temperatureUnit]!
        pressureUnitSegment.selectedSegmentIndex = pressureUnitToSegmentSelection[setting.pressureUnit]!
        altitudeUnitSegment.selectedSegmentIndex = altitudeUnitToSegmentSelection[setting.altitudeUnit]!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setting.save()
    }
    
    // Temperature unit changed, it should change the setting
    @IBAction func temperatureUnitChanged(_ sender: Any) {
        
        // ✴️ Attributes:
        // StackOverflow: ios - Array from dictionary keys in swift - Stack Overflow
        //      https://stackoverflow.com/questions/26386093/array-from-dictionary-keys-in-swift
        
        let selected = temperatureUnitSegment.selectedSegmentIndex
        setting.temperatureUnit = temperatureSegmentSelectionToUnit[selected]
    }
    
    // Pressure unit changed, it should change the setting
    @IBAction func pressureUnitChanged(_ sender: Any) {
        let selected = pressureUnitSegment.selectedSegmentIndex
        setting.pressureUnit = pressureSegmentSelectionToUnit[selected]
    }
    
    // Altitude unit changed, it should change the setting
    @IBAction func altitudeUnitChanged(_ sender: Any) {
        let selected = altitudeUnitSegment.selectedSegmentIndex
        setting.altitudeUnit = altitudeSegmentSelectionToUnit[selected]
    }

}
