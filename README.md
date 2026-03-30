# Servicer

Servicer is a Flutter-based mobile application designed as a hyperlocal service marketplace. It allows users to create, browse, and manage service requests in a simple and scalable way.

---

## Getting Started

This project is a starting point for a marketplace-style Flutter application using Firebase as backend.

---

## Features

- Browse all service requests (Marketplace Home)
- Create new service requests with media upload
- Manage your own services (Edit/Delete)
- User profile and settings management
- Location selection (address + lat/lng)
- Clean UI with reusable components
- Firebase integration (Auth, Firestore, Storage)

---

## Tech Stack

- Flutter (UI Framework)
- Dart
- GetX (State Management & Routing)
- Firebase:
  - Authentication
  - Cloud Firestore
  - Firebase Storage

---

## Project Structure

```
lib/
├── core/
│   ├── constants/      # App constants (colors, strings, API keys)
│   ├── services/       # API services, Firebase helpers
│   └── widgets/        # Reusable UI components
├── data/
│   ├── models/         # Data models (ServiceRequestModel, UserModel)
│   └── repositories/   # Repository implementations
├── domain/
│   ├── entities/       # Business entities (ServiceRequestEntity)
│   └── repositories/   # Repository interfaces
├── presentation/
│   ├── controllers/    # GetX controllers
│   ├── screens/        # UI screens
│   └── bindings/       # Route bindings
├── routes/             # App routes configuration
└── main.dart           # App entry point
```

---

## Setup

1. **Clone the repository**
   ```bash
   git clone git@github.com:Ganesh2218/servicer-app.git
   cd Servicer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**
   - Create a Firebase project
   - Add Android & iOS apps
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the respective `android/app/` and `ios/Runner/` folders

4. **API Keys**
   - Add your Google Maps API key to `lib/core/constants/app_constants.dart`

---

## Running the App

```bash
# Run in debug mode
flutter run

# Run in release mode
flutter run --release
```

---

## Key Features

### 1. Service Requests
- Create requests with title, description, category, budget, location
- Upload images/videos
- View all requests in marketplace
- Edit or delete your own requests

### 2. User Management
- Email/password authentication
- Profile management
- Role-based UI (customer/provider)

### 3. Location Services
- Select service location using Google Maps
- Store latitude and longitude
- (Future) Filter requests by distance

---

## Development

### State Management
Uses GetX for:
- State management (`.obs` variables)
- Routing (`Get.toNamed`, `Get.offAllNamed`)
- Dependency injection (`Get.put`, `Get.lazyPut`)

### Routing
Routes are defined in `lib/routes/app_pages.dart`:
- `/` - Splash screen
- `/login` - Login screen
- `/signup` - Signup screen
- `/home` - Home screen (marketplace)
- `/create-request` - Create request screen
- `/profile` - Profile screen
- `/settings` - Settings screen

### UI Components
Reusable widgets in `lib/core/widgets/`:
- `AppTextField` - Custom text field
- `AppButton` - Custom button
- `AppText` - Custom text
- `AppAppBar` - Custom app bar
- `LoadingOverlay` - Loading indicator

---

## Firebase Setup

### Authentication
- Email/password authentication enabled
- User session management

### Firestore
Collections:
- `users` - User profiles
- `service_requests` - Service requests
- `categories` - Service categories

### Storage
- Media files (images/videos) uploaded to Firebase Storage
- URLs stored in Firestore

---

## Future Enhancements

- [ ] **Provider/Customer Roles** - Differentiate user types
- [ ] **Booking System** - Allow providers to accept requests
- [ ] **Ratings & Reviews** - Rate providers after service completion
- [ ] **Real-time Chat** - In-app messaging between users
- [ ] **Push Notifications** - Firebase Cloud Messaging
- [ ] **Payment Integration** - In-app payments
- [ ] **Search & Filtering** - Advanced search by category, price, rating
- [ ] **Map View** - Visual map showing request locations
- [ ] **Admin Panel** - Web-based admin dashboard

---

## License

MIT License
