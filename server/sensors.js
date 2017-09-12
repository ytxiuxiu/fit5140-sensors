const raspi = require('raspi-io');
const johnny = require('johnny-five');

const board = new johnny.Board({
  io: new raspi()
});

board.on('ready', function() {
  const multi = new johnny.Multi({
    controller: 'MPL3115A2',
    // Change `elevation` with whatever is reported
    // on http://www.whatismyelevation.com/.
    // `12` is the elevation (meters) for where I live in Brooklyn
    elevation: 59,
  });

  multi.on('change', function() {
    console.log("Thermometer");
    console.log("  celsius      : ", this.thermometer.celsius);
    console.log("--------------------------------------");

    console.log("Barometer");
    console.log("  pressure     : ", this.barometer.pressure);
    console.log("--------------------------------------");

    console.log("Altimeter");
    console.log("  meters       : ", this.altimeter.meters);
    console.log("--------------------------------------");
  });
});
