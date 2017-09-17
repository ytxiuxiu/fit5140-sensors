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
  res.json({
    message: err.message,
    error: req.app.get('env') === 'development' ? err : {}
  })
});

// only keep data for 24 hours
//
// Website: Expire Data from Collections by Setting TTL
//    https://docs.mongodb.com/manual/tutorial/expire-data/
db.get('pressure').createIndex({ time: 1 }, { expireAfterSeconds: 3600 * 24 });

// mqtt & sensors
mqtt.on('connect', () => {

  sensors.getSensors((pressure) => {

    pressure.on('change', () => {
      const data = {
        thermometer: pressure.thermometer.kelvin,
        barometer: pressure.barometer.pressure,
        altimeter: pressure.altimeter.meters,
        time: new Date()
      };

      db.get('pressure').insert(data)
        .catch((err) => {
          console.error('Failed to insert sensor data into MongoDB', err);
        })
        .then(() => {
          db.close();
        });
      mqtt.publish('pressure', JSON.stringify(data));
    });
  });
});

module.exports = app;
