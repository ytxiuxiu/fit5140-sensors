const raspi = require('raspi-io');
const johnny = require('johnny-five');

const getSensors = (callback) => {
  const board = new johnny.Board({
    io: new raspi()
  });
  
  board.on('ready', () => {
    const pressure = new johnny.Multi({
      controller: 'MPL3115A2',
      // Change `elevation` with whatever is reported
      // on http://www.whatismyelevation.com/.
      elevation: 59,
    });
  
    callback(pressure);
  });
};

module.exports = {
  getSensors
}
