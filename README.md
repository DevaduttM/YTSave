markdown
# 📥 YT Save

YT Save is a Flutter-based mobile app that allows users to search for YouTube videos, view available download streams (audio/video), and download them for offline viewing — all within a sleek and minimal UI.

---

## 🌟 App Overview

- 🔍 **Search YouTube videos** by title or keywords.
- 🎞️ **Display thumbnails**, titles, channels, and duration.
- 📥 **Download video/audio streams** with resolution options.
- 💾 **Store metadata** and downloaded files locally using Isar database.
- 🎧 **View downloaded videos** in a styled Home screen.
- 🧭 Clean UI/UX with custom components and Riverpod for state management.

---

## 🚀 How to Run the App

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/yt_save.git
cd yt_save
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

---

## 🧠 Assumptions and Limitations

- 🧩 **YouTube API is not used.** The app uses `youtube_explode_dart` to parse public YouTube data, which may break if YouTube changes its structure.
- 📶 Requires a **stable internet connection** to search and fetch streams.
- 🧹 Downloaded video/audio files are stored locally but not auto-cleaned.
- ⚠️ **Downloading YouTube videos may violate YouTube's Terms of Service** — this app is for educational and personal offline use only.
- ⏯️ Downloads **do not run in the background** — closing or minimizing the app stops progress.
- 🔍 **Search input is non-debounced** and does not cache results.

---

## 📸 Screenshots

markdown
![Home Screen](screenshots/home.png)
![Download Options](screenshots/download_options.png)


---


