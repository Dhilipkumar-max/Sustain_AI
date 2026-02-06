# SUSTAINAI — Flutter

Overview
--------

SUSTAINAI is a comprehensive sustainability platform implemented in Flutter with Supabase as the backend. This repository recreates the React version's UI/UX and functionality in a native Flutter application.

Key points:

- Cross-platform Flutter application (Android, iOS, Web, Desktop)
- Supabase backend for authentication, storage, and database
- Modular design with six sustainability modules and a unified dashboard

Features
--------

Authentication

- Login & signup using email/password
- Session management via Supabase Auth
- User profiles with metadata
- Protected routes for authenticated users

Dashboard & Modules

- Six sustainability modules:
   1. Sustainable Consumption — analyze environmental impact of daily habits
   2. Financial Integrity — track ethical investments and sustainable funding
   3. Sustainability Monitor — real-time carbon footprint tracking
   4. Personal Wellbeing — holistic wellness tracking
   5. Climate Resilience — disaster preparedness and weather prediction
   6. ESG Analysis — energy optimization with ESG metrics

- Platform overview metrics:
   - Total modules available
   - Active analyses running
   - Sustainability score
   - Weekly alerts

Design System

- Modern UI matching the React version
- Light & dark themes with Material Design 3
- Custom color palette with teal as primary
- Google Fonts (Inter)
- Responsive layouts for mobile and tablet
- Glass-morphism effects on auth screens
- Gradient backgrounds and shadows

Tech Stack
----------

- Flutter (cross-platform UI)
- Dart (programming language)
- Supabase (Auth, Database)
- Provider (state management)
- go_router (navigation)

Getting Started
---------------

Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Supabase account and project

Installation

1. Clone the repository:

```bash
git clone https://github.com/Dhilipkumar-max/Sustain_AI.git
cd sustainai_flutter
```

2. Install dependencies:

```bash
flutter pub get
```

3. Configure Supabase:

- The app ships with a configuration file at `lib/core/config/app_config.dart`.
- Supabase URL used in this project:

```
https://jgorlakedcrfnboolftb.supabase.co
```

- To use your own Supabase project, update the credentials in `app_config.dart` or wire environment-based configuration.

4. Run the app:

```bash
flutter run
```

Project Structure
-----------------

Top-level layout (key folders):

```
lib/
├─ core/
│  ├─ config/          # app_config.dart (Supabase credentials)
│  ├─ services/        # supabase_service.dart
│  └─ theme/           # app_theme.dart
├─ features/
│  ├─ auth/            # models, providers, login/signup screens
│  ├─ dashboard/       # dashboard_screen.dart
│  ├─ consumption/     # consumption feature (models, screens, services)
│  ├─ financial_integrity/
│  ├─ monitor/
│  ├─ predictive/
│  ├─ resilience/
│  ├─ settings/
│  └─ wellbeing/
└─ main.dart           # app entry point & routing
```

Design System
-------------

Color palette:

- Primary (Teal): `#14b8a6`
- Success: `#22c55e`
- Warning: `#f59e0b`
- Danger: `#ef4444`
- Info: `#3b82f6`

Typography:

- Font family: Inter (Google Fonts)
- Heading 1: 42px, weight 800
- Heading 2: 24px, weight 700
- Body: 16px, weight 400

Spacing scale:

- space1: 4px
- space2: 8px
- space3: 12px
- space4: 16px
- space6: 24px
- space8: 32px

Database Schema
---------------

This project shares the Supabase schema with the React version. Important tables include:

- `profiles` — user profiles and preferences
- `products` — sustainable product catalog
- `consumption_logs` — user consumption tracking
- `wellbeing_assessments` — health & wellness data
- `disaster_alerts` — climate and disaster warnings
- `companies` — company ESG data
- `user_portfolios` — investment portfolios
- `esg_alerts` — ESG-related notifications

Dependencies
------------

Key dependencies (from `pubspec.yaml`):

```yaml
dependencies:
   supabase_flutter: ^2.5.6
   provider: ^6.1.2
   google_fonts: ^6.2.1
   flutter_svg: ^2.0.10+1
   fl_chart: ^0.68.0
   intl: ^0.19.0
   http: ^1.2.1
   shared_preferences: ^2.2.3
   go_router: ^14.2.0
```

Authentication Flow
-------------------

