<div align="center">

# 🎓 University Lost & Found

### A Smart Flutter Application for Campus Item Recovery

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/jinalmore019/university_Lost-Found?style=for-the-badge&logo=github)](https://github.com/jinalmore019/university_Lost-Found/stargazers)

> Helping students and staff at DDU (Dharmsinh Desai University) recover their lost belongings through a streamlined, verification-based digital platform.

</div>

---

## 📌 Problem Statement

Every day, students and staff lose valuable items on campus — wallets, ID cards, laptops, water bottles, and more. Currently, there is **no centralized system** to report or find these items. People rely on WhatsApp groups or notice boards, which are inefficient and easily overlooked.

**University Lost & Found** solves this by providing a dedicated mobile app where:
- Lost items can be reported with full details and photos
- Found items can be posted with **secret verification questions** to prevent false claims
- Admins can oversee the claim process and manage the platform

---

## ✨ Key Features

<table>
<tr>
<td width="50%">

### 🔐 Authentication System
- Secure **Email & Password** login
- New user **Registration** with name, phone & email
- **Forgot Password** — Firebase-powered email reset
- **Role-based access** — Admins identified automatically via email keywords (`admin`, `hod`, `security`, `library`)

</td>
<td width="50%">

### 📋 Lost & Found Feed
- Real-time list of all **Lost Items** reported on campus
- Real-time list of all **Found Items** submitted by finders
- Each post shows image, category, location, date & contact info
- **Call** or **WhatsApp** the reporter directly from the app
- **Share** any post with friends via native share sheet

</td>
</tr>
<tr>
<td width="50%">

### 📢 Report Lost Item
- Enter item name, category, color, description
- Select from predefined **campus locations** (CE Dept, Library, Canteen, Hostel, etc.)
- Upload photo from **camera or gallery**
- Image automatically hosted via **ImgBB API**

</td>
<td width="50%">

### 📦 Report Found Item
- Describe found item publicly (category, location, date)
- Set **deposit location** (Kept with me / HOD Office / Admin Block / Library / Security)
- Add **Verification Questions** — only the true owner should know the answers (e.g., "What was in the side pocket?")
- Prevents false and fraudulent claims

</td>
</tr>
<tr>
<td width="50%">

### ✅ Smart Claim System
- Users can **Claim a Found Item** by answering verification questions
- System scores answers — Full match, partial match, or fail
- Claim saved to Firestore with `PENDING` status
- Admin is **automatically notified** of every new claim
- Found item status changes to `CLAIM_PENDING` after submission

</td>
<td width="50%">

### 🔔 In-App Notifications
- All notifications stored in Firestore `notifications` collection
- Triggered automatically when:
  - A new claim is submitted → **Admin notified**
  - Admin approves a claim → **Both claimant & finder notified**
  - Admin rejects a claim → **Claimant notified**
- Accessible via 🔔 bell icon on home screen

</td>
</tr>
<tr>
<td width="50%">

### 🛡️ Admin Dashboard
- Live stats: **Total Users, Lost Items, Found Items, Pending Claims**
- **Manage Claims** — view all claims, approve ✅ or reject ❌ with one tap
- Auto-notifies users on approval/rejection
- **Manage Users** — view all registered users, delete if needed

</td>
<td width="50%">

### 🗑️ Delete Your Post
- Users can delete their **own** Lost or Found posts at any time
- Admins can delete **any** post from the platform
- Confirmation dialog prevents accidental deletion
- Instantly removed from Firestore and the UI

</td>
</tr>
</table>

---

## 🛠️ Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Frontend** | Flutter 3.x (Dart) | Cross-platform mobile app (Android & iOS) |
| **State Management** | Provider 6.x | Reactive state across screens |
| **Authentication** | Firebase Auth | Login, Register, Forgot Password |
| **Database** | Cloud Firestore | Real-time NoSQL database |
| **Image Hosting** | ImgBB API | Free image upload & hosting |
| **Fonts** | Google Fonts | Premium typography |
| **Media** | Image Picker | Camera & gallery image selection |
| **Communication** | URL Launcher | Call & WhatsApp deep links |
| **Social** | Share Plus | Native share functionality |

---

## 📁 Project Structure

```
college_lost_found/
├── lib/
│   ├── main.dart                          # App entry point, Provider setup, routing
│   │
│   ├── models/
│   │   └── models.dart                    # Data models: UserModel, LostItem, FoundItem, Claim
│   │
│   ├── providers/
│   │   ├── auth_provider.dart             # Auth: login, register, forgot password, logout
│   │   └── item_provider.dart             # Items: fetch, add, delete lost & found items
│   │
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart          # Login UI + forgot password handler
│   │   │   └── register_screen.dart       # New user registration
│   │   │
│   │   ├── dashboard/
│   │   │   ├── home_screen.dart           # Bottom nav: Feed, Report Lost, Report Found
│   │   │   └── notifications_screen.dart  # In-app notification list
│   │   │
│   │   ├── lost_items/
│   │   │   └── report_lost_item_screen.dart   # Form to report a lost item
│   │   │
│   │   ├── found_items/
│   │   │   ├── feed_screen.dart               # Lost & Found item feed (tabs)
│   │   │   ├── report_found_item_screen.dart  # Form to report a found item
│   │   │   └── claim_item_screen.dart         # Claim form with verification questions
│   │   │
│   │   └── admin/
│   │       ├── admin_dashboard_screen.dart    # Live stats + navigation to manage screens
│   │       ├── manage_claims_screen.dart      # Admin: view & approve/reject claims
│   │       └── manage_users_screen.dart       # Admin: view & delete users
│   │
│   └── utils/
│       └── theme.dart                     # App-wide color theme & typography
│
├── assets/
│   └── images/
│       └── logo.png                       # App logo
│
├── android/                               # Android-specific config
├── ios/                                   # iOS-specific config
└── pubspec.yaml                           # Dependencies & assets
```

---

## 🔥 Firestore Database Schema

```
Firestore (Root)
│
├── users/
│   └── {userId}
│       ├── name: String
│       ├── email: String
│       ├── phone: String
│       ├── role: "user" | "admin"
│       └── createdAt: Timestamp
│
├── lost_items/
│   └── {itemId}
│       ├── ownerId: String
│       ├── itemName: String
│       ├── category: String
│       ├── description: String
│       ├── color: String
│       ├── location: String
│       ├── imageUrl: String
│       ├── status: "LOST" | "RETURNED" | "CLOSED"
│       └── lostDate: Timestamp
│
├── found_items/
│   └── {itemId}
│       ├── finderId: String
│       ├── category: String
│       ├── location: String
│       ├── publicDescription: String
│       ├── imageUrl: String
│       ├── status: "FOUND" | "CLAIM_PENDING" | "CLAIM_APPROVED" | "RETURNED"
│       ├── foundDate: Timestamp
│       └── verificationQuestions: Array
│           └── { question: String, answer: String }
│
├── claims/
│   └── {claimId}
│       ├── itemId: String
│       ├── claimantId: String
│       ├── finderId: String
│       ├── answers: Array<String>
│       ├── status: "PENDING" | "APPROVED" | "REJECTED"
│       ├── contactShared: Boolean
│       ├── finderHandoverConfirm: Boolean
│       ├── claimantHandoverConfirm: Boolean
│       └── createdAt: Timestamp
│
└── notifications/
    └── {notificationId}
        ├── userId: String
        ├── title: String
        ├── body: String
        ├── isRead: Boolean
        └── createdAt: Timestamp
```

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.x or above)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with Flutter extension
- A [Firebase Project](https://console.firebase.google.com/) with **Authentication** and **Firestore** enabled

### Step 1 — Clone the Repository

```bash
git clone https://github.com/jinalmore019/university_Lost-Found.git
cd university_Lost-Found
```

### Step 2 — Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/) → Create a project
2. Enable **Email/Password** Authentication
3. Enable **Cloud Firestore** (start in test mode)
4. Register your app (Android & iOS)
5. Download `google-services.json` → place in `android/app/`
6. Download `GoogleService-Info.plist` → place in `ios/Runner/`

### Step 3 — Install Dependencies

```bash
flutter pub get
```

### Step 4 — Run the App

```bash
flutter run
```

---

## 🔑 Admin Access

Users with the following keywords in their email are automatically granted **Admin** role:

| Keyword | Example |
|---|---|
| `admin` | admin@ddu.ac.in |
| `hod` | hod.ce@ddu.ac.in |
| `security` | security@ddu.ac.in |
| `library` / `librarian` | library@ddu.ac.in |

All other emails are treated as regular **Student/Staff** users.

---

## 📦 Dependencies

```yaml
dependencies:
  provider: ^6.1.5           # State management
  firebase_core: ^4.15.0     # Firebase initialization
  firebase_auth: ^6.7.0      # Authentication
  cloud_firestore: ^6.10.0   # Firestore database
  firebase_storage: ^13.6.0  # Firebase Storage (optional)
  image_picker: ^1.2.3       # Camera & gallery
  uuid: ^4.6.0               # Unique ID generation
  google_fonts: ^8.2.1       # Custom fonts
  url_launcher: ^6.3.2       # Call & WhatsApp links
  share_plus: ^13.3.0        # Native sharing
  http: ^1.6.0               # HTTP requests (ImgBB upload)
```

---

## 🤝 Contributing

Contributions are welcome! If you find a bug or want to suggest a feature:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

### ⭐ If this project helped you, please give it a star!

Made with ❤️ by **[Jinal More](https://github.com/jinalmore019)**

[![GitHub](https://img.shields.io/badge/GitHub-jinalmore019-181717?style=for-the-badge&logo=github)](https://github.com/jinalmore019)

</div>
