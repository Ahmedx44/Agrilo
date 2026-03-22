require('dotenv').config();
const mongoose = require('mongoose');
const http = require('http');
const { Server } = require('socket.io');
const app = require('./app');
const socketService = require('./services/socket.service');

const PORT = process.env.PORT || 5000;
const MONGODB_URI = process.env.MONGODB_URI;

// Create HTTP server
const server = http.createServer(app);

// Initialize Socket.io
const io = new Server(server, {
  cors: {
    origin: '*', // Adjust for production
    methods: ['GET', 'POST']
  }
});

// Setup Socket.io logic
socketService.init(io);

// Connect to MongoDB
mongoose.connect(MONGODB_URI)
  .then(() => {
    console.info('Connected to MongoDB');
    // Start listening on the HTTP server (not the express app)
    server.listen(PORT, () => {
      console.info(`Server is running on port ${PORT}`);
    });
  })
  .catch((err) => {
    console.error('Failed to connect to MongoDB:', err.message);
    process.exit(1);
  });
