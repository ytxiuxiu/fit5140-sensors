/**
 * Website: Node.js MongoDB Driver API
 *    http://mongodb.github.io/node-mongodb-native/2.0/api/Collection.html#find
 */

const express = require('express');
const router = express.Router();

const db = require('../db');

router.get('/history/:sensor/:value/:skip/:limit', (req, res, next) => {
  const fields = { time: 1 };
  fields[req.params.value] = 1;
  const skip = parseInt(req.params.skip);
  const limit = parseInt(req.params.limit);

  db.get(req.params.sensor).find({}, { 
    fields,
    sort: { time: -1 },
    skip,
    limit
  })
  .then((docs) => {
    res.json(docs.reverse());
  })
  .catch((err) => {
    next(err);
  })
  .then(() => {
    db.close();
  });
});

module.exports = router;
