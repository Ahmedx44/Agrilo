# 🌱 Agrilo — AI-Powered Soil Health Monitor

Agrilo is a full-stack mobile application that helps gardeners and farmers monitor soil health using AI. Users can upload soil images, receive instant AI-powered analysis, track historical data, and get crop recommendations — all from a premium Flutter mobile app.

---

## 📱 Screenshots

> Dashboard · Soil Scan · History · Settings

---

## 🏗️ Project Structure

```
Agrilo/
├── Backend/          # Node.js + Express REST API
└── Mobile/           # Flutter mobile application
```

---

## ✨ Features

- 🔐 **Authentication** — JWT-based Sign In / Sign Up
- 📊 **Dashboard** — Summary of all soil tests, averages, and latest scan
- 📸 **Soil Analysis** — Upload soil images via camera or gallery for AI analysis
- 📜 **Scan History** — Browse all past soil analysis records

---

## 🚀 Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) >= 18
- [Flutter SDK](https://flutter.dev/)
- [MongoDB Atlas](https://www.mongodb.com/cloud/atlas) account 
- [Groq API Key](https://console.groq.com/)

---

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/agrilo.git
cd agrilo
```

---

### 2. Backend Setup

```bash
cd Backend
npm install
```

Create a `.env` file in the `Backend/` directory:

```env
PORT=4000
MONGODB_URI=your_mongodb_atlas_connection_string
JWT_SECRET=your_secret_key_here
GROQ_API_KEY=your_groq_api_key_here
NODE_ENV=development
```

#### Getting your keys:

**MongoDB Atlas URI:**
1. Go to [cloud.mongodb.com](https://cloud.mongodb.com)
2. Create a free cluster → Connect → Drivers → Copy the URI
3. Replace `<password>` with your DB user password
4. Whitelist your IP: **Network Access → Add IP Address → Allow from Anywhere** (`0.0.0.0/0`)

**Groq API Key (Free):**
1. Go to [console.groq.com](https://console.groq.com)
2. Sign in with Google → API Keys → Create API Key
3. Copy and paste into `.env`

#### Start the backend:

```bash
npm run dev
```

You should see:
```
🚀 Server is running on port 4000

Access the API on your network at the following addresses:
- Localhost: http://localhost:4000
- Network:   http://192.168.x.x:4000   ← use this for physical device
```

---

### 3. Mobile Setup

```bash
cd Mobile
flutter pub get
```

#### Configure the API base URL

Open `lib/app/view/app.dart` and update `the baseUrl properties for ApiClient.create`:


#### Run the app:

```bash
flutter run --flavor development -t lib/main_development.dart

---

## 📡 API Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/api/auth/register` | ❌ | Create a new account |
| POST | `/api/auth/login` | ❌ | Login, returns JWT |
| GET | `/api/dashboard` | ✅ | Get summary stats & latest scan |
| POST | `/api/soil/analyze` | ✅ | Upload image for AI analysis |
| GET | `/api/soil/history` | ✅ | Get all past soil records |

> Protected routes require `Authorization: Bearer <token>` header.

---

## ⚙️ Environment Variables Reference

| Variable | Required | Description |
|----------|----------|-------------|
| `PORT` | ✅ | Server port (default: 4000) |
| `MONGODB_URI` | ✅ | MongoDB Atlas connection string |
| `JWT_SECRET` | ✅ | Secret key for signing tokens |
| `GROQ_API_KEY` | ✅ | Groq AI API key for soil analysis |
| `NODE_ENV` | ✅ | `development` or `production` |

---

## 📁 Mobile App Structure

```
lib/
├── app/                    # Root app widget & routing
├── core/
│   ├── services/           # ApiClient, StorageService, ToastService
│   └── theme/              # AppColors, AppTheme, ThemeCubit
└── features/
    ├── auth/               # Auth cubit & repository
    ├── signin/             # Sign in page & cubit
    ├── signup/             # Sign up page & cubit
    ├── splash/             # Splash screen
    ├── home/               # Bottom navigation host
    ├── dashboard/          # Dashboard page, cubit, state
    ├── soil/               # Soil analysis & history
    └── settings/           # Settings page (theme, logout)
```

