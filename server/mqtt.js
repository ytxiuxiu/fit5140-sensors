/**
 * GitHub: mqttjs/MQTT.js
 *    https://github.com/mqttjs/MQTT.js
 * 
 * Website: Installing MQTT Broker(Mosquitto) on Raspberry Pi
 *    http://www.instructables.com/id/Installing-MQTT-BrokerMosquitto-on-Raspberry-Pi/
 * 
 * Website: Mosquitto
 *    https://mosquitto.org/
 */

const mqtt = require('mqtt');

const config = require('./config');


const client = mqtt.connect(config.mqtt.url);

module.exports = client;
