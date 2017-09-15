//
//  MainSettingTableViewController.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 14/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit

class MainSettingTableViewController: UITableViewController {
    
    @IBOutlet weak var temperatureUnitSegment: UISegmentedControl!
    
    @IBOutlet weak var pressureUnitSegment: UISegmentedControl!
    
    @IBOutlet weak var altitudeUnitSegment: UISegmentedControl!
    
    
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
    
    func updateSetting() {
        if setting.temperatureUnit == Setting.temperatureUnits.c {
            temperatureUnitSegment.selectedSegmentIndex = 0
        } else if setting.temperatureUnit == Setting.temperatureUnits.f {
            temperatureUnitSegment.selectedSegmentIndex = 1
        } else if setting.temperatureUnit == Setting.temperatureUnits.k {
            temperatureUnitSegment.selectedSegmentIndex = 2
        }
        
        if setting.pressureUnit == Setting.pressureUnits.hPa {
            pressureUnitSegment.selectedSegmentIndex = 0
        } else if setting.pressureUnit == Setting.pressureUnits.kPa {
            pressureUnitSegment.selectedSegmentIndex = 1
        }
        
        if setting.altitudeUnit == Setting.altitudeUnits.m {
            altitudeUnitSegment.selectedSegmentIndex = 0
        } else if setting.altitudeUnit == Setting.altitudeUnits.feet {
            altitudeUnitSegment.selectedSegmentIndex = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setting.save()
    }
    
    @IBAction func temperatureUnitChanged(_ sender: Any) {
        let selected = temperatureUnitSegment.selectedSegmentIndex
        if selected == 0 {
            setting.temperatureUnit = Setting.temperatureUnits.c
        } else if selected == 1 {
            setting.temperatureUnit = Setting.temperatureUnits.f
        } else if selected == 2 {
            setting.temperatureUnit = Setting.temperatureUnits.k
        }
    }
    
    @IBAction func pressureUnitChanged(_ sender: Any) {
        let selected = pressureUnitSegment.selectedSegmentIndex
        if selected == 0 {
            setting.pressureUnit = Setting.pressureUnits.hPa
        } else if selected == 1 {
            setting.pressureUnit = Setting.pressureUnits.kPa
        }
    }
    
    @IBAction func altitudeUnitChanged(_ sender: Any) {
        let selected = altitudeUnitSegment.selectedSegmentIndex
        if selected == 0 {
            setting.altitudeUnit = Setting.altitudeUnits.m
        } else if selected == 1 {
            setting.altitudeUnit = Setting.altitudeUnits.feet
        }
    }

}
