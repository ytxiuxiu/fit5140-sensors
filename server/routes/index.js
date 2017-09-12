var express = require('express');
var router = express.Router();

router.get('/', (req, res, next) => {
  console.log(req.headers['x-forwarded-for'] || req.connection.remoteAddress)
});

module.exports = router;
