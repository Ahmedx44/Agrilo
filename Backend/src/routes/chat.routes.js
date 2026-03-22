const express = require('express');
const { sendMessage, getChatHistory } = require('../controllers/chat.controller');
const authMiddleware = require('../middleware/auth.middleware');
const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Chat
 *   description: AI agriculture assistant
 */

/**
 * @swagger
 * /api/chat/send:
 *   post:
 *     summary: Send message to AI assistant
 *     tags: [Chat]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - message
 *             properties:
 *               message:
 *                 type: string
 *     responses:
 *       200:
 *         description: Message sent successfully
 */
router.post('/send', authMiddleware, sendMessage);

/**
 * @swagger
 * /api/chat/history:
 *   get:
 *     summary: Get user's chat history
 *     tags: [Chat]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Chat history messages
 */
router.get('/history', authMiddleware, getChatHistory);

module.exports = router;
