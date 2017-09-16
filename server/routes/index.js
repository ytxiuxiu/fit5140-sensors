/**
 * Website: Node.js MongoDB Driver API
 *    http://mongodb.github.io/node-mongodb-native/2.0/api/Collection.html#find
 */

const express = require('express');
const router = express.Router();

const db = require('../db');

router.get('/sensors/pressure/:n', (req, res, next) => {
  const n = parseInt(req.params.n);

  db.get('pressure').find({}, { 
    sort: { time: -1 },
    limit: n
  })
  .then((docs) => {
    res.json(docs);
  })
  .catch((err) => {
    next(err);
  })
  .then(() => {
    db.close();
  });
});

module.exports = router;
