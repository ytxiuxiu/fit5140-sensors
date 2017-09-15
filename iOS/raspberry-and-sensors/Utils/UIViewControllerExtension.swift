//
//  UIViewControllerExtension.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 15/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func disableBackButton() {
        
        // StackOverflow: ios - How to disable back button in navigation bar - Stack Overflow
        //      https://stackoverflow.com/questions/32010429/how-to-disable-back-button-in-navigation-bar
        
        navigationController?.navigationBar.isUserInteractionEnabled = false
        navigationController?.navigationBar.tintColor = UIColor.lightGray
    }
    
    func enableBackButton() {
        navigationController?.navigationBar.isUserInteractionEnabled = true
        navigationController?.navigationBar.tintColor = UIColor.blue
    }
    
}