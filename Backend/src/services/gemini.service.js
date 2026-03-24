const { GoogleGenerativeAI } = require('@google/generative-ai');
const fs = require('fs');

class GeminiService {
  constructor() {
    this.genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
    // gemini-2.0-flash-lite: lightest model available, lowest quota usage
    this.model = this.genAI.getGenerativeModel({ model: 'gemini-2.0-flash-lite' });
  }

  async analyzeSoil(textInput, imageBuffer, mimeType) {
    try {
      const systemPrompt = `You are an agriculture expert, specialized in soil health and crop management.
Analyze the soil based on the provided input (image, text or both).
Structure your response clearly for farmers with:
1. Condition: A summary of the soil health.
2. Problems: Specific issues like nutrient deficiency, dryness, disease.
3. Recommendations: How to fix the soil.
4. Suitable Crops: What crops would thrive in this soil.
Keep it simple and actionable.`;

      const parts = [{ text: systemPrompt }];

      if (imageBuffer && mimeType) {
        parts.push({
          inlineData: {
            data: imageBuffer.toString('base64'),
            mimeType,
          },
        });
      }

      if (textInput) {
        parts.push({ text: textInput });
      }

      if (parts.length === 1) {
        // Only system prompt, no real input
        parts.push({ text: 'Describe general soil health tips.' });
      }

      const result = await this.model.generateContent(parts);
      const response = result.response;
      return response.text();
    } catch (error) {
      console.error('Gemini Soil Analysis error:', error);
      throw error;
    }
  }

  async chat(userMessage, chatHistory = []) {
    try {
      const chat = this.model.startChat({
        history: chatHistory.map((h) => ({
          role: h.role === 'assistant' ? 'model' : 'user',
          parts: [{ text: h.content }],
        })),
        systemInstruction:
          'You are an agriculture expert. Assist the user with any gardening or farming questions. Be professional, helpful, and concise.',
      });

      const result = await chat.sendMessage(userMessage);
      return result.response.text();
    } catch (error) {
      console.error('Gemini Chat error:', error);
      throw error;
    }
  }

  async getRecommendations(soilData, location, season) {
    try {
      const prompt = `Based on the following data, recommend the best crops, fertilizers, and watering schedule:
Soil Health: ${JSON.stringify(soilData)}
Location: ${location || 'Unknown'}
Season: ${season || 'Unknown'}
Format:
Crops:
Fertilizers:
Watering Schedule:`;

      const result = await this.model.generateContent(prompt);
      return result.response.text();
    } catch (error) {
      console.error('Gemini Recommendation error:', error);
      throw error;
    }
  }
}

module.exports = new GeminiService();
