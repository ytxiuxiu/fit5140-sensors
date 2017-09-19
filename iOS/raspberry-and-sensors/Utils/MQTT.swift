//
//  MQTT.swift
//  raspberry-and-sensors
//
//  Created by YINGCHEN LIU on 12/9/17.
//  Copyright © 2017 YINGCHEN LIU. All rights reserved.
//
//  GitHub: emqtt/CocoaMQTT
//      https://github.com/emqtt/CocoaMQTT


import UIKit
import CocoaMQTT


/**
 MQTT
 */
class MQTT: NSObject, CocoaMQTTDelegate {
    
    static let shared = MQTT()
    
    static let topicMeters = "meters"
    
    static let topicColour = "colour"
    
    var client: CocoaMQTT?
    
    var colourCallbacks = [String: (sense: ColourSense) -> Void]()
    
    var meterCallbacks = [String: (sense: MeterSense) -> Void]()
    

    override init() {
        super.init()
        
        connect()
    }
    
    func connect() {
        let clientID = "MQTTClient-" + String(ProcessInfo().processIdentifier)
        //        self.client = CocoaMQTT(clientID: clientID, host: "192.168.43.154", port: 1883)
        self.client = CocoaMQTT(clientID: clientID, host: "192.168.0.6", port: 1883)
        
        self.client?.keepAlive = 60
        self.client?.delegate = self
        self.client?.autoReconnect = true
        self.client?.connect()
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        self.client?.subscribe(MQTT.topicMeters)
        self.client?.subscribe(MQTT.topicColour)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        
        // Creating NSData from NSString in Swift
        //      https://stackoverflow.com/questions/24039868/creating-nsdata-from-nsstring-in-swift
        
        if let data = message.string?.data(using: .utf8) {
            do {
                let info = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                if message.topic == MQTT.topicMeters {
                    let thermometer = info[MeterSense.values.thermometer] as! Double
                    let barometer = info[MeterSense.values.barometer] as! Double
                    let altimeter = info[MeterSense.values.altimeter] as! Double
                    
                    let meter = MeterSense(thermometer: thermometer, barometer: barometer, altimeter: altimeter)

                    for (_, callback) in self.meterCallbacks {
                        callback(meter)
                    }
                } else if message.topic == MQTT.topicColour {
                    // 65535 to 255
                    let r = (info[ColourSense.values.r] as! Double) / 257
                    let g = (info[ColourSense.values.g] as! Double) / 257
                    let b = (info[ColourSense.values.b] as! Double) / 257
                    
                    let colour = ColourSense(r: r, g: g, b: b)
                    
                    for (_, callback) in self.colourCallbacks {
                        callback(colour)
                    }
                }
                
            } catch let error as NSError {
                print("JSON Serialization error: \(error)")
            }
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("subscribed topic: \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("mqtt disconnected")
        
        if let error = err {
            print(error)
        }
        
        // try to reconnect
        connect()
    }
    
    /**
     Add a colour monotor
 
     - Parameters:
        - key: Key for the monitor
        - callback: The callback function being called when the data has changed
     */
    func addColourMonitor(key: String, callback: @escaping (_ sense: ColourSense) -> Void) {
        self.colourCallbacks[key] = callback;
    }

    /**
     Remove a colour monitor
    
     - Parameters:
        - key: Key for the monitor
     */
    func removeColourMonitor(key: String) {
        self.colourCallbacks.removeValue(forKey: key)
    }
    
    /**
     Add a meter monotor
     
     - Parameters:
        - key: Key for the monitor
        - callback: The callback function being called when the data has changed
     */
    func addMeterMonitor(key: String, callback: @escaping (_ sense: MeterSense) -> Void) {
        self.meterCallbacks[key] = callback;
    }
    
    /**
     Remove a meter monitor
     
     - Parameters:
        - key: Key for the monitor
     */
    func removeMeterMonitor(key: String) {
        self.meterCallbacks.removeValue(forKey: key)
    }

}
