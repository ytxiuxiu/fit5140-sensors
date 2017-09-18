const raspi = require('raspi-io');
const johnny = require('johnny-five');
const i2c = require('i2c');

const meterInfo = {
  controller: 'MPL3115A2',
  // Change `elevation` with whatever is reported
  // on http://www.whatismyelevation.com/.
  elevation: 59,
  freq: 5000
};
const rgbInfo = {
  address: 0x29,
  version: 0x44,
  device: '/dev/i2c-1',
  freq: 500
};
const rgbCallbacks = [];
const lastRgb = {
  r: undefined,
  g: undefined,
  b: undefined
};

const getSensors = (callback) => {
  const board = new johnny.Board({
    io: new raspi()
  });
  
  board.on('ready', () => {
    const meterSensor = new johnny.Multi({
      controller: meterInfo.controller,
      elevation: meterInfo.elevation,
      freq: meterInfo.freq
    });

    const rgbSensor = new i2c(rgbInfo.address, {
      device: rgbInfo.device
    });

    checkRgbVersion(rgbSensor, (err) => {
      if (err) return callback(err);

      setupRgb(rgbSensor, (err) => {
        if (err) return callback(err);

        setInterval(() => {
          readRgb(rgbSensor, (err, res) => {
            // only call callback when the value has changed
            if (res.r !== lastRgb.r && res.g !== lastRgb.g && res.b !== lastRgb.b) {
              rgbCallbacks.map((callback) => {
                callback(err, res);
              });
            }

            lastRgb.r = res.r;
            lastRgb.g = res.g;
            lastRgb.b = res.b;
          });
        }, rgbInfo.freq);

        return callback(null, meterSensor, { on: onRgb });
      });
    });
  });
};

const checkRgbVersion = (rgb, callback) => {
  // get sensor version
  rgb.writeByte(0x80 | 0x12, (err) => {
    if (err) return callback(err);

    rgb.readByte((err, res) => {
      if (err) return callback(err);
      if (res !== rgbInfo.version) return callback(new Error('Version not match'));

      return callback();
    });
  });
};

const setupRgb = (rgb, callback) => {
  // enable register
  rgb.writeByte(0x80 | 0x00, (err) => {
    if (err) return callback(err);

    // power on and enable rgb sensor
    rgb.writeByte(0x01 | 0x02, (err) => {
      if (err) return callback(err);

      // read results from register 14 where data values are stored
      rgb.writeByte(0x80 | 0x14, (err) => {
        if (err) return callback(err);

        return callback();
      });
    })
  });
};

const readRgb = (rgb, callback) => {
  // read the information, output rgb as 16bit number
  rgb.read(9, (err, res) => {
    if (err) return callback(err);

    const r = res[3] << 8 | res[2];
    const g = res[5] << 8 | res[4];
    const b = res[7] << 8 | res[6];

    return callback(null, {
      r, g, b
    });
  });
};

const onRgb = (event, callabck) => {
  if (event === 'change') {
    rgbCallbacks.push(callabck);
  }
};

module.exports = {
  getSensors
};