1. App launch — check for existing session
2. If authenticated — navigate to Dashboard
3. If not authenticated — show Login screen
4. Login/Signup — create session with Supabase
5. Fetch user profile from `profiles` table
6. Navigate to Dashboard and load modules

Feature Comparison
------------------

| Feature | React Version | Flutter Version |
|--------:|:-------------:|:---------------:|
| Authentication | ✅ Supabase Auth | ✅ Supabase Auth |
| Dashboard UI   | ✅ Modern Design | ✅ Identical Design |
| Module Navigation | ✅ 6 Modules | ✅ 6 Modules |
| Light/Dark Theme | ✅ CSS Variables | ✅ ThemeData |
| Protected Routes | ✅ React Router | ✅ Navigator |
| State Management | ✅ Context API | ✅ Provider |
| Responsive Design | ✅ CSS Grid | ✅ GridView |

Module Status
-------------

- ✅ Authentication — Complete
- ✅ Dashboard — Complete
- ✅ Settings — Complete
- 🚧 Consumption — Coming Soon (placeholder ready)
- 🚧 Financial Integrity — Coming Soon
- 🚧 Wellbeing — Coming Soon
- 🚧 Climate Resilience — Coming Soon
- 🚧 ESG Analysis — Coming Soon
- 🚧 Sustainability Monitor — Coming Soon

Screenshots
-----------

Main dashboard and module screenshots:

