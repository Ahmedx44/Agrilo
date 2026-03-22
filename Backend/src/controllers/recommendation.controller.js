const OpenAIService = require('../services/openai.service');
const SoilRecord = require('../models/soil_record.model');

const getRecommendations = async (req, res) => {
  try {
     const { userId } = req;
     const { location, season } = req.body;

     // Get latest soil data for better recommendations
     const latestRecord = await SoilRecord.findOne({ userId }).sort({ createdAt: -1 });

     // If no record exists, use defaults or prompt user
     const soilData = latestRecord ? latestRecord.indicators : { moisture: 50, pH: 7.0, N: 0, P: 0, K: 0 };

     // Call Recommendation engine
     const recommendations = await OpenAIService.getRecommendations(soilData, location, season);

     res.json({
        message: 'Recommendations generated successfully.',
        data: recommendations
     });
  } catch (error) {
     console.error('Recommendation controller error:', error);
     res.status(500).json({ message: 'Error generating recommendations.' });
  }
};

module.exports = { getRecommendations };
