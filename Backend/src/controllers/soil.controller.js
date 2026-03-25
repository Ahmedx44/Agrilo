const SoilRecord = require('../models/soil_record.model');
const GroqService = require('../services/groq.service');
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

    // Call Groq 
    const analysisResponse = await GroqService.analyzeSoil(textInput, imageBuffer, mimeType);

    const newRecord = new SoilRecord({
      userId: req.userId,
      textInput: textInput,
      image: req.file ? {
        url: `/uploads/${req.file.filename}`,
        path: req.file.path
      } : null,
      analysisResult: {
        aiResponse: analysisResponse.analysis || "No detailed report provided."
      },
      indicators: {
        moisture: analysisResponse.moisture || 0,
        pH: analysisResponse.pH || 7.0,
        nutrients: {
          N: analysisResponse.nutrients?.N || 0,
          P: analysisResponse.nutrients?.P || 0,
          K: analysisResponse.nutrients?.K || 0
        }
      }
    });

    await newRecord.save();

    // Record saved successfully

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
