const SoilRecord = require('../models/soil_record.model');
const GroqService = require('../services/groq.service');
const socketService = require('../services/socket.service');
const path = require('path');
const fs = require('fs');

const analyzeSoil = async (req, res) => {
  try {
    const { textInput } = req.body;
    let imageBuffer = null;
    let mimeType = null;

    if (req.file) {
      imageBuffer = fs.readFileSync(req.file.path);
      mimeType = req.file.mimetype;
    }

    // Call Groq (Llama Vision) for analysis
    const analysisResponse = await GroqService.analyzeSoil(textInput, imageBuffer, mimeType);

    // Create a new soil record
    const newRecord = new SoilRecord({
      userId: req.userId,
      textInput: textInput,
      image: req.file ? {
        url: `/uploads/${req.file.filename}`,
        path: req.file.path
      } : null,
      analysisResult: {
        aiResponse: analysisResponse
      },
      // Random mock indicators for demonstration (could be updated later)
      indicators: {
        moisture: Math.floor(Math.random() * 100),
        pH: (Math.random() * 4 + 4).toFixed(1), // pH between 4 and 8
        nutrients: {
          N: Math.floor(Math.random() * 100),
          P: Math.floor(Math.random() * 100),
          K: Math.floor(Math.random() * 100)
        }
      }
    });

    await newRecord.save();

    // Notify user via socket (real-time notification)
    socketService.sendNotification(req.userId, "Soil analysis complete! Check your results.");

    res.status(200).json({
       message: 'Analysis complete.',
       data: newRecord
    });
  } catch (error) {
    console.error('Soil analysis controller error:', error);
    res.status(500).json({ message: 'Error analyzing soil.' });
  }
};

const getHistory = async (req, res) => {
  try {
    const history = await SoilRecord.find({ userId: req.userId }).sort({ createdAt: -1 });
    res.json({ data: history });
  } catch (error) {
    console.error('Soil history controller error:', error);
    res.status(500).json({ message: 'Error fetching soil history.' });
  }
};

module.exports = { analyzeSoil, getHistory };
