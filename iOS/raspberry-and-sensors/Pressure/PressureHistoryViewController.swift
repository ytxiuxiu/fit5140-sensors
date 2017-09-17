//
//  PressureHistoryViewController.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 16/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//
//
//  GitHub: danielgindi/Charts
//      https://github.com/danielgindi/Charts
//  Website: Creating a Line Chart in Swift 3 and iOS 10 – Osian Smith – Medium
//      https://medium.com/@OsianSmith/creating-a-line-chart-in-swift-3-and-ios-10-2f647c95392e

import UIKit
import Charts

class PressureHistoryViewController: UIViewController {

    @IBOutlet weak var chartView: LineChartView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var sliderLabel: UILabel!
    
    @IBOutlet weak var dataSegment: UISegmentedControl!
    
    let segmentSelectionToValue = ["barometer", "altimeter", "thermometer"]
    
    let segmentSelectionToLabel = ["Pressure", "Altitude", "Temperature"]
    
    let setting = Setting.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // StackOverflow: ios - iPhone : How to detect the end of slider drag? - Stack Overflow
        //      https://stackoverflow.com/questions/9390298/iphone-how-to-detect-the-end-of-slider-drag
        
        slider.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])

        chartView.chartDescription?.enabled = false
        chartView.noDataText = "No data"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateChart()
        
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateChart() {
        activityIndicator.isHidden = false
        chartView.isHidden = true
        
        let value = segmentSelectionToValue[dataSegment.selectedSegmentIndex]
        
        HTTP.shared.getHistory(sensor: "pressure", value: value, skip: 0, limit: Int(slider.value)) { (error, senses) in
            guard error == nil else {
                print("Failed to get pressure history \(error!)")
                return
            }
            
            let selected = self.dataSegment.selectedSegmentIndex
            var dataEntries = [ChartDataEntry]()
            
            for i in 0..<senses!.count {
                var y: Double?
                if selected == 0 {
                    y = (senses![i] as! PressureSense).barometer?.toCurrentPressureUnit()
                } else if selected == 1 {
                    y = (senses![i] as! PressureSense).altimeter?.toCurrentAltitudeUnit()
                } else if selected == 2 {
                    y = (senses![i] as! PressureSense).thermometer?.toCurrentTemperatureUnit()
                }
                
                if let y = y {
                    let dataEntry = ChartDataEntry(x: Double(i + 1), y: y)
                    dataEntries.append(dataEntry)
                }
            }
            
            let line = LineChartDataSet(values: dataEntries, label: "")
            
            var unit = ""
            if selected == 0 {
                unit = self.setting.getPressureUnitSymbol()
            } else if selected == 1 {
                unit = self.setting.getAltitudeUnitSymbol()
            } else if selected == 2 {
                unit = self.setting.getTemperatureUnitSymbol()
            }
            
            line.label = "\(self.segmentSelectionToLabel[selected]) (\(unit))"
            line.colors = [UIColor.blue]
            line.drawCirclesEnabled = false
            line.drawCircleHoleEnabled = false
            line.drawValuesEnabled = false
            
            let data = LineChartData()
            data.addDataSet(line)
            self.chartView.data = data
            
            // StackOverflow: xcode - Using threads to update UI with Swift - Stack Overflow
            //      https://stackoverflow.com/questions/27212254/using-threads-to-update-ui-with-swift
            
            DispatchQueue.main.async() {
                self.chartView.notifyDataSetChanged()
                self.activityIndicator.isHidden = true
                self.chartView.isHidden = false
            }
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        sliderLabel.text = String(Int(slider.value))
    }
    
    func sliderDidEndSliding() {
        updateChart()
    }
    
    @IBAction func dataSegmentChanged(_ sender: Any) {
        updateChart()
    }
    
    

}
