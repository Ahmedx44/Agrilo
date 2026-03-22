const jwt = require('jsonwebtoken');
const ChatHistory = require('../models/chat_history.model');
const OpenAIService = require('./openai.service');

class SocketService {
  constructor() {
    this.io = null;
  }

  init(io) {
    this.io = io;

    // Middleware for Auth
    this.io.use((socket, next) => {
      const token = socket.handshake.auth.token;
      if (!token) return next(new Error('Authentication error'));

      try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        socket.userId = decoded.userId;
        next();
      } catch (err) {
        next(new Error('Authentication error'));
      }
    });

    this.io.on('connection', (socket) => {
      console.info(`User connected: ${socket.userId}`);

      // Join a personal room for private messaging
      socket.join(socket.userId);

      // Handle message events
      socket.on('send_message', async (data) => {
        try {
          const { message } = data;
          if (!message) return;

          const userId = socket.userId;

          // 1. Get or create chat history
          let chatHistoryRecord = await ChatHistory.findOne({ userId });
          if (!chatHistoryRecord) {
             chatHistoryRecord = new ChatHistory({ userId, messages: [] });
          }

          // 2. Limit context
          const context = chatHistoryRecord.messages.slice(-10);

          // 3. Immediately emit user message back (optional, but good for UX)
          // this.io.to(userId).emit('receive_message', { role: 'user', content: message, timestamp: new Date() });

          // 4. Call OpenAI
          const aiResponse = await OpenAIService.chat(userId, message, context);

          // 5. Update and save chat history
          chatHistoryRecord.messages.push({ role: 'user', content: message });
          chatHistoryRecord.messages.push({ role: 'assistant', content: aiResponse });
          chatHistoryRecord.lastModifiedAt = Date.now();
          await chatHistoryRecord.save();

          // 6. Emit AI response and updated history
          this.io.to(userId).emit('receive_message', {
            role: 'assistant',
            content: aiResponse,
            timestamp: new Date()
          });

        } catch (error) {
          console.error('Socket message error:', error);
          socket.emit('error', { message: 'Failed to process message' });
        }
      });

      socket.on('disconnect', () => {
        console.info(`User disconnected: ${socket.userId}`);
      });
    });
  }

  // Helper method to emit notifications globally or to a specific user
  sendNotification(userId, message) {
    if (this.io) {
      this.io.to(userId).emit('notification', { message });
    }
  }
}

module.exports = new SocketService();
