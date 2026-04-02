const SoilRecord = require('../models/soil_record.model');

const getDashboardData = async (req, res) => {
  try {
    const userId = req.userId;
    const allRecords = await SoilRecord.find({ userId }).sort({ createdAt: -1 });

    const totalTests = allRecords.length;

    if (totalTests === 0) {
      return res.json({
        data: {
          totalTests: 0,
          latestScan: null,
          avgMoisture: 0,
          avgPH: 0,
          avgNutrients: { N: 0, P: 0, K: 0 },
          history: [],
        }
      });
    }

    const avgMoisture = Math.round(
      allRecords.reduce((sum, r) => sum + (r.indicators?.moisture || 0), 0) / totalTests
    );
    const avgPH = (
      allRecords.reduce((sum, r) => sum + parseFloat(r.indicators?.pH || 0), 0) / totalTests
    ).toFixed(1);
    const avgN = Math.round(allRecords.reduce((sum, r) => sum + (r.indicators?.nutrients?.N || 0), 0) / totalTests);
    const avgP = Math.round(allRecords.reduce((sum, r) => sum + (r.indicators?.nutrients?.P || 0), 0) / totalTests);
    const avgK = Math.round(allRecords.reduce((sum, r) => sum + (r.indicators?.nutrients?.K || 0), 0) / totalTests);

  
    const latest = allRecords[0];
    const history = allRecords.slice(0, 7).map(r => ({
      date: r.createdAt,
      moisture: r.indicators?.moisture,
      pH: r.indicators?.pH,
    }));

    res.json({
      data: {
        totalTests,
        avgMoisture,
        avgPH: parseFloat(avgPH),
        avgNutrients: { N: avgN, P: avgP, K: avgK },
        latestScan: {
          moisture: latest.indicators?.moisture,
          pH: latest.indicators?.pH,
          nutrients: latest.indicators?.nutrients,
          createdAt: latest.createdAt,
          aiResponse: latest.analysisResult?.aiResponse,
        },
        history,
      }
    });
  } catch (error) {
    console.error('Dashboard controller error:', error);
    res.status(500).json({ message: 'Error fetching dashboard data.' });
  }
};

module.exports = { getDashboardData };
