# fit5140-assignment-2
iOS APP with Raspberry PI and Sensors

## Run
1. Install Mosquitto MQTT Broker
  
    https://mosquitto.org/

2. Copy server folder to a Raspberry Pi
3. Install server dependencies in the server folder

    ```
    npm install
    ```
    
4. Run the server in the server folder

    ```
    sudo npm start
    ```
    
5. Install Pod dependencies in the iOS folder

    ```
    pod install
    ```
    
6. Open `raspberry-and-sensors.xcworkspace` in XCode
7. Run the APP
