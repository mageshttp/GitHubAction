const express = require('express');
const config = require('../config/default');
const helloRoutes = require('./routes/hello');
const apiRoutes = require('./routes/api');
const statusRoutes = require('./routes/status');

const app = express();

app.use(express.json());

// Routes
app.use('/', helloRoutes);
app.use('/api', apiRoutes);
app.use('/status', statusRoutes);

// Health check
app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

module.exports = app;