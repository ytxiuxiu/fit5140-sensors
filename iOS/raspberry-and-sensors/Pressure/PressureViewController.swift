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
    
    var pressureLayer: CAShapeLayer?
    
    var altitudeLayer: CAShapeLayer?
    
    var temperatureLayer: CAShapeLayer?
    
    let mqtt = MQTT.shared

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pressureMin = 10.0
        let pressureMax = 200.0
        let altitudeMin = 0.0
        let altitudeMax = 9000.0
        let temperatureMin = -50.0
        let temperatureMax = 50.0
        
        self.drawDataRing(dataLayer: &self.pressureLayer, view: self.pressureView, min: pressureMin, max: pressureMax, data: pressureMin)
        self.drawDataRing(dataLayer: &self.altitudeLayer, view: self.altitudeView, min: altitudeMin, max: altitudeMax, data: altitudeMin)
        self.drawDataRing(dataLayer: &self.temperatureLayer, view: self.temperatureView, min: temperatureMin, max: temperatureMax, data: 0)
        
        self.mqtt.addPressureMonitor(key: "pressureViewController", callback: { (pressure) in
            self.drawDataRing(dataLayer: &self.pressureLayer, view: self.pressureView, min: pressureMin, max: pressureMax, data: pressure.getPressurePa())
            self.pressureLabel.text = "\(self.doubleToString(number: pressure.getPressurePa()))Pa"
            
            self.drawDataRing(dataLayer: &self.altitudeLayer, view: self.altitudeView, min: altitudeMin, max: altitudeMax, data: pressure.getAltitudeMeters())
            self.altitudeLabel.text = "\(self.doubleToString(number: pressure.getAltitudeMeters()))m"
            
            self.drawDataRing(dataLayer: &self.temperatureLayer, view: self.temperatureView, min: temperatureMin, max: temperatureMax, data: pressure.getTemperatureCelsius())
            self.temperatureLabel.text = "\(self.doubleToString(number: pressure.getTemperatureCelsius()))℃"
            
            print(pressure)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.mqtt.removePressureMonitor(key: "pressureViewController")
    }
    
    func doubleToString(number: Double) -> String {
        return String(format: "%.1f", number)
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
