/**
 * Website: Node.js MongoDB Driver API
 *    http://mongodb.github.io/node-mongodb-native/2.0/api/Collection.html#find
 */

const express = require('express');
const router = express.Router();

const db = require('../db');

router.get('/history/:sensor/:value/:limit', (req, res, next) => {
  const fields = { time: 1 };
  req.params.value.split(',').map((value) => {
    fields[value] = 1;
  });
  const limit = parseInt(req.params.limit);

  db.get(req.params.sensor).find({}, { 
    fields,
    sort: { time: -1 },
    limit
  })
  .then((docs) => {
    res.json({
      senses: docs.reverse()
    });
  })
  .catch((err) => {
    next(err);
  });
});

module.exports = router;