![Main Dashboard](https://i.postimg.cc/Sx4wvm0d/Whats-App-Image-2026-02-06-at-10-46-48-AM.jpg)

Module 1 — Consumption:

![Module 1 - Consumption 1](https://i.postimg.cc/gkV7R1wf/Whats_App_Image_2026_02_06_at_10_46_49_AM.jpg)
![Module 1 - Consumption 2](https://i.postimg.cc/RV7Yf23Y/Whats_App_Image_2026_02_06_at_10_46_49_AM_(1).jpg)
![Module 1 - Consumption 3](https://i.postimg.cc/wvDXZYYC/Whats_App_Image_2026_02_06_at_10_46_50_AM.jpg)

Module 2:

![Module 2](https://i.postimg.cc/4N60tjKD/Whats_App_Image_2026_02_06_at_10_46_50_AM_(1).jpg)

Module 3:

![Module 3](https://i.postimg.cc/Fsy6cwdt/Whats_App_Image_2026_02_06_at_10_46_50_AM_(2).jpg)

Module 4:

![Module 4 - 1](https://i.postimg.cc/wMHXd49P/Whats_App_Image_2026_02_06_at_10_46_51_AM.jpg)
![Module 4 - 2](https://i.postimg.cc/2ymQf9CM/Whats_App_Image_2026_02_06_at_10_46_51_AM_(1).jpg)

Module 5:

![Module 5 - 1](https://i.postimg.cc/LXjtwFMm/Whats_App_Image_2026_02_06_at_10_46_51_AM_(2).jpg)
![Module 5 - 2](https://i.postimg.cc/KjFPypZy/Whats_App_Image_2026_02_06_at_10_46_52_AM.jpg)
![Module 5 - 3](https://i.postimg.cc/yxBmzpVK/Whats_App_Image_2026_02_06_at_10_46_52_AM_(2).jpg)

Module 6:

![Module 6](https://i.postimg.cc/qq0sdDkT/Whats_App_Image_2026_02_06_at_10_46_53_AM.jpg)

Download / QR:

![Download QR](https://i.postimg.cc/NfKMj7Ln/qrcode-(1).png)

Development
-----------

Run in debug mode:

```bash
flutter run
```

Build for Android:

```bash
flutter build apk --release
```

Build for iOS:

```bash
flutter build ios --release
```

Build for web:

```bash
flutter build web --release
```

Contributing
------------

This repository is a Flutter recreation of the React SustainAI app. Contributions are welcome. The two implementations share:

- Supabase backend
- Identical database schema
- Matching UI/UX design and feature set

If you plan to contribute:

- Open an issue describing the feature or bug
- Create a branch for your change
- Submit a pull request with a clear description

Security & Secrets
------------------

- Remove any Supabase credentials or secrets from commits before publishing. `lib/core/config/app_config.dart` contains configuration used by the app; consider using environment variables or CI secrets instead of committing credentials.

License
-------

Copyright © 2024 SustainAI Inc. All rights reserved.

—

Built with Flutter 💙 and Supabase 🚀

Powering a more sustainable tomorrow.

# SUSTAINAI - Flutter

A comprehensive sustainability platform built with Flutter and Supabase, recreating the React version with identical UI/UX and functionality.

## 🌱 Features

### Authentication
- **Login & Signup** with email/password
- Session management with Supabase Auth
- User profiles with full name and metadata
- Protected routes

### Dashboard
- **6 Sustainability Modules:**
  1. **Sustainable Consumption** - Analyze environmental impact of daily habits
  2. **Financial Integrity** - Track ethical investments and sustainable funding
  3. **Sustainability Monitor** - Real-time carbon footprint tracking
  4. **Personal Wellbeing** - Holistic wellness tracking
  5. **Climate Resilience** - Disaster preparedness and weather prediction
  6. **ESG Analysis** - Energy optimization with ESG metrics

- **Platform Overview Metrics:**
  - Total Modules Available
  - Active Analyses Running
  - Sustainability Score
  - Weekly Alerts Generated

### Design System
- **Modern UI** matching the React version
- **Light & Dark themes** with Material Design 3
- **Custom color palette** with teal primary color
- **Google Fonts (Inter)** for typography
- **Responsive layouts** for mobile and tablet
- **Glass-morphism effects** on auth screens
- **Gradient backgrounds** and shadows

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Supabase account and project

### Installation

1. **Clone the repository**
   ```bash
   cd d:\React\Subtain_AI\sustainai_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   - The app is already configured with Supabase credentials in `lib/core/config/app_config.dart`
   - URL: `https://jgorlakedcrfnboolftb.supabase.co`
   - If you want to use your own Supabase project, update the credentials in `app_config.dart`

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── app_config.dart          # App configuration & Supabase credentials
│   ├── services/
│   │   └── supabase_service.dart    # Supabase client service
│   └── theme/
│       └── app_theme.dart            # Theme configuration (light/dark)
│
├── features/
│   ├── auth/
│   │   ├── models/
│   │   │   └── profile_model.dart   # User profile model
│   │   ├── providers/
│   │   │   └── auth_provider.dart   # Authentication state management
│   │   └── screens/
│   │       ├── login_screen.dart    # Login page
│   │       └── signup_screen.dart   # Signup page
│   │
│   ├── dashboard/
│   │   └── screens/
│   │       └── dashboard_screen.dart # Main dashboard with modules
│   │
│   ├── settings/
│   │   └── screens/
│   │       └── settings_screen.dart  # Settings & profile
│   │
│   └── common/
│       └── screens/
│           └── coming_soon_screen.dart # Placeholder for modules
│
└── main.dart                         # App entry point & routing
```

## 🎨 Design System

### Color Palette
- **Primary (Teal)**: `#14b8a6` - Sustainability theme
- **Success**: `#22c55e`
- **Warning**: `#f59e0b`
- **Danger**: `#ef4444`
- **Info**: `#3b82f6`

### Typography
- **Font Family**: Inter (Google Fonts)
- **Heading 1**: 42px, weight 800
- **Heading 2**: 24px, weight 700
- **Body**: 16px, weight 400

### Spacing Scale
- space1: 4px
- space2: 8px
- space3: 12px
- space4: 16px
- space6: 24px
- space8: 32px

## 🗄️ Database Schema

The app uses the same Supabase database schema as the React version:

### Tables
- **profiles** - User profiles and preferences
- **products** - Sustainable product database
- **consumption_logs** - User consumption tracking
- **wellbeing_assessments** - Health and wellness data
- **disaster_alerts** - Climate and disaster warnings
- **companies** - Company ESG data
- **user_portfolios** - Investment portfolios
- **esg_alerts** - ESG-related notifications

## 📦 Dependencies

```yaml
dependencies:
  supabase_flutter: ^2.5.6      # Supabase client
  provider: ^6.1.2               # State management
  google_fonts: ^6.2.1           # Typography
  flutter_svg: ^2.0.10+1         # SVG support
  fl_chart: ^0.68.0              # Charts
  intl: ^0.19.0                  # Internationalization
  http: ^1.2.1                   # HTTP client
  shared_preferences: ^2.2.3     # Local storage
  go_router: ^14.2.0             # Navigation
```

## 🔐 Authentication Flow

1. **App Launch** → Check for existing session
2. **If authenticated** → Navigate to Dashboard
3. **If not authenticated** → Show Login screen
4. **Login/Signup** → Create session with Supabase
5. **Fetch user profile** → Load from profiles table
6. **Navigate to Dashboard** → Show all modules

## 🌟 Key Features Comparison

| Feature | React Version | Flutter Version |
|---------|--------------|-----------------|
| Authentication | ✅ Supabase Auth | ✅ Supabase Auth |
| Dashboard UI | ✅ Modern Design | ✅ Identical Design |
| Module Navigation | ✅ 6 Modules | ✅ 6 Modules |
| Light/Dark Theme | ✅ CSS Variables | ✅ ThemeData |
| Protected Routes | ✅ React Router | ✅ Navigator |
| State Management | ✅ Context API | ✅ Provider |
| Responsive Design | ✅ CSS Grid | ✅ GridView |

## 🚧 Module Status

- ✅ **Authentication** - Complete
- ✅ **Dashboard** - Complete
- ✅ **Settings** - Complete
- 🚧 **Consumption** - Coming Soon (placeholder ready)
- 🚧 **Financial Integrity** - Coming Soon
- 🚧 **Wellbeing** - Coming Soon
- 🚧 **Climate Resilience** - Coming Soon
- 🚧 **ESG Analysis** - Coming Soon
- 🚧 **Sustainability Monitor** - Coming Soon

## 📱 Screenshots

The Flutter app replicates the exact UI/UX of the React version. Below are screenshots of the main dashboard and each module.

**Main Dashboard**

![Main Dashboard](https://i.postimg.cc/Sx4wvm0d/Whats-App-Image-2026-02-06-at-10-46-48-AM.jpg)

**Main Dashboard / Module 1 — Consumption**

![Module 1 - Consumption 1](https://i.postimg.cc/gkV7R1wf/Whats_App_Image_2026_02_06_at_10_46_49_AM.jpg)
![Module 1 - Consumption 2](https://i.postimg.cc/RV7Yf23Y/Whats_App_Image_2026_02_06_at_10_46_49_AM_(1).jpg)
![Module 1 - Consumption 3](https://i.postimg.cc/wvDXZYYC/Whats_App_Image_2026_02_06_at_10_46_50_AM.jpg)

**Module 2**

![Module 2](https://i.postimg.cc/4N60tjKD/Whats_App_Image_2026_02_06_at_10_46_50_AM_(1).jpg)

**Module 3**

![Module 3](https://i.postimg.cc/Fsy6cwdt/Whats_App_Image_2026_02_06_at_10_46_50_AM_(2).jpg)

**Module 4**

![Module 4 - 1](https://i.postimg.cc/wMHXd49P/Whats_App_Image_2026_02_06_at_10_46_51_AM.jpg)
![Module 4 - 2](https://i.postimg.cc/2ymQf9CM/Whats_App_Image_2026_02_06_at_10_46_51_AM_(1).jpg)

**Module 5**

![Module 5 - 1](https://i.postimg.cc/LXjtwFMm/Whats_App_Image_2026_02_06_at_10_46_51_AM_(2).jpg)
![Module 5 - 2](https://i.postimg.cc/KjFPypZy/Whats_App_Image_2026_02_06_at_10_46_52_AM.jpg)
![Module 5 - 3](https://i.postimg.cc/yxBmzpVK/Whats_App_Image_2026_02_06_at_10_46_52_AM_(2).jpg)

**Module 6**

![Module 6](https://i.postimg.cc/qq0sdDkT/Whats_App_Image_2026_02_06_at_10_46_53_AM.jpg)

**Download / QR**

Scan or download the app using the QR below:

![Download QR](https://i.postimg.cc/NfKMj7Ln/qrcode-(1).png)

## 🔧 Development

### Run in debug mode
```bash
flutter run
```

### Build for Android
```bash
flutter build apk --release
```

### Build for iOS
```bash
flutter build ios --release
```

### Build for Web
```bash
flutter build web --release
```

## 🤝 Contributing

This is a recreation of the React SustainAI app in Flutter. Both versions share:
- Same Supabase backend
- Identical database schema
- Matching UI/UX design
- Similar feature set

## 📄 License

Copyright © 2024 SustainAI Inc. All rights reserved.

---

**Built with Flutter 💙 and Supabase 🚀**

*Powering a more sustainable tomorrow.*
#   S u s t a i n _ A I 
 
 