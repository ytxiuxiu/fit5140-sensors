//
//  ColorViewController.swift
//  raspberry-and-sensors
//
//  Created by QIUXIAN CAI on 14/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(rgbToHsl(r: 233,g: 222,b: 111))
        print(rgbToCmyk(r: 233,g: 222,b: 111))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Website: RGB to CMYK color conversion
    //      http://www.rapidtables.com/convert/color/rgb-to-cmyk.htm
    
    func rgbToCmyk(r: Double, g: Double, b: Double) -> (c:Double, m: Double, y: Double, k: Double){
        let _r = r/255
        let _g = g/255
        let _b = b/255
        let k = 1 - max(_r, _g, _b)
        let c = (1-_r-k)/(1-k)
        let m = (1-_g-k)/(1-k)
        let y = (1-_b-k)/(1-k)
        return (c,m,y,k)
    }
    
    
    func rgbToHsl(r: Double, g: Double, b: Double) -> (h:Double, s:Double, l: Double){
        
        let _r = r/255
        let _g = g/255
        let _b = b/255
        
        let minV = min(_r,_g,_b)
        let maxV = max(_r,_g,_b)
        var h = (minV + maxV)/2
        var s = (minV + maxV)/2
        var l = (minV + maxV)/2
        
        if (maxV == minV) {
            h = 0
            s = 0
        }else {
            let delta = maxV - minV
            s = l > 0.5 ? delta/(2 - maxV - minV) : delta / (maxV + minV)
            switch maxV {
            case _r: h = (_g - _b) / delta + (g < b ? 6 : 0); break
            case _g: h = (_b - _r) / delta + 2; break
            case _b: h = (_r - _g) / delta + 4; break
            default: break
            }
            h /= 6
            
        }
        
        
        return (h * 360,s,l)
        
        
    }

}
