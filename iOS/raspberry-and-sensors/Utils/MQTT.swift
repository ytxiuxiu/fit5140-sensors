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

class MQTT: NSObject, CocoaMQTTDelegate {
    
    static let shared = MQTT()
    
    static let topicPressure = "pressure"
    
    var client: CocoaMQTT?
    
//    var colourMonitors = [String: (pressure: Colour) -> Void]()
    
    var pressureCallbacks = [String: (pressure: PressureSensor) -> Void]()
    

    override init() {
        super.init()
        
        print("MQTT init")
        
        let clientID = "MQTTClient-" + String(ProcessInfo().processIdentifier)
//        self.client = CocoaMQTT(clientID: clientID, host: "192.168.43.154", port: 1883)
        self.client = CocoaMQTT(clientID: clientID, host: "192.168.0.6", port: 1883)
        
        self.client?.keepAlive = 60
        self.client?.delegate = self
        self.client?.autoReconnect = true
        self.client?.connect()
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        self.client?.subscribe("pressure")
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
                
                if message.topic == MQTT.topicPressure {
                    let thermometer = info["thermometer"] as! Double
                    let barometer = info["barometer"] as! Double
                    let altimeter = info["altimeter"] as! Double
                    
                    let pressure = PressureSensor(thermometer: thermometer, barometer: barometer, altimeter: altimeter)
                    
                    print("get pressure")
                    
                    for (_, callback) in self.pressureCallbacks {
                        callback(pressure)
                    }
                }
                
            } catch let error as NSError {
                print("JSON Serialization error: \(error)")
            }
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic: \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("mqttDidDisconnect")
        if let error = err {
            print(error)
        }
    }
    
    //    func addColourMonitor(key: String, callback: @escaping (_ sensor: ColourSensor) -> Void) {
    //        self.colourMonitors[key] = callback;
    //    }
    //
    //    func removeColourMonitor(key: String) {
    //        self.colourMonitors.removeValue(forKey: key)
    //    }
    
    func addPressureMonitor(key: String, callback: @escaping (_ sensor: PressureSensor) -> Void) {
        self.pressureCallbacks[key] = callback;
    }
    
    func removePressureMonitor(key: String) {
        self.pressureCallbacks.removeValue(forKey: key)
    }

}
