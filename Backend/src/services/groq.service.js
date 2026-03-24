const Groq = require('groq-sdk');

class GroqService {
  constructor() {
    this.groq = new Groq({ apiKey: process.env.GROQ_API_KEY });
    this.visionModel = 'meta-llama/llama-4-scout-17b-16e-instruct'; // Llama 4 Scout with vision
    this.textModel = 'llama-3.3-70b-versatile'; // fallback for text-only
  }

  async analyzeSoil(textInput, imageBuffer, mimeType) {
    try {
      const systemPrompt = `You are an agriculture expert, specialized in soil health and crop management.
Analyze the soil based on the provided input (image, text or both).
Structure your response clearly for farmers:

1. Condition: A summary of the soil health.
2. Problems: Specific issues like nutrient deficiency, dryness, disease.
3. Recommendations: How to fix the soil.
4. Suitable Crops: What crops would thrive in this soil.

Keep it simple and actionable.`;

      const userContent = [];

      if (imageBuffer && mimeType) {
        const base64Image = imageBuffer.toString('base64');
        userContent.push({
          type: 'image_url',
          image_url: {
            url: `data:${mimeType};base64,${base64Image}`,
          },
        });
      }

      userContent.push({
        type: 'text',
        text: textInput || 'Analyze this soil image and provide a full health report.',
      });

      const response = await this.groq.chat.completions.create({
        model: imageBuffer ? this.visionModel : this.textModel,
        messages: [
          { role: 'system', content: systemPrompt },
          { role: 'user', content: userContent },
        ],
        max_tokens: 1024,
        temperature: 0.7,
      });

      return response.choices[0].message.content;
    } catch (error) {
      console.error('Groq Soil Analysis error:', error.message || error);
      throw error;
    }
  }

  async chat(userMessage, chatHistory = []) {
    try {
      const messages = [
        {
          role: 'system',
          content: 'You are an agriculture expert. Assist the user with any gardening or farming questions. Be professional, helpful, and concise.',
        },
        ...chatHistory.map((h) => ({
          role: h.role === 'assistant' ? 'assistant' : 'user',
          content: h.content,
        })),
        { role: 'user', content: userMessage },
      ];

      const response = await this.groq.chat.completions.create({
        model: this.textModel,
        messages,
        max_tokens: 512,
      });

      return response.choices[0].message.content;
    } catch (error) {
      console.error('Groq Chat error:', error.message || error);
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

      const response = await this.groq.chat.completions.create({
        model: this.textModel,
        messages: [
          { role: 'system', content: 'You are an agriculture recommendation engine.' },
          { role: 'user', content: prompt },
        ],
        max_tokens: 512,
      });

      return response.choices[0].message.content;
    } catch (error) {
      console.error('Groq Recommendation error:', error.message || error);
      throw error;
    }
  }
}

module.exports = new GroqService();
