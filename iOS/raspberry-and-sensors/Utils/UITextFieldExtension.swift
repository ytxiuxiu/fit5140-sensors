//
//  UITextFieldExtension.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 15/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit

extension UITextField {
    
    func showError() {
        
        // StackOverflow: ios - How set swift 3 UITextField border color ? - Stack Overflow
        //      https://stackoverflow.com/questions/38460327/how-set-swift-3-uitextfield-border-color
        
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.cornerRadius = 3.0
        self.layer.borderWidth = 1.0
    }
    
    func hideError() {
        self.layer.borderWidth = 0.0
    }
    
}
