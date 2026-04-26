const app = require('./src/app');
const config = require('./config/default');

app.listen(config.port, () => {
  console.log(`Node app is running on port ${config.port} in ${config.env} mode`);
});