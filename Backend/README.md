# Agrilo Backend 🌿

The backend for Agrilo, an AI-powered soil testing and agriculture assistant.

## Features
- **AI Soil Analysis**: Send images and text to get detailed soil health analysis.
- **Agriculture Chat**: Ask expert advice from an AI assistant.
- **Dashboard**: Track moisture, pH, and nutrients over time.
- **Smart Recommendations**: Get crop, fertilizer, and watering suggestions based on soil data.
- **Authentication**: Secure JWT-based user authentication.

## Tech Stack
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB (Mongoose)
- **AI Integration**: OpenAI (GPT-4 Vision & GPT-3.5 Turbo)
- **File Uploads**: Multer

## Getting Started

### Prerequisites
- Node.js installed
- MongoDB (local or Atlas)
- OpenAI API Key

### Installation

1. Navigate to the Backend folder:
   ```bash
   cd Backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure environment variables:
   Create a `.env` file in the root directory (using `.env.example` as a template):
   ```env
   PORT=3030
   MONGODB_URI=mongodb://localhost:27017/agrilo
   OPENAI_API_KEY=your_openai_api_key_here
   JWT_SECRET=your_jwt_secret_here
   ```

4. Start the server (Development):
   ```bash
   npm run dev
   ```

## API Endpoints

### Auth
- `POST /api/auth/register`: Register a new user.
- `POST /api/auth/login`: Login and get a JWT token.

### Soil Analysis
- `POST /api/soil/analyze`: Analyze soil (requires multipart/form-data with 'image' field and optional 'textInput').
- `GET /api/soil/history`: Get user's soil scan history.

### Dashboard
- `GET /api/dashboard`: Get current soil health indicators and historical trends.

### Chat
- `POST /api/chat/send`: Send a message to the AI assistant.
- `GET /api/chat/history`: Get user's chat conversation history.

### Recommendations
- `POST /api/recommendations`: Get smart farming recommendations.

### Real-time Chat (WebSockets)
The backend uses **Socket.io** for real-time messaging.

**Connection Details:**
- **URL**: `http://localhost:3030`
- **Auth**: Pass JWT in `auth.token`.

**Socket Events:**
- `send_message`: Send a message to the AI expert (data: `{ message: string }`).
- `receive_message`: Listen for responses from the AI.
- `notification`: Receive real-time alerts.

## Directory Structure
```
src/
 ├── controllers/    # Request handlers
 ├── routes/         # API endpoints
 ├── services/       # OpenAI & Socket services
 ├── utils/          # Documentation & helpers (Swagger)
 ├── models/         # Mongoose schemas
 ├── middleware/     # Auth & upload filters
 ├── uploads/        # Local storage for soil images
 ├── app.js          # Express config
 └── server.js       # Database connection, Socket.io init & startup
```
