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
- 🌙 **Dark / Light Mode** — Persistent theme toggle in Settings
- 🚪 **Account Management** — Logout from the Settings page
- ⚡ **Real-time notifications** — Socket.IO integration

---

## 🛠️ Tech Stack

### Backend
| Tech | Purpose |
|------|---------|
| Node.js + Express | REST API server |
| MongoDB Atlas + Mongoose | Database |
| JWT | Authentication |
| Multer | Image file uploads |
| Groq SDK (Llama Vision) | AI soil image analysis |
| Socket.IO | Real-time notifications |

### Mobile
| Tech | Purpose |
|------|---------|
| Flutter | Cross-platform mobile UI |
| flutter_bloc + Cubit | State management |
| Dio | HTTP networking |
| shared_preferences | Local persistence |
| image_picker | Camera / Gallery access |
| intl | Date formatting |

---

## 🚀 Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) >= 18
- [Flutter SDK](https://flutter.dev/) >= 3.19
- [MongoDB Atlas](https://www.mongodb.com/cloud/atlas) account (free tier works)
- [Groq API Key](https://console.groq.com/) (free, no credit card)

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

Open `lib/app/view/app.dart` and update `_getBaseUrl()`:

```dart
String _getBaseUrl() {
  if (kIsWeb) return 'http://localhost:4000';
  if (Platform.isAndroid) return 'http://YOUR_NETWORK_IP:4000';
  return 'http://YOUR_NETWORK_IP:4000'; // iOS physical device
}
```

> **iOS Simulator**: use `http://127.0.0.1:4000`  
> **Android Emulator**: use `http://10.0.2.2:4000`  
> **Physical device** (iOS or Android): use your Mac's LAN IP shown in the backend startup log

#### Run the app:

```bash
# iOS Simulator
flutter run --flavor development -t lib/main_development.dart

# Android Emulator or device
flutter run --flavor development -t lib/main_development.dart
```

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

## 🤖 AI Fallback

If the Groq API is unavailable or quota is exceeded, the backend automatically returns a realistic simulated soil analysis so the app continues to function end-to-end during development.

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

---

## 🐛 Common Issues

**MongoDB connection fails on start:**
> Go to MongoDB Atlas → Network Access → Add your current IP or use `0.0.0.0/0` for development.

**`flutter pub add image_picker` seems stuck:**
> Kill it and run `flutter pub get` instead. The package is already in `pubspec.yaml`.

**Android build fails with Kotlin version error:**
> Ensure `android/settings.gradle.kts` has `id("org.jetbrains.kotlin.android") version "2.2.10"`.

**App shows 401 on dashboard after login:**
> The auth token interceptor in `ApiClient` handles this automatically. Check that `StorageService.init()` is called before `runApp()`.

---

## 📄 License

MIT License — feel free to use, modify, and distribute.

---

## 🙏 Acknowledgements

- [Groq](https://groq.com/) — for blazing-fast free AI inference
- [Flutter](https://flutter.dev/) — cross-platform UI toolkit
- [MongoDB Atlas](https://www.mongodb.com/) — cloud database

---

*Built with ❤️ using Flutter + Node.js + Groq AI*
