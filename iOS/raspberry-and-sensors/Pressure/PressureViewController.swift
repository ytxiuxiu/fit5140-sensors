//
//  PressureViewController.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 12/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit

class PressureViewController: UIViewController {

    @IBOutlet weak var pressureView: UIView!
    
    @IBOutlet weak var altitudeView: UIView!
    
    @IBOutlet weak var temperatureView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        drawDataRing(view: pressureView)
        drawDataRing(view: altitudeView)
        drawDataRing(view: temperatureView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawDataRing(view: UIView) {
        
        // Website: Drawing Shapes Using Bézier Paths
        //      https://developer.apple.com/library/content/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/BezierPaths/BezierPaths.html
        // StackOverflow: How to get the screen width and height in iOS?
        //      https://stackoverflow.com/questions/5677716/how-to-get-the-screen-width-and-height-in-ios
        
        let backgroundPath = UIBezierPath()
        let dataPath = UIBezierPath()
        let backgroundLayer = CAShapeLayer()
        let dataLayer = CAShapeLayer()
        
        backgroundLayer.fillColor = nil
        backgroundLayer.lineCap = kCALineCapRound
        backgroundLayer.strokeColor = UIColor(red: 235.0/255, green: 235.0/255, blue: 235.0/255, alpha: 1.0).cgColor
        backgroundLayer.lineWidth = UIScreen.main.bounds.size.width / 40.0
        
        dataLayer.fillColor = nil
        dataLayer.lineCap = kCALineCapRound
        dataLayer.strokeColor = UIColor(red: 80.0/255, green: 255.0/255, blue: 80.0/255, alpha: 1.0).cgColor
        dataLayer.lineWidth = UIScreen.main.bounds.size.width / 40.0
        
        let center = CGPoint(x: view.frame.width / 2.0, y: view.frame.height * 3.0 / 4.0)
        
        backgroundPath.addArc(withCenter: center, radius: view.frame.width / 4.0, startAngle: -CGFloat.pi * 13.0 / 12.0, endAngle: CGFloat.pi * 1.0 / 12.0, clockwise: true)
        dataPath.addArc(withCenter: center, radius: view.frame.width / 4.0, startAngle: -CGFloat.pi * 13.0 / 12.0, endAngle: -CGFloat.pi / 3.0, clockwise: true)
        
        backgroundLayer.path = backgroundPath.cgPath
        dataLayer.path = dataPath.cgPath
        
        view.layer.addSublayer(backgroundLayer)
        view.layer.addSublayer(dataLayer)
    }

}
