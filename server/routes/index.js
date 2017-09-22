/**
 * Website: Node.js MongoDB Driver API
 *    http://mongodb.github.io/node-mongodb-native/2.0/api/Collection.html#find
 */

const express = require('express');
const router = express.Router();

const db = require('../db');
const sensors = require('../sensors');

router.get('/history/:sensor/:value/:limit', (req, res, next) => {
  const fields = { time: 1 };
  req.params.value.split(',').map((value) => {
    fields[value] = 1;
  });
  const limit = parseInt(req.params.limit);

  if (req.params.sensor === 'colour') {
    const data = {};
    if (fields.hasOwnProperty('r')) {
      data.r = sensors.getLastRgb().r;
    }
    if (fields.hasOwnProperty('g')) {
      data.g = sensors.getLastRgb().g;
    }
    if (fields.hasOwnProperty('b')) {
      data.b = sensors.getLastRgb().b;
    }
    data.time = sensors.getLastRgb().time;

    res.json({
      senses: [data]
    });
  } else {
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
  }
});

module.exports = router;
