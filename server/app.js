const express = require('express');
const logger = require('morgan');
const cookieParser = require('cookie-parser');
const bodyParser = require('body-parser');

const mqtt = require('./mqtt');
const sensors = require('./sensors');
const index = require('./routes/index');


const app = express();

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());

app.use('/', index);

// catch 404 and forward to error handler
app.use((req, res, next) => {
  const err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handler
app.use((err, req, res, next) => {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

// mqtt & sensors
mqtt.on('connect', () => {

  sensors.getSensors((pressure) => {

    pressure.on('change', () => {
      const data = {
        thermometer: pressure.thermometer.kelvin,
        barometer: pressure.barometer.pressure,
        altimeter: pressure.altimeter.meters
      };
      mqtt.publish('pressure', JSON.stringify(data));
    });
  });
});

module.exports = app;
