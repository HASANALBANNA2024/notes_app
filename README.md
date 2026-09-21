# 📝 Note Taking App (Flutter & BLoC)

A feature-rich, high-performance offline note-taking application built using **Flutter**, state management powered by **BLoC Pattern**, and local persistent storage using **SQLite Database**.

---

## 🛡️ Badges & Tech Stack

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![BLoC Architecture](https://img.shields.io/badge/State_Management-BLoC-blue?style=for-the-badge)](https://bloclibrary.dev)
[![SQLite](https://img.shields.io/badge/Database-SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)](https://www.sqlite.org)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-brightgreen?style=for-the-badge)]()

---

## ✨ Features

- 📝 **Create, Edit & Delete Notes:** Fast and intuitive interface to manage daily notes.
- 🔍 **Real-time Search:** Built-in `SearchDelegate` for instant keyword searching across saved notes.
- 🎨 **Rich UI & Custom Bottom Sheets:** Seamless UI flow with smooth bottom sheet integration.
- 🔘 **Multi-Selection Mode:** Select multiple items directly from the dashboard for batch actions.
- ⚡ **BLoC State Management:** Decoupled business logic ensuring reactive and clean code flow.
- 💾 **Local Offline Storage:** Full SQLite database support for safe offline data handling.
- 📱 **Cross-Platform Ready:** Native support for Android, iOS, macOS, Windows, Linux, and Web.

---

## 📸 Screenshots & UI Showcase

| Dashboard Screen | Multi-Selection Mode | Search Delegate |
| :---: | :---: | :---: |
| <img src="screenshots/dashboard_screen.png" width="250"/> | <img src="screenshots/selection_mode_dashboard.png" width="250"/> | <img src="screenshots/search_delegate.png" width="250"/> |

| New Note Sheet | Edit Note Screen | Delete Pop-up |
| :---: | :---: | :---: |
| <img src="screenshots/new_note_bottom_sheet.png" width="250"/> | <img src="screenshots/edit_note_screen.png" width="250"/> | <img src="screenshots/delete_pop_up.png" width="250"/> |

| Native Splash | Custom Splash Screen | Empty State |
| :---: | :---: | :---: |
| <img src="screenshots/native_splash_screen.png" width="250"/> | <img src="screenshots/splash_screen.png" width="250"/> | <img src="screenshots/no_found_notes.png" width="250"/> |

---

## 📁 Project Directory Structure

```text
lib/
├── controllers/
│   └── note_form_controller.dart
├── core/
│   ├── bloc/
│   │   ├── bottom_navigation_navbar/
│   │   │   ├── nav_bloc.dart
│   │   │   ├── nav_event.dart
│   │   │   └── nav_state.dart
│   │   ├── note/
│   │   │   ├── note_bloc.dart
│   │   │   ├── note_event.dart
│   │   │   └── note_state.dart
│   │   └── app_bloc_providers.dart
│   ├── database/
│   │   ├── database_helper.dart
│   │   └── note_model.dart
│   └── widgets/
│       ├── app_button.dart
│       ├── app_icon_button.dart
│       ├── app_text.dart
│       ├── app_text_field.dart
│       ├── app_theme.dart
│       ├── custom_app_bar.dart
│       ├── note_search_delegate.dart
│       └── note_sheet_helper.dart
├── features/
│   ├── home_screen/
│   │   ├── widgets/
│   │   │   └── note_card.dart
│   │   └── home_screen.dart
│   ├── new_note/
│   │   └── new_note_screen.dart
│   ├── splash/
│   │   └── splash_screen.dart
│   └── widgets/
│       ├── bottom_toolbar_section.dart
│       └── note_bottom_toolbar.dart
├── dashboard.dart
└── main.dart