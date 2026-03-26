require('dotenv').config();
const mongoose = require('mongoose');
const app = require('./app');

const PORT = process.env.PORT || 5000;
const MONGODB_URI = process.env.MONGODB_URI;

const os = require('os');

// Connect to MongoDB
mongoose.connect(MONGODB_URI)
  .then(() => {
    console.info('Connected to MongoDB');
    // Start listening
    app.listen(PORT, '0.0.0.0', () => {
      console.info(`\n Server is running on port ${PORT}\n`);

      console.info('Access the API on your network at the following addresses:');
      console.info(`- Localhost: http://localhost:${PORT}`);

      const nets = os.networkInterfaces();
      for (const name of Object.keys(nets)) {
        for (const net of nets[name]) {
          if (net.family === 'IPv4' && !net.internal) {
            console.info(`- Network:   http://${net.address}:${PORT}`);
          }
        }
      }
      console.info('\n');
    });
  })
  .catch((err) => {
    console.error('Failed to connect to MongoDB:', err.message);
    process.exit(1);
  });
