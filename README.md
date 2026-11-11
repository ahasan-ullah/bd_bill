<p align="center">
  <img src="assets/images/logo.png" width="120" height="120" alt="BD Bill Logo" />
</p>

<h1 align="center">BD Bill</h1>

<p align="center">
  <strong>Smart Electricity Bill Calculator & Invoice Generator for Bangladesh</strong>
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter" /></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" /></a>
  <a href="https://riverpod.dev"><img src="https://img.shields.io/badge/State-Riverpod-blueviolet?style=for-the-badge" alt="Riverpod" /></a>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-2ea44f?style=for-the-badge" alt="Platforms" />
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="License" />
</p>

<p align="center">
  A modern, high-performance Flutter application designed to calculate domestic electricity bills accurately based on Bangladesh Energy Regulatory Commission (BERC) tariff slab structures across all distribution utilities (<b>DESCO</b>, <b>DPDC</b>, <b>BPDB</b>, <b>NESCO</b>, <b>BREB</b>, and <b>WZPDCL</b>).
</p>

---

## ✨ Features

- ⚡ **Accurate Tiered Slab Engine** — Automatically computes progressive step-by-step charges through residential (LT-A) tariff tiers.
- ⚙️ **Customizable Billing Parameters** — Adjust connected sanctioned load (kW), demand charge, meter rent, and VAT percentage on the fly.
- 📊 **Real-time Itemized Breakdown** — Detailed insights displaying units consumed, applicable slab rates, and subtotal per tier.
- 📄 **Professional PDF Invoice Export** — Generate, preview, share, and print itemized bills with native Bengali typography (`Noto Sans Bengali`).
- 🔄 **Reactive State Management** — Powered by Flutter Riverpod for seamless, lag-free UI state updates.
- 📱 **Clean Material Design 3** — Intuitive, elegant interface tailored for both Android and iOS devices.
- 📴 **100% Offline-First** — Performs all computations locally without requiring an active internet connection.

---

## 📋 Bangladesh Residential Tariff Structure (LT-A)

The app comes preconfigured with the latest standard residential slabs:

| Slab Tier | Range (Units) | Rate per Unit (BDT ৳) |
| :--- | :---: | :---: |
| **Slab 1** | 0 – 75 units | ৳ 5.26 |
| **Slab 2** | 76 – 200 units | ৳ 8.50 |
| **Slab 3** | 201 – 300 units | ৳ 9.10 |
| **Slab 4** | 301 – 400 units | ৳ 9.62 |
| **Slab 5** | 401 – 600 units | ৳ 15.01 |
| **Slab 6** | Above 600 units | ৳ 17.35 |

> **Note:** Additional parameters such as **Demand Charge** (৳42/kW/month), **Meter Rent** (৳40/month), and **VAT** (5%) are fully customizable in the settings screen.

---

## 🧮 How It Works

```text
┌────────────────────────────────────────────────────────┐
│                   CALCULATION FLOW                     │
├────────────────────────────────────────────────────────┤
│ 1. Energy Charge  = Σ (Units in Slab  ×  Slab Rate)    │
│ 2. Demand Charge  = Sanctioned Load (kW) × Rate/kW     │
│ 3. Subtotal       = Energy Charge + Demand + Meter Rent│
│ 4. Government VAT = Subtotal × VAT Rate (5%)           │
│ 5. Total Payable  = Subtotal + VAT                     │
└────────────────────────────────────────────────────────┘
```

---

## 📁 Project Architecture

```
lib/
├── main.dart               # App entrypoint with Riverpod ProviderScope
├── models/
│   ├── bill_result.dart    # Calculation output & slab breakdown model
│   ├── bill_settings.dart  # Configurable rates, VAT, and charges
│   └── tariff_slab.dart    # Slab range & unit rate data model
├── screens/
│   ├── home_screen.dart           # Bottom navigation coordinator
│   ├── calculator_screen.dart     # Quick calculation input interface
│   ├── bill_breakdown_screen.dart # Detailed itemized statement
│   └── rates_screen.dart          # Tariff configuration & management
├── services/
│   ├── bill_calculator.dart       # Core mathematical slab calculation engine
│   ├── rate_loader_service.dart   # JSON tariff asset loader
│   └── pdf_invoice_service.dart   # PDF invoice rendering & printing engine
├── state/
│   └── bill_provider.dart         # Reactive state notifier
├── utils/
│   ├── app_colors.dart            # Consistent design system palette
│   └── formatters.dart            # Currency & number formatting helpers
└── widget/                        # Reusable modular UI components
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version `3.11.4` or higher)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / VS Code with Flutter extension
- An Android/iOS device or emulator

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ahasan-ullah/bd_bill.git
   cd bd_bill
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

4. **Build APK for Android:**
   ```bash
   flutter build apk --release
   ```

---

## 🛠️ Tech Stack & Packages

- **Framework:** [Flutter](https://flutter.dev)
- **Language:** [Dart](https://dart.dev)
- **State Management:** [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod)
- **PDF Generation & Printing:** [`pdf`](https://pub.dev/packages/pdf), [`printing`](https://pub.dev/packages/printing)
- **Formatting & Localization:** [`intl`](https://pub.dev/packages/intl)
- **Path Utilities:** [`path_provider`](https://pub.dev/packages/path_provider)
- **Icons:** [`cupertino_icons`](https://pub.dev/packages/cupertino_icons)

---

## 📄 License

This project is open-source and licensed under the [MIT License](LICENSE).

---

<p align="center">
  Developed by <a href="https://github.com/ahasan-ullah"><b>Ahasan Ullah</b></a>
</p>
