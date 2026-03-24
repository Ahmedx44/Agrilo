const { OpenAI } = require('openai');
const fs = require('fs');

class OpenAIService {
  constructor() {
    this.openai = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY
    });
  }

  async analyzeSoil(textInput, imageUrl) {
    try {
      let messages = [
        {
          role: "system",
          content: `You are an agriculture expert, specialized in soil health and crop management.
            Analyze the soil based on the provided input (image, text or both).
            Format the response in a JSON-like structure (but return it as a string formatted for easy reading for farmers):
            1. Condition: A summary of the soil health.
            2. Problems: Specific issues like nutrient deficiency, dryness, disease.
            3. Recommendations: How to fix the soil.
            4. Suitable Crops: What crops would thrive in this soil.
            Keep it simple and actionable for farmers.`
        }
      ];

      let userContent = [];
      if (textInput) {
        userContent.push({ type: "text", text: textInput });
      }

      if (imageUrl) {
        // In a real Vision model, this could be a base64 or a public URL.
        // For now, let's assume the client sends a base64 or we handle it if the image is local.
        // For local files, we'd read it and convert to base64.
        userContent.push({
          type: "image_url",
          image_url: {
             "url": imageUrl // This should be a base64 encoded image or a public URL
           }
        });
      }

      messages.push({
        role: "user",
        content: userContent
      });

      const response = await this.openai.chat.completions.create({
        model: "gpt-4o",
        messages: messages,
        max_tokens: 1000
      });

      return response.choices[0].message.content;
    } catch (error) {
      console.error('OpenAI Soil Analysis error:', error);
      throw error;
    }
  }

  async chat(userId, userMessage, chatHistory = []) {
     try {
       // Convert chat history for OpenAI format
       const messages = [
         {
           role: "system",
           content: "You are an agriculture expert. Assist the user with any gardening or farming questions. Be professional, helpful, and concise."
         },
         ...chatHistory.map(h => ({
           role: h.role,
           content: h.content
         })),
         { role: "user", content: userMessage }
       ];

       const response = await this.openai.chat.completions.create({
         model: "gpt-3.5-turbo",
         messages: messages
       });

       return response.choices[0].message.content;
     } catch (error) {
       console.error('OpenAI Chat error:', error);
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

      const response = await this.openai.chat.completions.create({
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: "You are an agriculture recommendation engine." },
          { role: "user", content: prompt }
        ]
      });

      return response.choices[0].message.content;
    } catch (error) {
      console.error('OpenAI Recommendation error:', error);
      throw error;
    }
  }
}

module.exports = new OpenAIService();
