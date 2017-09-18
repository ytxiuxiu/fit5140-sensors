//
//  PressureViewController.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 12/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit
import CocoaMQTT

class PressureViewController: UIViewController {

    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var pressureView: UIView!
    
    @IBOutlet weak var altitudeLabel: UILabel!
    
    @IBOutlet weak var altitudeView: UIView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var temperatureView: UIView!
    
    @IBOutlet weak var meterView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var pressureLayer: CAShapeLayer?
    
    var altitudeLayer: CAShapeLayer?
    
    var temperatureLayer: CAShapeLayer?
    
    let mqtt = MQTT.shared
    
    let http = HTTP.shared
    
    let setting = Setting.shared

    var pressureMin = 30.0
    
    var pressureMax = 120.0
    
    var altitudeMin = 0.0
    
    var altitudeMax = 9000.0
    
    var temperatureMin = 223.15
    
    var temperatureMax = 323.15
    
    var lastPressure: Double?
    
    var lastAltitude: Double?
    
    var lastTemperature: Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        meterView.isHidden = true
        activityIndicator.isHidden = false
        
        let pressureMinDefault = 30.0
        let pressureMaxDefault = 120.0
        let altitudeMinDefault = 0.0
        let altitudeMaxDefault = 9000.0
        let temperatureMinDefault = 223.15
        let temperatureMaxDefault = 323.15
        
        // convet
        pressureMin = pressureMinDefault.toCurrentPressureUnit()
        pressureMax = pressureMaxDefault.toCurrentPressureUnit()

        altitudeMin = altitudeMinDefault.toCurrentAltitudeUnit()
        altitudeMax = altitudeMaxDefault.toCurrentAltitudeUnit()

        temperatureMin = temperatureMinDefault.toCurrentTemperatureUnit()
        temperatureMax = temperatureMaxDefault.toCurrentTemperatureUnit()
        
        // draw init
        self.drawDataRing(dataLayer: &self.pressureLayer, view: self.pressureView, min: pressureMin, max: pressureMax, data: pressureMin)
        self.drawDataRing(dataLayer: &self.altitudeLayer, view: self.altitudeView, min: altitudeMin, max: altitudeMax, data: altitudeMin)
        self.drawDataRing(dataLayer: &self.temperatureLayer, view: self.temperatureView, min: temperatureMin, max: temperatureMax, data: temperatureMin)
        
        // fetch current data or use last data if available
        if let lastPressure = lastPressure {
            let pressureData = self.processPressureData(pressure: lastPressure)
            self.showPressure(data: pressureData)
            
            meterView.isHidden = false
            activityIndicator.isHidden = true
        } else {
            http.getHistory(sensor: MeterSense.sensor, value: "\(MeterSense.values.thermometer),\(MeterSense.values.barometer),\(MeterSense.values.altimeter)", limit: 1, callback: { (error, senses) in
                guard error == nil else {
                    print("Cannot get current data from the server \(error!)")
                    return
                }
                
                if let sense = senses?[0] as? MeterSense {
                    if let pressure = sense.barometer {
                        let pressureData = self.processPressureData(pressure: pressure)
                        self.showPressure(data: pressureData)
                    }
                    
                    if let altitude = sense.altimeter {
                        let altitudeData = self.processAltitudeData(altitude: altitude)
                        self.showAltitude(data: altitudeData)
                    }
                    
                    if let temperature = sense.thermometer {
                        let temperatureData = self.processTemperatureData(temperature: temperature)
                        self.showTemperature(data: temperatureData)
                    }
                }
                
                DispatchQueue.main.async() {
                    self.meterView.isHidden = false
                    self.activityIndicator.isHidden = true
                }
            })
        }
        if let lastAltitude = lastAltitude {
            let altitudeData = self.processAltitudeData(altitude: lastAltitude)
            self.showAltitude(data: altitudeData)
        }
        if let lastTemperature = lastTemperature {
            let temperatureData = self.processTemperatureData(temperature: lastTemperature)
            self.showTemperature(data: temperatureData)
        }
        
        // listen to sensor changes
        listenToSensors()

