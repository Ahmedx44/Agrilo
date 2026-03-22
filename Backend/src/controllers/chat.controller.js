const ChatHistory = require('../models/chat_history.model');
const OpenAIService = require('../services/openai.service');

const sendMessage = async (req, res) => {
  try {
     const { message } = req.body;
     if (!message) {
        return res.status(400).json({ message: 'No message provided.' });
     }

     const userId = req.userId;
     let chatHistoryRecord = await ChatHistory.findOne({ userId });
     if (!chatHistoryRecord) {
        chatHistoryRecord = new ChatHistory({ userId, messages: [] });
     }

     // Limit to last 10 messages for context (to avoid massive tokens)
     const context = chatHistoryRecord.messages.slice(-10);

     // Call OpenAI
     const aiResponse = await OpenAIService.chat(userId, message, context);

     // Update chat history
     chatHistoryRecord.messages.push({ role: 'user', content: message });
     chatHistoryRecord.messages.push({ role: 'assistant', content: aiResponse });
     chatHistoryRecord.lastModifiedAt = Date.now();

     await chatHistoryRecord.save();
     res.json({
        message: 'Message sent successfully.',
        aiResponse,
        history: chatHistoryRecord.messages
     });
  } catch (error) {
     console.error('Chat controller error:', error);
     res.status(500).json({ message: 'Error sending message.' });
  }
};

const getChatHistory = async (req, res) => {
  try {
    const userId = req.userId;
    const history = await ChatHistory.findOne({ userId });
    res.json({ data: history ? history.messages : [] });
  } catch (error) {
    console.error('Chat history controller error:', error);
    res.status(500).json({ message: 'Error fetching chat history.' });
  }
};

module.exports = { sendMessage, getChatHistory };
