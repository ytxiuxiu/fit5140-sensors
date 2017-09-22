//
//  ColourSense.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 18/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit


/**
 One sense of colour
 */
class ColourSense: NSObject {
    
    static let sensor = "colour"

    static let values = (r: "r", g: "g", b: "b")
    
    var r: Double?
    
    var g: Double?
    
    var b: Double?

    
    override init() {
        
    }
    
    init(r: Double, g: Double, b: Double) {
        self.r = r
        self.g = g
        self.b = b
    }
    
    override var description: String {
        return "ColourSense [r=\(self.r?.simplify() ?? ""), g=\(self.g?.simplify() ?? ""), b=\(self.b?.simplify() ?? "")]"
    }
    
}
