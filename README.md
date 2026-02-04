# FLUX - AI Note-Taking App

A high-performance, offline-first note-taking application built with Flutter and a custom Laravel (PHP) backend. This project demonstrates Clean Architecture principles and robust state management using Bloc/Cubit.

## ✨ Key Features
- Offline-First & Sync: Seamlessly create and edit notes offline; data automatically syncs with the custom backend when a connection is restored.

- AI Integration: Built-in AI features to summarize notes and fix grammar/style.

- Smart Search: Efficient filtering of notes by title or content across both local cache and remote data.

- UX Focused: Includes "Pinned" notes, "Undo Delete" functionality via SnackBar, and intuitive loading/error states.

- Secure Auth: Full authentication flow including Sign Up, Login, and Logout.


## 🛠 Tech Stack
- Frontend: Flutter (Bloc/Cubit, SQFlite, Dio, GetIt).

- Backend: Laravel (PHP) - A custom REST API for handling note persistence and synchronization.

- Architecture: Clean Architecture (Data, Domain, and Presentation layers).


## 📂 Project Structure
- The project follows a Feature-Driven Clean Architecture:

- core/: Database services and global constants.

- features/: Modular features (Auth, Notes, Settings) containing their own Data, Domain, and Presentation layers.

## 🚀 Getting Started
- Clone the repo: git clone https://semihaltin.com

- Install dependencies: flutter pub get

- Environment Variables: Copy .env.example to .env and fill in your API keys.

- Run the app: flutter run

## 📺 Demo & APK
- Performance Demo & APK: https://drive.google.com/drive/folders/1tDQ_48_8SstpvPMvhmhQO4v0v4K005kG?usp=sharing