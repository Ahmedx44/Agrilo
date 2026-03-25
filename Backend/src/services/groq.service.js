const Groq = require('groq-sdk');

class GroqService {
  constructor() {
    this.groq = new Groq({ apiKey: process.env.GROQ_API_KEY });
    this.visionModel = 'meta-llama/llama-4-scout-17b-16e-instruct'; // Llama 4 Scout with vision
    this.textModel = 'llama-3.3-70b-versatile'; // fallback for text-only
  }

  async analyzeSoil(textInput, imageBuffer, mimeType) {
    try {
      const systemPrompt = `You are an agriculture expert. 
Analyze the soil based on the input and return a JSON object with:
{
  "moisture": number (percentage 0-100),
  "pH": number (scale 0-14),
  "nutrients": { "N": number (0-100), "P": number (0-100), "K": number (0-100) },
  "analysis": "A detailed markdown format report including Condition, Problems, Recommendations, and Suitable Crops."
}
IMPORTANT: Output ONLY the JSON object. Do not include any other text.`;

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
        max_tokens: 1500,
        temperature: 0.5, // Lower temperature for more consistent JSON
        response_format: { type: 'json_object' }
      });

      const content = response.choices[0].message.content;
      return JSON.parse(content);
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
