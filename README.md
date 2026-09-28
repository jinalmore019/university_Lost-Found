# 🎓 University Lost & Found App

A Flutter-based mobile application for college students and staff to report, find, and claim lost items within the university campus.

---

## 📱 Features

### 👤 Authentication
- **Register** with name, email, phone number & password
- **Login** with email and password
- **Forgot Password** — sends a password reset email via Firebase Authentication
- **Role-based access**: Admins (HOD, Security, Librarian, Admin) are identified by email keywords; everyone else is a regular user

---

### 🔍 Lost & Found Feed
- View all **Lost Items** reported by students/staff
- View all **Found Items** submitted by finders
- Each card shows item details, image, date, and location
- **Call** or **WhatsApp** the person directly from the app
- **Share** any post with one tap

---

### 📢 Report a Lost Item
- Fill in item name, category, color, description, location
- Optionally upload a photo (from camera or gallery)
- Image is uploaded to **ImgBB** for hosting
- Submitted to Firestore as a `lost_items` document

---

### 📦 Report a Found Item
- Fill in category, location, public description
- Set **deposit location** (e.g., Kept with me, HOD Office, Library, Security Desk, Admin Block)
- Add **Verification Questions** (only the true owner would know the answers) to prevent false claims
- Optionally upload a photo
- Submitted to Firestore as a `found_items` document

---

### ✅ Claiming System
- Any user can **Claim** a found item by answering the verification questions set by the finder
- Claim is saved to Firestore `claims` collection with status `PENDING`
- Admin is notified of new claims via the in-app notification system
- The found item status changes to `CLAIM_PENDING`

---

### 🔔 Notifications
- In-app notifications stored in Firestore `notifications` collection
- Notifications are sent when:
  - A new claim is submitted (admin is notified)
  - Admin **approves** a claim (both claimant and finder are notified)
  - Admin **rejects** a claim (claimant is notified)
- Viewable from the notification bell icon on the home screen

---

### 🛡️ Admin Dashboard
Only visible to users with admin role.

- **Live Stats**: Total users, lost items, found items, pending claims count
- **Manage Claims**: View all pending/approved/rejected claims, approve or reject them with one tap
- **Manage Users**: View all registered users, delete any user if needed

---

### 🗑️ Delete Your Own Post
- Users can delete their **own** Lost or Found posts
- Admins can delete **any** post
- A confirmation dialog prevents accidental deletion

---

## 🛠️ Tech Stack

| Technology | Usage |
|---|---|
| **Flutter** | Cross-platform UI framework |
| **Firebase Authentication** | Login, Register, Forgot Password |
| **Cloud Firestore** | Real-time database for all data |
| **Firebase Storage** (via ImgBB) | Image hosting |
| **Provider** | State management |
| **Google Fonts** | Typography |
| **Image Picker** | Camera & gallery access |
| **URL Launcher** | Call & WhatsApp integration |
| **Share Plus** | Sharing posts |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.x+)
- Firebase project with Authentication & Firestore enabled
- `google-services.json` placed in `android/app/`
- `GoogleService-Info.plist` placed in `ios/Runner/`

### Installation

```bash
git clone https://github.com/jinalmore019/university_Lost-Found.git
cd university_Lost-Found
flutter pub get
flutter run
```

---

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point, routing & providers
├── models/
│   └── models.dart              # UserModel, LostItem, FoundItem, Claim, VerificationQuestion
├── providers/
│   ├── auth_provider.dart       # Login, Register, Forgot Password, Logout
│   └── item_provider.dart       # Fetch, Add, Delete Lost & Found items
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── dashboard/
│   │   ├── home_screen.dart
│   │   └── notifications_screen.dart
│   ├── found_items/
│   │   ├── feed_screen.dart
│   │   ├── report_found_item_screen.dart
│   │   └── claim_item_screen.dart
│   ├── lost_items/
│   │   └── report_lost_item_screen.dart
│   └── admin/
│       ├── admin_dashboard_screen.dart
│       ├── manage_claims_screen.dart
│       └── manage_users_screen.dart
└── utils/
    └── theme.dart               # App-wide theme configuration
```

---

## 🔥 Firestore Collections

| Collection | Description |
|---|---|
| `users` | Registered user profiles |
| `lost_items` | Lost item reports |
| `found_items` | Found item reports with verification questions |
| `claims` | Claims submitted by users for found items |
| `notifications` | In-app notifications for users and admins |

---

## 👨‍💻 Developer

**Jinal More**  
[github.com/jinalmore019](https://github.com/jinalmore019)
