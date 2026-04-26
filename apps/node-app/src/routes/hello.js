const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.json({ message: 'Hello World from Docker + GitHub Actions!' });
});

module.exports = router;