        super.viewWillAppear(animated)
    }
    
    func listenToSensors() {
        self.mqtt.addPressureMonitor(key: "pressureViewController", callback: { (sensor) in
            if let pressure = sensor.barometer {
                let pressureData = self.processPressureData(pressure: pressure)
                self.showPressure(data: pressureData)
            }
            
            if let altitude = sensor.altimeter {
                let altitudeData = self.processAltitudeData(altitude: altitude)
                self.showAltitude(data: altitudeData)
            }
            
            if let temperature = sensor.thermometer {
                let temperatureData = self.processTemperatureData(temperature: temperature)
                self.showTemperature(data: temperatureData)
            }
            
            DispatchQueue.main.async() {
                self.meterView.isHidden = false
                self.activityIndicator.isHidden = true
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.mqtt.removePressureMonitor(key: "pressureViewController")
        pressureLabel.text = "-.-"
        altitudeLabel.text = "-.-"
        temperatureLabel.text = "-.-"
    }
    
    func processPressureData(pressure: Double) -> Double {
        self.lastPressure = pressure
        var pressureData = pressure.toCurrentPressureUnit()
        
        // make sure they are not execeeds the range
        pressureData = pressureData <= self.pressureMax ? pressureData : self.pressureMax
        pressureData = pressureData >= self.pressureMin ? pressureData : self.pressureMin

        return pressureData
    }
    
    func showPressure(data: Double) {
        DispatchQueue.main.async() {
            self.drawDataRing(dataLayer: &self.pressureLayer, view: self.pressureView, min: self.pressureMin, max: self.pressureMax, data: data)
            self.pressureLabel.text = "\(data.simplify())\(self.setting.getPressureUnitSymbol())"
        }
    }
    
    func processAltitudeData(altitude: Double) -> Double {
        self.lastAltitude = altitude
        var altitudeData = altitude.toCurrentAltitudeUnit()
        
        altitudeData = altitudeData <= self.altitudeMax ? altitudeData : self.altitudeMax
        altitudeData = altitudeData >= self.altitudeMin ? altitudeData : self.altitudeMin
        
        return altitudeData
    }
    
    func showAltitude(data: Double) {
        DispatchQueue.main.async() {
            self.drawDataRing(dataLayer: &self.altitudeLayer, view: self.altitudeView, min: self.altitudeMin, max: self.altitudeMax, data: data)
            self.altitudeLabel.text = "\(data.simplify())\(self.setting.getAltitudeUnitSymbol())"
        }
    }
    
    func processTemperatureData(temperature: Double) -> Double {
        self.lastTemperature = temperature
        var temperatureData = temperature.toCurrentTemperatureUnit()
        
        temperatureData = temperatureData <= self.temperatureMax ? temperatureData : self.temperatureMax
        temperatureData = temperatureData >= self.temperatureMin ? temperatureData : self.temperatureMin

        return temperatureData
    }
    
    func showTemperature(data: Double) {
        DispatchQueue.main.async() {
            self.drawDataRing(dataLayer: &self.temperatureLayer, view: self.temperatureView, min: self.temperatureMin, max: self.temperatureMax, data: data)
            self.temperatureLabel.text = "\(data.simplify())\(self.setting.getTemperatureUnitSymbol())"
        }
    }
    
    func drawDataRing(dataLayer: inout CAShapeLayer?, view: UIView, min: Double, max: Double, data: Double) {
        
        // ✴️ Attributes:
        // Website: Drawing Shapes Using Bézier Paths
        //      https://developer.apple.com/library/content/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/BezierPaths/BezierPaths.html
        // StackOverflow: How to get the screen width and height in iOS?
        //      https://stackoverflow.com/questions/5677716/how-to-get-the-screen-width-and-height-in-ios
        
        let lineWidth = UIScreen.main.bounds.size.width / 40.0
        let startAngle = -CGFloat.pi * 13.0 / 12.0
        let backgroundEndAngle = CGFloat.pi * 1.0 / 12.0
        let dataEndAngle = CGFloat((data - min) / (max - min)) * (backgroundEndAngle - startAngle) + startAngle
        let center = CGPoint(x: view.frame.width / 2.0, y: view.frame.height * 3.0 / 4.0)
        
        if dataLayer == nil {
            // draw background
            let backgroundPath = UIBezierPath()
            backgroundPath.addArc(withCenter: center, radius: view.frame.width / 4.0, startAngle: startAngle, endAngle: backgroundEndAngle, clockwise: true)
            
            let backgroundLayer = CAShapeLayer()
            backgroundLayer.fillColor = nil
            backgroundLayer.lineCap = kCALineCapRound
            backgroundLayer.strokeColor = UIColor(red: 235.0/255, green: 235.0/255, blue: 235.0/255, alpha: 1.0).cgColor
            backgroundLayer.lineWidth = lineWidth
            backgroundLayer.path = backgroundPath.cgPath
            
            view.layer.addSublayer(backgroundLayer)
        } else {
            dataLayer?.removeFromSuperlayer()
        }
        
        let dataPath = UIBezierPath()
        dataPath.addArc(withCenter: center, radius: view.frame.width / 4.0, startAngle: startAngle, endAngle: dataEndAngle, clockwise: true)
        
        dataLayer = CAShapeLayer()
        dataLayer?.fillColor = nil
        dataLayer?.lineCap = kCALineCapRound
        dataLayer?.strokeColor = UIColor(red: 38.0/255, green: 166.0/255, blue: 91.0/255, alpha: 1.0).cgColor
        dataLayer?.lineWidth = lineWidth
        
        dataLayer?.path = dataPath.cgPath
        dataPath.addArc(withCenter: center, radius: view.frame.width / 4.0, startAngle: startAngle, endAngle: dataEndAngle, clockwise: true)
        view.layer.addSublayer(dataLayer!)
    }

}
