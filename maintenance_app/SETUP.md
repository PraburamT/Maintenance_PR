# Quick Setup Guide

## 🚀 Getting Started

### 1. Backend Setup
Make sure your Node.js backend server is running with the following endpoints:
- `POST /maintenance-login` - User authentication
- `GET /plant-list` - Plant information
- `GET /notify-list` - Maintenance notifications
- `GET /main-work` - Work orders

### 2. Configuration
Update the backend URL in `lib/config/app_config.dart`:
```dart
static const String backendUrl = 'http://your-backend-url:port';
```

### 3. Run the App
```bash
# Install dependencies
flutter pub get

# Run on Chrome (web)
flutter run -d chrome

# Run on Android (if available)
flutter run -d android

# Run on iOS (if available)
flutter run -d ios
```

## 🔧 Troubleshooting

### Common Issues:
1. **Backend Connection Error**: Check if your backend server is running
2. **CORS Error**: Ensure your backend has CORS enabled for Flutter web
3. **Port Issues**: Verify the port number in the configuration

### Backend CORS Setup (Node.js):
```javascript
const cors = require('cors');
app.use(cors({
  origin: ['http://localhost:3000', 'http://127.0.0.1:3000'],
  credentials: true
}));
```

## 📱 App Features

- **Login Screen**: Employee ID and password authentication
- **Dashboard**: View all plants with details
- **Plant Details**: Comprehensive plant information
- **Notifications**: Maintenance notifications with priority levels
- **Work Orders**: Work order management and tracking
- **Local Storage**: Employee ID persistence across sessions
- **Logout**: Secure session termination

## 🌐 Web vs Mobile

- **Web**: Optimized for desktop and tablet use
- **Mobile**: Native mobile app experience
- **Responsive**: Adapts to different screen sizes

## 📊 Data Flow

1. User logs in → Backend validates credentials
2. Dashboard loads → Fetches plant list from backend
3. Plant selection → Shows detailed plant information
4. Navigation → Access notifications and work orders
5. Data filtering → Plant-specific data display

## 🔒 Security Features

- Employee ID stored locally (not passwords)
- Session management with automatic logout
- Secure API communication
- Input validation and error handling
