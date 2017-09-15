//
//  StringExtension.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 15/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit

extension String {
    
    var isNumber: Bool {
        get {
            // StackOverflow: swift - How to check is a string or number - Stack Overflow
            //      https://stackoverflow.com/questions/26545166/how-to-check-is-a-string-or-number
            
            return Double(self) != nil
        }
    }
    
}
