//
//  ColorViewController.swift
//  raspberry-and-sensors
//
//  Created by QIUXIAN CAI on 14/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit

class ColourViewController: UIViewController {
    
    @IBOutlet weak var colourView: UIView!
    
    @IBOutlet weak var rLabel: UILabel!
    
    @IBOutlet weak var gLabel: UILabel!
    
    @IBOutlet weak var bLabel: UILabel!
    
    @IBOutlet weak var cLabel: UILabel!
    
    @IBOutlet weak var mLabel: UILabel!
    
    @IBOutlet weak var yLabel: UILabel!
    
    @IBOutlet weak var kLabel: UILabel!
    
    @IBOutlet weak var hLabel: UILabel!
    
    @IBOutlet weak var sLabel: UILabel!
    
    @IBOutlet weak var lLabel: UILabel!
    
    @IBOutlet weak var hView: UIView!
    
    @IBOutlet weak var hIndicatorLeft: NSLayoutConstraint!
    
    @IBOutlet weak var sView: UIView!
    
    @IBOutlet weak var sIndicatorLeft: NSLayoutConstraint!
    
    @IBOutlet weak var lView: UIView!
    
    @IBOutlet weak var lIndicatorLeft: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    let mqtt = MQTT.shared
    
    let http = HTTP.shared
    
    var lastSense: ColourSense?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFirstData()
        
        mqtt.addColourMonitor(key: "colourViewController") { (sense) in
            DispatchQueue.main.async() {
                self.showColour(sense: sense)
                
                self.activityIndicator.isHidden = true
            }
        }
        
        super.viewWillAppear(animated)
    }
    
    func showColour(sense: ColourSense) {
        if let r = sense.r, let g = sense.g, let b = sense.b {
            self.colourView.backgroundColor = UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: 1.0)
            
            self.rLabel.text = "\(r.simplify(decimal: 0))"
            self.gLabel.text = "\(g.simplify(decimal: 0))"
            self.bLabel.text = "\(b.simplify(decimal: 0))"
            
            let (c, m, y, k) = self.rgbToCmyk(r: r, g: g, b: b)
            self.cLabel.text = "\(c.simplify(decimal: 3))"
            self.mLabel.text = "\(m.simplify(decimal: 3))"
            self.yLabel.text = "\(y.simplify(decimal: 3))"
            self.kLabel.text = "\(k.simplify(decimal: 3))"
            
            let (h, s, l) = self.rgbToHsl(r: r, g: g, b: b)
            self.hLabel.text = "\(h.simplify(decimal: 0))"
            self.sLabel.text = "\((s * 100).simplify(decimal: 0))%"
            self.lLabel.text = "\((l * 100).simplify(decimal: 0))%"
            
            self.hIndicatorLeft.constant = self.hView.frame.width * CGFloat(h) / 255 - 8
            self.sIndicatorLeft.constant = self.sView.frame.width * CGFloat(s) / 1 - 8
            self.lIndicatorLeft.constant = self.lView.frame.width * CGFloat(l) / 1 - 8
        }
    }

    /**
     Fetch current data or use last data if available
     */
    func fetchFirstData() {
        if let lastSense = lastSense {
            showColour(sense: lastSense)
            activityIndicator.isHidden = true
        } else {
            http.getHistory(sensor: ColourSense.sensor, value: "\(ColourSense.values.r),\(ColourSense.values.g),\(ColourSense.values.b)", limit: 1, callback: { (error, senses) in
                guard error == nil else {
                    print("Cannot get current data from the server \(error!)")
                    
                    self.alert(title: "Failed to get colour data", message: "\(error!)")
                    
                    return
                }
                
                if let sense = senses?[0] as? ColourSense {
                    self.lastSense = sense
                    
                    DispatchQueue.main.async() {
                        self.showColour(sense: sense)
                        self.activityIndicator.isHidden = true
                    }
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mqtt.removeColourMonitor(key: "colourViewController")
    }
    
    // Mark: - Color RGB-CMYK Convertor
    
    // ✴️ Attribute:
    // Website: RGB to CMYK color conversion
    //      http://www.rapidtables.com/convert/color/rgb-to-cmyk.htm
    
    /**
     Convert  RGB to CMYK
     
     - Parameters:
     - r: Red
     - g: Green
     - b: Blue
     - Returns:
     - c: Cyan
     - m: Magenta
     - y: Yellow
     - k: Black
     */
    func rgbToCmyk(r: Double, g: Double, b: Double) -> (c: Double, m: Double, y: Double, k: Double) {
        let _r = r / 255
        let _g = g / 255
        let _b = b / 255
        let k = 1 - max(_r, _g, _b)
        let c = (1 - _r - k) / (1 - k)
        let m = (1 - _g - k) / (1 - k)
        let y = (1 - _b - k) / (1 - k)
        
        return (c, m, y, k)
    }
    
    // Mark: - Color RGB-SHL Convertor
    
    // ✴️ Attribute:
    // Website: How to Convert RGB to HUE in Swift
    //      https://medium.com/simple-swift-programming-tips/how-to-convert-rgb-to-hue-in-swift-1d25338cad28
    
    /**
     Convert  RGB to CMYK
     
     - Parameters:
     - r: Red
     - g: Green
     - b: Blue
     - Returns:
     - s: saturation
     - h: hue
     - l: lightness
     
     */
    func rgbToHsl(r: Double, g: Double, b: Double) -> (h: Double, s: Double, l: Double){
        
        let _r = r / 255
        let _g = g / 255
        let _b = b / 255
        
        let minV = min(_r, _g, _b)
        let maxV = max(_r, _g, _b)
        var h = (minV + maxV) / 2
        var s = (minV + maxV) / 2
        let l = (minV + maxV) / 2
        
        if (maxV == minV) {
            h = 0
            s = 0
        } else {
            let delta = maxV - minV
            s = l > 0.5 ? delta/(2 - maxV - minV) : delta / (maxV + minV)
            switch maxV {
            case _r:
                h = (_g - _b) / delta + (g < b ? 6 : 0)
                break
            case _g:
                h = (_b - _r) / delta + 2
                break
            case _b:
                h = (_r - _g) / delta + 4
                break
            default:
                break
            }
            h /= 6
            
        }
        
        return (h * 360, s, l)
        
    }
    
}
