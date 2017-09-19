//
//  UIViewControllerExtension.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 15/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
     Disable the back button
     */
    func disableBackButton() {
        
        // ✴️ Attributes:
        // StackOverflow: ios - How to disable back button in navigation bar - Stack Overflow
        //      https://stackoverflow.com/questions/32010429/how-to-disable-back-button-in-navigation-bar
        
        navigationController?.navigationBar.isUserInteractionEnabled = false
        navigationController?.navigationBar.tintColor = UIColor.lightGray
    }
    
    /**
     Enable the back button
     */
    func enableBackButton() {
        navigationController?.navigationBar.isUserInteractionEnabled = true
        navigationController?.navigationBar.tintColor = UIColor.blue
    }
    
}
