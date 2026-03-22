const express = require('express');
const { analyzeSoil, getHistory } = require('../controllers/soil.controller');
const authMiddleware = require('../middleware/auth.middleware');
const uploadMiddleware = require('../middleware/upload.middleware');
const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Soil
 *   description: Soil analysis and monitoring
 */

/**
 * @swagger
 * /api/soil/analyze:
 *   post:
 *     summary: Analyze soil from image and/or text
 *     tags: [Soil]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               image:
 *                 type: string
 *                 format: binary
 *               textInput:
 *                 type: string
 *     responses:
 *       200:
 *         description: Soil analysis successful
 */
router.post('/analyze', authMiddleware, uploadMiddleware.single('image'), analyzeSoil);

/**
 * @swagger
 * /api/soil/history:
 *   get:
 *     summary: Get user's soil analysis history
 *     tags: [Soil]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of soil analysis records
 */
router.get('/history', authMiddleware, getHistory);

module.exports = router;
