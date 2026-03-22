const express = require('express');
const { getDashboardData } = require('../controllers/dashboard.controller');
const authMiddleware = require('../middleware/auth.middleware');
const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Dashboard
 *   description: Soil health metrics and overview
 */

/**
 * @swagger
 * /api/dashboard:
 *   get:
 *     summary: Get dashboard soil health data and trends
 *     tags: [Dashboard]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Dashboard data
 */
router.get('/', authMiddleware, getDashboardData);

module.exports = router;
