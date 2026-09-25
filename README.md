# University Lost & Found App

A complete Flutter application for university students and staff to report and find lost items.

## 🚀 Features

- **Public Feed:** View all lost and found items reported across the campus.
- **Report Lost Item:** Report an item you've lost, upload an image, and provide contact details (WhatsApp/Call).
- **Report Found Item:** Report an item you've found. You can either keep it with you (private verification questions) or deposit it at a physical location (Security Desk, Library, HOD Office, etc.).
- **Smart Claiming:** Claim items directly via WhatsApp or Phone Call.
- **Admin Dashboard:** Specific email keywords (`admin`, `hod`, `security`, `library`) automatically grant Admin access, unlocking a live statistics dashboard to track campus activity.
- **Firebase Backend:** Real-time data sync using Firebase Authentication and Cloud Firestore.
- **Modern UI:** Built with an attractive gradient design and responsive components.

## 🛠 Tech Stack

- **Frontend:** Flutter & Dart
- **Backend:** Firebase (Authentication & Firestore)
- **Image Hosting:** ImgBB API
- **State Management:** Provider

## ⚙️ Setup Instructions

1. Clone this repository:
   ```bash
   git clone https://github.com/jinalmore019/university_Lost-Found.git
   ```
2. Navigate into the folder:
   ```bash
   cd university_Lost-Found
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## 🔒 Admin Access

To access the Live Admin Dashboard, register a new account using an email containing any of the following keywords:
- `admin`
- `security`
- `hod`
- `library`
- `librarian`

Example: `security@university.edu`

## 👨‍💻 Author
Developed for the University Campus to digitize and simplify the Lost & Found process.
