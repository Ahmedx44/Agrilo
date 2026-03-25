# Agrilo Backend 🌿

The minimal backend for Agrilo, an AI-powered soil testing assistant.

## Features
- **AI Soil Analysis**: Image-based soil health analysis powered by Groq.
- **Dashboard**: Track moisture, pH, and nutrients.
- **Authentication**: Secure JWT-based authentication.

## Tech Stack
- **Node.js** & **Express.js**
- **MongoDB** (Mongoose)
- **Groq Cloud AI** (Llama 3 Vision)

## Getting Started

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Configure environment**:
   Create a `.env` file:
   ```env
   PORT=4000
   MONGODB_URI=your_mongodb_uri
   GROQ_API_KEY=your_groq_api_key
   JWT_SECRET=your_jwt_secret
   ```

3. **Start the server**:
   ```bash
   npm run dev
   ```

## API Endpoints
- `POST /api/auth/register` & `login`
- `POST /api/soil/analyze`: Analyze soil image.
- `GET /api/soil/history`: View past scans.
- `GET /api/dashboard`: Summary of soil health.
