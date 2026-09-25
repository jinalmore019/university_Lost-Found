# 🎓 University Lost & Found App

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)

A complete, real-time Flutter and Dart application designed exclusively for university campuses. It digitizes the traditional Lost & Found process, making it seamless for students and staff to report, track, and claim lost items.

---

## 🌟 Key Features

### 👨‍🎓 For Students (Users)
- **Real-Time Public Feed:** View a unified feed of all lost and found items on campus.
- **Report Lost Items:** Post details of lost items with images, descriptions, and contact info.
- **Report Found Items:** Upload found items. You can choose to:
  - **Keep it with you:** Set up private verification questions for the claimer.
  - **Deposit it:** Hand it over to a physical location (Security Desk, Library, HOD Office) and update the app.
- **Smart Claiming & Connectivity:** Instantly connect with the finder/loser via **WhatsApp** or direct **Phone Call**.

### 🛡️ For University Authority (Admins)
Special permissions are automatically granted if you register with an authorized email keyword (e.g., `admin`, `security`, `hod`, `library`, `librarian`).
- **Live Admin Dashboard:** View real-time campus statistics.
- **Track Live Data:** Monitor total users, lost items, and found items directly fetched from Firebase.
- **Digital Inventory:** Replaces paper registers with a smart cloud database.

---

## 🛠️ Technology Stack

- **Frontend:** [Flutter](https://flutter.dev/) (UI Framework) & [Dart](https://dart.dev/) (Programming Language)
- **Backend & Database:** [Firebase Cloud Firestore](https://firebase.google.com/docs/firestore) (NoSQL Database)
- **Authentication:** [Firebase Auth](https://firebase.google.com/docs/auth) (Email & Password login)
- **State Management:** [Provider](https://pub.dev/packages/provider) Pattern
- **Image Hosting:** [ImgBB API](https://api.imgbb.com/) (Free cloud image storage)
- **Device Integration:** `image_picker` (Camera/Gallery), `url_launcher` (WhatsApp/Calls), `share_plus` (Sharing posts)

---

## 📂 Project Structure

```text
lib/
│── main.dart                  # Application entry point
│── models/                    # Data models (UserModel, LostItem, FoundItem)
│── providers/                 # State management (AuthProvider, ItemProvider)
│── screens/                   
│   ├── admin/                 # Admin Dashboard & Statistics
│   ├── auth/                  # Login & Registration Screens
│   ├── dashboard/             # Home Screen & Notifications
│   ├── found_items/           # Report Found Item & Feed
│   ├── lost_items/            # Report Lost Item
│   ├── profile/               # User Profile & My Posts
│   └── search/                # Search Functionality
└── utils/                     # App Theme & Constants
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / VS Code
- A valid Firebase Project (already configured via `google-services.json`)

### Installation
1. **Clone the repository:**
   ```bash
   git clone https://github.com/jinalmore019/university_Lost-Found.git
   ```
2. **Navigate to the directory:**
   ```bash
   cd university_Lost-Found
   ```
3. **Install dependencies:**
   ```bash
   flutter pub get
   ```
4. **Run the application:**
   ```bash
   flutter run
   ```

---

## 📱 Screenshots
*(You can upload real screenshots to GitHub and replace these placeholders later)*

| Login Screen | Public Feed | Admin Dashboard |
| :---: | :---: | :---: |
| <img src="https://via.placeholder.com/200x400.png?text=Login" width="200"/> | <img src="https://via.placeholder.com/200x400.png?text=Feed" width="200"/> | <img src="https://via.placeholder.com/200x400.png?text=Admin" width="200"/> |

---

## 🤝 Contributing
Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/jinalmore019/university_Lost-Found/issues).

## 📝 License
This project is designed for educational and university purposes.
