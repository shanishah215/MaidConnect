# 🏠 MaidConnect

[![Live Demo](https://img.shields.io/badge/Live-Demo-brightgreen?style=for-the-badge&logo=firebase)](https://maidconnect-96878.web.app/)
[![Flutter](https://img.shields.io/badge/Flutter-v3.10.x-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=for-the-badge&logo=firebase)](https://firebase.google.com)

## 🌟 Overview

**MaidConnect** is a comprehensive professional management platform built with **Flutter** and **Firebase**. It bridges the gap between households and verified professionals (maids, cooks, childcare providers, etc.) through a seamless, dual-portal experience.

### 🌐 [Live Application Link](https://maidconnect-96878.web.app/)

---

## 🚀 Key Features

### 👤 Client Portal
- **Professional Discovery**: Browse verified domestic support profiles with ease.
- **Advanced Filtering**: Filter by skills (Cooking, Childcare, Cleaning, etc.), availability, and location.
- **Shortlisting**: Save your favorite profiles for quick access later.
- **Real-time Requests**: Send callback or hire requests and track their status in real-time.
- **Dynamic Dashboard**: Personalized view of your active requests and shortlisted professionals.

### 🛡️ Admin Panel
- **Maid Management**: Comprehensive CRUD operations for domestic professional profiles.
- **Client Oversight**: Manage registered clients and their authentication status.
- **Inquiry Processing**: Centralized dashboard to view and respond to hire/service inquiries.
- **Real-time Analytics**: Quick insights into available professionals and active requests.

---

## 🛠️ Technical Stack

- **Core**: Flutter (Dart)
- **State Management**: Reactive Stream-based state for real-time synchronization.
- **Backend**: 
  - **Firebase Auth**: Secure role-based authentication.
  - **Cloud Firestore**: Real-time NoSQL database for data persistence.
  - **Firebase Storage**: Secure hosting for profile images and documents.
- **Navigation**: `go_router` for modern URL-based routing (Web optimized).
- **Styling**: Google Fonts (Inter/Outfit) and custom premium UI components.

---

## 📦 Getting Started

### Prerequisites
- Flutter SDK (v3.10+)
- Dart SDK
- A Firebase project configured for Web/Mobile

### Installation
1.  **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/maidconnect.git
    cd maidconnect
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the application**:
    ```bash
    flutter run -d chrome  # For Web
    # OR
    flutter run            # For Mobile
    ```

---

## 🔒 Security
MaidConnect implements robust role-based access control (RBAC). Both the **Admin Panel** and **Client Portal** are secured with authentication guards, ensuring that data is only accessible to authorized users.
