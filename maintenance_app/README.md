# Maintenance App

A Flutter application for managing plant maintenance operations, including plant details, notifications, and work orders.

## Features

- **User Authentication**: Secure login with Employee ID and password
- **Plant Management**: View and manage plant information
- **Notifications**: Track maintenance notifications with priority levels
- **Work Orders**: Monitor work orders and maintenance activities
- **Local Storage**: Employee ID is stored locally for session persistence
- **Modern UI**: Beautiful, responsive design with Material Design 3

## Prerequisites

- Flutter SDK (version 3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Backend server running (Node.js with the provided endpoints)

## Installation

1. **Clone or navigate to the project directory:**
   ```bash
   cd maintenance_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Update API configuration:**
   Open `lib/services/api_service.dart` and update the `baseUrl` to match your backend server:
   ```dart
   static const String baseUrl = 'http://your-backend-url:port';
   ```

## Backend Requirements

The app requires a backend server with the following endpoints:

### Authentication
- `POST /maintenance-login` - User login with Employee ID and password

### Plant Management
- `GET /plant-list` - Retrieve list of plants

### Notifications
- `GET /notify-list` - Retrieve maintenance notifications

### Work Orders
- `GET /main-work` - Retrieve work orders

## Running the App

1. **Ensure your backend server is running**

2. **Run the Flutter app:**
   ```bash
   flutter run
   ```

3. **For web development:**
   ```bash
   flutter run -d chrome
   ```

## App Structure

```
lib/
├── main.dart                 # Main app entry point
├── providers/               # State management
│   ├── auth_provider.dart   # Authentication state
│   ├── plant_provider.dart  # Plant data management
│   ├── notification_provider.dart # Notification data
│   └── work_provider.dart   # Work order data
├── screens/                 # UI screens
│   ├── login_screen.dart    # Login interface
│   ├── dashboard_screen.dart # Main dashboard
│   ├── plant_details_screen.dart # Plant information
│   ├── notifications_screen.dart # Notifications list
│   └── work_screen.dart     # Work orders list
└── services/                # API services
    └── api_service.dart     # HTTP client and API calls
```

## Usage Flow

1. **Login**: Enter Employee ID and password
2. **Dashboard**: View all available plants
3. **Plant Details**: Click on a plant to see detailed information
4. **Notifications**: Access plant-specific maintenance notifications
5. **Work Orders**: View work orders for the selected plant
6. **Logout**: Use the profile menu to log out

## Key Features

### Authentication
- Secure login with SAP backend integration
- Employee ID stored in local storage
- Session persistence across app restarts

### Plant Management
- Comprehensive plant information display
- Location details and contact information
- Quick access to plant-specific data

### Notifications
- Priority-based color coding
- Equipment and maintenance details
- Duration and creation date tracking

### Work Orders
- Work order type classification
- Start and end date management
- Work center and activity type information

## Dependencies

- `flutter`: Core Flutter framework
- `http`: HTTP client for API requests
- `shared_preferences`: Local storage for user data
- `provider`: State management
- `go_router`: Navigation and routing
- `flutter_svg`: SVG support for icons

## Configuration

### API Endpoints
Update the following constants in `lib/services/api_service.dart`:
- `baseUrl`: Your backend server URL
- `loginEndpoint`: Login API endpoint
- `plantEndpoint`: Plant list API endpoint
- `notificationEndpoint`: Notifications API endpoint
- `workEndpoint`: Work orders API endpoint

### Backend Integration
Ensure your Node.js backend is configured with:
- CORS enabled for Flutter web
- Proper error handling
- Authentication middleware
- SAP integration credentials

## Troubleshooting

### Common Issues

1. **API Connection Errors**
   - Verify backend server is running
   - Check API endpoint URLs
   - Ensure CORS is properly configured

2. **Authentication Issues**
   - Verify SAP credentials in backend
   - Check network connectivity
   - Validate API response format

3. **Build Errors**
   - Run `flutter clean` and `flutter pub get`
   - Check Flutter version compatibility
   - Verify all dependencies are properly installed

### Debug Mode
Run the app in debug mode for detailed error information:
```bash
flutter run --debug
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support and questions:
- Check the troubleshooting section
- Review the backend integration requirements
- Ensure all dependencies are properly configured
