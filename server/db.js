/**
 * StackOverflow: MongoDB on Raspbian - Raspberry Pi Stack Exchange
 *    https://raspberrypi.stackexchange.com/questions/29208/mongodb-on-raspbian
 * 
 * Website: MongoDB Node.js Driver
 *    https://mongodb.github.io/node-mongodb-native/
 * 
 * GitHub: Automattic/monk
 *    https://github.com/Automattic/monk
 *    https://automattic.github.io/monk/
 * 
 */

const config = require('./config');


const db = require('monk')(config.db.url);

db.then(() => {
  console.log('Connected to MongoDB');
}).catch((err) => {
  console.error('Cannot connect to MongoDB');
  process.exit(1);
});


module.exports = db;