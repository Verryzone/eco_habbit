# 🌿 Eco Habbit

A mobile application built with Flutter to help users track and maintain eco-friendly habits. Eco Habbit empowers individuals to build sustainable daily routines by logging, categorizing, and analyzing their green activities.

---

## ✨ Features

- **User Authentication** — Sign up, log in, and log out securely with email and password (powered by Supabase Auth).
- **Habit Tracking** — Create, edit, and delete eco-friendly habits with swipe-to-action gestures.
- **Category Management** — Organize habits into categories (e.g., Reuse, Recycle, Reduce) for better tracking.
- **Analytics Dashboard** — Visualize habit data with an interactive donut chart and category breakdown statistics.
- **User Profiles** — Manage your profile with a customizable username and profile picture (image upload via Supabase Storage).
- **Pull-to-Refresh** — Seamlessly refresh your habit list with pull-to-refresh support.
- **Smooth Animations** — Polished UI with animated page transitions, staggered list animations, and interactive bottom navigation.

---

## 🛠️ Tech Stack

| Layer          | Technology                                                        |
| -------------- | ----------------------------------------------------------------- |
| **Framework**  | [Flutter](https://flutter.dev) (Dart, SDK ^3.8.0)                |
| **Backend**    | [Supabase](https://supabase.com) (Auth, Database, Storage)       |
| **State Mgmt** | [GetX](https://pub.dev/packages/get) for navigation & reactivity |
| **Charts**     | [fl_chart](https://pub.dev/packages/fl_chart)                    |
| **Image**      | [image_picker](https://pub.dev/packages/image_picker)            |
| **UI Extras**  | [flutter_slidable](https://pub.dev/packages/flutter_slidable), [flutter_svg](https://pub.dev/packages/flutter_svg) |
| **Env Config** | [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)        |

---

## 📁 Project Structure

```
lib/
├── main.dart                # App entry point & Supabase initialization
├── auth/                    # Authentication screens
│   ├── loginScreen.dart
│   └── registerScreen.dart
├── config/
│   └── env.dart             # Environment variable configuration
├── controllers/
│   ├── dashboard_controller.dart
│   └── profile_controller.dart
├── models/
│   ├── habbit_model.dart    # Habit data model
│   ├── category_model.dart  # Category data model
│   └── user_model.dart      # User & Profile data models
├── pages/
│   ├── splashScreen.dart    # Splash / loading screen
│   ├── buttomNavbarScreen.dart  # Main screen with bottom navigation
│   ├── dashboardScreen.dart     # Habit list view
│   ├── analyticScreen.dart      # Analytics & charts
│   └── profileScreen.dart       # User profile management
├── services/
│   ├── auth_service.dart    # Authentication logic (Supabase Auth)
│   ├── habbit_service.dart  # CRUD operations for habits
│   ├── category_service.dart# Fetch habit categories
│   └── profile_service.dart # Profile & image upload logic
├── utils/
│   └── network_utils.dart   # Network connectivity helpers
└── widgets/
    ├── add_modal.dart       # Bottom sheet modal to add a habit
    ├── edit_modal.dart      # Bottom sheet modal to edit a habit
    └── connection_test_widget.dart
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (^3.8.0)
- A [Supabase](https://supabase.com) project with:
  - **Auth** enabled (email/password sign-up)
  - **Database** tables: `habbits`, `categories`, `profiles`
  - **Storage** bucket for profile images

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Verryzone/eco_habbit.git
   cd eco_habbit
   ```

2. **Create a `.env` file** in the project root with your Supabase credentials:
   ```
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 📊 Database Schema (Supabase)

| Table        | Key Columns                                          |
| ------------ | ---------------------------------------------------- |
| `habbits`    | `id`, `user_id`, `name`, `category_id`, `date`, `created_at` |
| `categories` | `id`, `name`                                         |
| `profiles`   | `user_id`, `username`, `email`, `image_url`, `update_at`     |

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to open an issue or submit a pull request.

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
