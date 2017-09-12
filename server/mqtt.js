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

const client = mqtt.connect('mqtt://localhost');

// client.on('connect', function() {
  // client.subscribe('presence');

  // setInterval(function() {
  //   client.publish('presence', 'Hello mqtt');
  // }, 2000);
  
// });

module.exports = client;

// client.on('message', function(topic, message) {
//   // message is Buffer
//   console.log(message.toString());
// });