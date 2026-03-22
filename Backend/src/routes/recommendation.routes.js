const express = require('express');
const { getRecommendations } = require('../controllers/recommendation.controller');
const authMiddleware = require('../middleware/auth.middleware');
const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Recommendations
 *   description: Smart crop and fertilizer recommendations
 */

/**
 * @swagger
 * /api/recommendations:
 *   post:
 *     summary: Get crop and fertilizer recommendations
 *     tags: [Recommendations]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               location:
 *                 type: string
 *               season:
 *                 type: string
 *     responses:
 *       200:
 *         description: AI-powered recommendations
 */
router.post('/', authMiddleware, getRecommendations);

module.exports = router;
