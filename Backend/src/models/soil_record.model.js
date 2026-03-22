const mongoose = require('mongoose');

const soilRecordSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  image: {
    url: String,
    path: String,
    analysisId: String
  },
  textInput: String,
  analysisResult: {
    condition: String,
    problems: [String],
    recommendations: [String],
    suitableCrops: [String],
    aiResponse: String
  },
  indicators: {
    moisture: { type: Number, default: 0 },
    pH: { type: Number, default: 7.0 },
    nutrients: {
      N: Number,
      P: Number,
      K: Number
    }
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const SoilRecord = mongoose.model('SoilRecord', soilRecordSchema);
module.exports = SoilRecord;
