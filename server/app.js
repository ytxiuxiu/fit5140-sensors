const express = require('express');
const logger = require('morgan');
const cookieParser = require('cookie-parser');
const bodyParser = require('body-parser');

const mqtt = require('./mqtt');
const db = require('./db');
const sensors = require('./sensors');
const index = require('./routes/index');


const app = express();

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.set('view engine', 'html');

app.use('/', index);

// catch 404 and forward to error handler
app.use((req, res, next) => {
  const err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handler
app.use((err, req, res, next) => {
  res.status(err.status || 500);

  console.error(err);

  res.json({
    message: err.message,
    error: req.app.get('env') === 'development' ? err : {}
  })
});

// only keep data for 24 hours
//
// Website: Expire Data from Collections by Setting TTL
//    https://docs.mongodb.com/manual/tutorial/expire-data/
db.get('meters').createIndex({ time: 1 }, { expireAfterSeconds: 3600 * 24 });

// mqtt & sensors
mqtt.on('connect', () => {

  sensors.getSensors((err, meters, rgb) => {
    if (err) {
      console.error('Failed to initialize sensors', err);
      return;
    }

    meters.on('change', () => {
      const data = {
        thermometer: meters.thermometer.kelvin,
        barometer: meters.barometer.pressure,
        altimeter: meters.altimeter.meters,
        time: new Date()
      };

      db.get('meters').insert(data)
        .catch((err) => {
          console.error('Failed to insert sensor data into MongoDB', err);
        });
      mqtt.publish('meters', JSON.stringify(data));
    });

    rgb.on('change', (err, res) => {
      const data = {
        r: res.r,
        g: res.g,
        b: res.b
      };

      mqtt.publish('colour', JSON.stringify(data));
    });
  });
});

module.exports = app;
