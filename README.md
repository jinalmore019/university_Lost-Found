# 🎓 University Lost & Found App

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Provider](https://img.shields.io/badge/Provider-State_Management-blueviolet?style=for-the-badge)

Welcome to the **University Lost & Found App**, a comprehensive, real-time Flutter application engineered specifically for modern educational campuses. This platform digitizes and optimizes the traditional lost-and-found process, replacing outdated paper ledgers with a fast, secure, and user-friendly digital ecosystem. 

Whether a student loses an expensive smartwatch on the grounds or a staff member finds a misplaced ID card in the library, this application bridges the communication gap instantly.

---

## 🌟 Comprehensive Feature Set

### 👨‍🎓 For Students and Campus Staff (User Role)
* **Secure Authentication:** Seamless Registration and Login flows utilizing Firebase Authentication. User data (Name, Email, Phone) is stored securely.
* **Unified Public Feed:** A dynamically updating feed (using `FutureBuilder` and `Provider`) that showcases all items lost or found across the university. The feed is logically divided into two intuitive tabs: *Lost Items* and *Found Items*.
* **Advanced Reporting Mechanics:**
  * **Report Lost Items:** Users can submit detailed reports of what they lost, including the item's category, color, last known location, date, and a cloud-hosted image.
  * **Report Found Items (Smart Deposit):** When a user finds an item, they have two distinct choices:
    1. **Keep it with them:** The app enforces a "Verification Questions" system to ensure the item is returned only to its rightful owner.
    2. **Deposit it:** If the user deposits the item at a designated campus location (e.g., Security Desk, HOD Office, Library), the app intelligently hides the verification questions and instead instructs the owner on where to physically collect their item.
* **Smart Contacting System:** By leveraging the `url_launcher` package, users can connect with each other with a single tap. The app dynamically generates WhatsApp chat links or initiates direct Phone Calls based on the registered contact details.
* **Share Functionality:** Users can share lost/found posts to other social platforms directly from the app using the `share_plus` package, increasing the chances of recovery.

### 🛡️ For University Authorities (Admin Role)
To accommodate university hierarchies without complex backend admin panels, the app features an **Automated Role Assignment System**. 
* **Dynamic Authorization:** If a user registers with an email containing authorized keywords (`admin`, `security`, `hod`, `library`, `librarian`), the system automatically elevates their account privileges to **Admin**.
* **Live Admin Dashboard:** Admins have exclusive access to a real-time statistical dashboard. They can monitor live metrics fetched directly from Firebase, such as:
  * Total Registered Users on Campus
  * Total Lost Items Reported
  * Total Found Items Reported
* **Centralized Digital Inventory:** Reduces administrative overhead for security guards and staff by keeping a digital trail of all deposited items.

---

## 🛠️ Advanced Technology Stack & Architecture

This project is built using industry-standard tools to ensure high performance, scalability, and maintainability.

* **Frontend Framework:** [Flutter](https://flutter.dev/) (Cross-platform UI toolkit)
* **Programming Language:** [Dart](https://dart.dev/) (Object-oriented, client-optimized language)
* **Backend Backend-as-a-Service (BaaS):** [Firebase](https://firebase.google.com/)
  * **Authentication:** Secure email/password login system.
  * **Cloud Firestore:** A NoSQL cloud database that syncs data across all clients in real-time.
* **State Management:** [Provider](https://pub.dev/packages/provider)
  * The app employs a robust state management architecture utilizing `ChangeNotifierProvider` (`AuthProvider` and `ItemProvider`) to efficiently manage user sessions, loading states, and live data fetching without unnecessary widget rebuilds.
* **Media & APIs:**
  * **Image Picker:** For capturing or selecting images from the device gallery.
  * **ImgBB API:** Instead of cluttering Firebase Storage, images are efficiently uploaded to ImgBB's cloud servers via HTTP POST requests, and the resulting URLs are stored in Firestore for rapid retrieval.

---

## 📂 Deep Dive into Project Structure

The codebase strictly follows a modular, feature-first directory structure, making it highly scalable and easy to navigate:

```text
lib/
│── main.dart                  # App entry point, Firebase init & Route definitions
│── models/                    
│   └── models.dart            # Centralized Data Classes (UserModel, LostItem, FoundItem)
│── providers/                 
│   ├── auth_provider.dart     # Handles Firebase Auth, Role assignment, and User State
│   └── item_provider.dart     # Handles Firestore queries and Real-time Feed State
│── screens/                   
│   ├── admin/                 
│   │   └── admin_dashboard_screen.dart  # Live Statistics UI for Authorities
│   ├── auth/                  
│   │   ├── login_screen.dart            # Login UI with password visibility toggle
│   │   └── register_screen.dart         # Registration UI
│   ├── dashboard/             
│   │   ├── home_screen.dart             # Bottom Navigation Bar controller
│   │   └── notifications_screen.dart    # (Upcoming) Notifications logic
│   ├── found_items/           
│   │   ├── feed_screen.dart             # Core Public Feed (Lost & Found Tabs)
│   │   └── report_found_item_screen.dart# Form logic & ImgBB API integration
│   ├── lost_items/            
│   │   └── report_lost_item_screen.dart # Form logic for lost items
│   ├── profile/               
│   │   └── profile_screen.dart          # User details, role detection, & My Posts
│   └── search/                
│       └── search_screen.dart           # Search functionality
└── utils/                     
    └── theme.dart             # Global application theming (Colors, Fonts, Inputs)
```

---

## 🚀 Setup & Installation Instructions

Follow these steps to deploy the application on your local machine:

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and added to PATH.
* [Dart SDK](https://dart.dev/get-dart) installed.
* An IDE (Android Studio, VS Code, or IntelliJ).
* A physical device or Emulator for testing.

### Running the Project
1. **Clone the repository:**
   ```bash
   git clone https://github.com/jinalmore019/university_Lost-Found.git
   ```
2. **Navigate to the project directory:**
   ```bash
   cd university_Lost-Found
   ```
3. **Fetch all dependencies:**
   ```bash
   flutter pub get
   ```
4. **Compile and Run:**
   ```bash
   flutter run
   ```

---

## 🔮 Future Enhancements (Roadmap)
While the core functionality is robust and complete, the architecture is designed to support future expansions:
- **Push Notifications:** Integrating Firebase Cloud Messaging (FCM) to alert users when an item matching their lost report is found.
- **In-App Chat System:** A dedicated messaging interface to communicate without relying on third-party apps like WhatsApp.
- **Advanced Admin Controls:** Allowing admins to physically mark items as "Claimed" and archive old posts to keep the database clean.

---

## 📝 License & Disclaimer
This project is open-source and specifically tailored for educational institutions. The codebase serves as a prime example of integrating Flutter with Firebase to solve real-world campus problems.
