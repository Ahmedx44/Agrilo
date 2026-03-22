const SoilRecord = require('../models/soil_record.model');

const getDashboardData = async (req, res) => {
  try {
     const userId = req.userId;
     // Fetch the latest soil record
     const latestRecord = await SoilRecord.findOne({ userId }).sort({ createdAt: -1 });

     // If no record exists, send defaults
     if (!latestRecord) {
        return res.json({
           message: 'No soil data found for dashboard.',
           data: {
              moisture: 0,
              pH: 7.0,
              nutrients: { N: 0, P: 0, K: 0 },
              lastUpdated: null,
              recommendations: []
           }
        });
     }

     // Fetch history for charts (last 7 days/records)
     const history = await SoilRecord.find({ userId })
        .sort({ createdAt: -1 })
        .limit(7)
        .select('indicators createdAt');

     res.json({
        data: {
           moisture: latestRecord.indicators.moisture,
           pH: latestRecord.indicators.pH,
           nutrients: latestRecord.indicators.nutrients,
           lastUpdated: latestRecord.createdAt,
           recommendations: latestRecord.analysisResult.recommendations,
           history: history
        }
     });
  } catch (error) {
     console.error('Dashboard controller error:', error);
     res.status(500).json({ message: 'Error fetching dashboard data.' });
  }
};

module.exports = { getDashboardData };
